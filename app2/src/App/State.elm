port module App.State exposing (init, update, subscriptions)

import Task
import Time
import Navigation
import Json.Decode as Decode
import Json.Encode as Encode
import Rocket exposing ((=>))
import App.Types exposing (Model, Msg(..), Route(..), initialModel)
import App.Routes exposing (parseLocation)
import Shared.Animation as Animation
import Shared.List exposing (updateIf, updateOrAdd, generateId, findById, find)
import Shared.Types exposing (Article, Context, JWT, jwtDecoder, initialArticle)
import Shared.Service exposing (fetchArticleIfNecessary, fetchArticles, login, articleDecoder)
import Shared.Misc exposing (stringifyError, isLoggedIn)
import Shared.Update
    exposing
        ( initDispatch
        , dispatch
        , collect
        , withModel
        , mapUpdate
        , mapCmd
        , applyUpdates
        , evaluateMaybe
        , mapMainCmd
        , sendMessage
        , sendSingleMessage
        )
import Helper exposing (showInfo, showWarn, showError)
import Edit.State as EditState
import Edit.Types as EditTypes


-- INPUT PORTS


port storageInput : (Decode.Value -> msg) -> Sub msg



-- OUTPUT PORTS


port storage : Encode.Value -> Cmd msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ storageInput mapStorageInput
        , Time.every Time.second Tick
        ]


encodeContext : Context -> Encode.Value
encodeContext context =
    let
        articleEncoder article =
            Encode.object
                [ ( "id", Encode.string article.id )
                , ( "title", Encode.string article.title )
                , ( "content", Encode.string article.content )
                , ( "summary", Encode.string article.summary )
                ]

        encodedArticles =
            Encode.list <| List.map articleEncoder context.articles

        encodedToken =
            case context.jwt of
                Just jwt ->
                    Encode.object
                        [ ( "token", Encode.string jwt.token )
                        , ( "exp", Encode.float jwt.exp )
                        ]

                Nothing ->
                    Encode.null
    in
        Encode.object
            [ ( "articles", encodedArticles )
            , ( "jwt", encodedToken )
            , ( "isLoggedIn", Encode.bool context.isLoggedIn )
            ]


decodeContext : Decode.Value -> Result String Context
decodeContext =
    Decode.map3 Context
        (Decode.field "articles" (Decode.list articleDecoder))
        (Decode.field "jwt" (Decode.nullable jwtDecoder))
        (Decode.field "isLoggedIn" Decode.bool)
        |> Decode.decodeValue


mapStorageInput : Decode.Value -> Msg
mapStorageInput input =
    case decodeContext input of
        Ok context ->
            SetContext context

        Err errorMessage ->
            let
                _ =
                    Debug.log "Error in mapStorageInput:" errorMessage
            in
                NoOp


sendToStorage : Context -> Cmd Msg
sendToStorage context =
    encodeContext context |> storage


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        update (UrlChange location) (initialModel currentRoute)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newRoute =
                    parseLocation location

                newModel =
                    { model | route = newRoute }
            in
                case newRoute of
                    DashboardRoute ->
                        newModel => fetchArticles IncomingArticles

                    ArticleRoute id ->
                        newModel => fetchArticleIfNecessary id model.context IncomingArticle

                    EditRoute id ->
                        if model.context.isLoggedIn then
                            newModel => fetchArticles IncomingArticles
                        else
                            { model | route = DashboardRoute } => (Navigation.modifyUrl <| "/")

                    _ ->
                        newModel => Cmd.none

        SetUrl url ->
            model => (Navigation.newUrl <| "/#/" ++ url)

        SetContext context ->
            { model | context = context } => sendToStorage context

        ShowFlash flash ->
            let
                flashWithId =
                    { flash | id = generateId model.flashes }

                newModel =
                    { model | flashes = flashWithId :: model.flashes }
            in
                newModel => Animation.delayMessage 3000 (AnimationMsg flashWithId Animation.Initialize)

        RemoveFlash flash ->
            { model | flashes = List.filter (.id >> (/=) flash.id) model.flashes } => Cmd.none

        AnimationMsg flash animMsg ->
            let
                ( animation, animationCmd ) =
                    Animation.update animMsg flash.animation

                newFlash =
                    { flash | animation = animation }

                newModel =
                    { model | flashes = updateWithId newFlash model.flashes }

                nextCmd =
                    case animMsg of
                        Animation.End ->
                            Task.perform RemoveFlash (Task.succeed flash)

                        _ ->
                            Cmd.none
            in
                newModel
                    => Cmd.batch
                        [ Cmd.map (AnimationMsg flash) animationCmd
                        , nextCmd
                        ]

        EditMsg editMsg ->
            updateEdit editMsg model

        IncomingArticle (Ok article) ->
            publishArticle article model

        IncomingArticle (Err err) ->
            model => (showError <| stringifyError err)

        IncomingArticles (Ok articles) ->
            let
                ( newModel, newCmd ) =
                    foldUpdate publishArticle articles model

                editId =
                    Maybe.withDefault "" <| getEditRouteId newModel

                articleInContext =
                    findById editId newModel.context.articles

                firstArticle =
                    Maybe.withDefault initialArticle (List.head newModel.context.articles)

                currentArticle =
                    Maybe.withDefault firstArticle articleInContext

                ( newModelFromEdit, newCmdFromEdit ) =
                    updateEdit (EditTypes.SetArticle currentArticle) newModel
            in
                newModelFromEdit
                    => Cmd.batch
                        [ newCmd
                        , newCmdFromEdit
                        ]

        IncomingArticles (Err err) ->
            model => (showError <| stringifyError err)

        ShowLoginModal ->
            { model | showLoginModal = True } => Cmd.none

        CloseLoginModal ->
            { model | showLoginModal = False } => Cmd.none

        SetUsername username ->
            { model | username = username } => Cmd.none

        SetPassword password ->
            { model | password = password } => Cmd.none

        Login ->
            model => login model.username model.password LoginResponse

        Logout ->
            let
                context =
                    model.context

                newContext =
                    { context
                        | jwt = Nothing
                        , isLoggedIn = False
                    }
            in
                model => sendMessage SetContext newContext

        LoginResponse (Ok jwt) ->
            let
                context =
                    model.context

                newContext =
                    { context
                        | jwt = Just jwt
                        , isLoggedIn = True
                    }
            in
                model
                    => Cmd.batch
                        [ showInfo "Successfully logged in."
                        , sendSingleMessage CloseLoginModal
                        , sendMessage SetContext newContext
                        ]

        LoginResponse (Err err) ->
            model
                => Cmd.batch
                    [ (showError <| "Wrong login credentials!")
                    ]

        Tick time ->
            let
                context =
                    model.context

                newContext =
                    { context | isLoggedIn = isLoggedIn context time }
            in
                { model | currentTime = time } => sendMessage SetContext newContext

        NoOp ->
            model => Cmd.none


updateEdit : EditTypes.Msg -> Model -> ( Model, Cmd Msg )
updateEdit msg model =
    EditState.update msg model.editModel model.context
        |> withModel model
        |> mapUpdate (\childM mainM -> { mainM | editModel = childM })
        |> applyUpdates
        |> mapCmd EditMsg
        |> mapMainCmd


getEditRouteId : Model -> Maybe String
getEditRouteId model =
    case model.route of
        EditRoute id ->
            Just id

        _ ->
            Nothing


foldUpdate : (a -> Model -> ( Model, Cmd Msg )) -> List a -> Model -> ( Model, Cmd Msg )
foldUpdate updateFn list model =
    let
        foldMethod item ( lastModel, lastCmd ) =
            let
                ( newModel, newCmd ) =
                    updateFn item lastModel
            in
                newModel => Cmd.batch [ lastCmd, newCmd ]
    in
        List.foldl foldMethod ( model, Cmd.none ) list


publishArticle : Article -> Model -> ( Model, Cmd Msg )
publishArticle article model =
    let
        articles =
            updateOrAdd article model.context.articles

        context =
            model.context

        newContext =
            { context | articles = articles }

        editModel =
            model.editModel
    in
        { model | context = newContext } => Cmd.none


updateWithId : { a | id : b } -> List { a | id : b } -> List { a | id : b }
updateWithId item list =
    updateIf (.id >> (==) item.id) (always item) list

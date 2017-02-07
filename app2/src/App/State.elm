module App.State exposing (init, update)

import Task
import Http exposing (Response)
import Navigation
import Rocket exposing ((=>))
import App.Types exposing (Model, Msg(..), Route(..), initialModel)
import App.Routes exposing (parseLocation)
import Shared.Animation as Animation
import Shared.List exposing (updateIf, updateOrAdd, generateId, findById, find)
import Shared.Article exposing (Article, fetchArticle, fetchArticles)
import Shared.Update exposing (initDispatch, dispatch, collect, withModel, mapUpdate, mapCmd, applyUpdates)
import Helper exposing (showInfo, showWarn, showError)
import Edit.State as EditState
import Edit.Types as EditTypes


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        update (UrlChange location) (initialModel currentRoute)


updateRoute : Msg -> Model -> ( Model, Cmd Msg )
updateRoute msg model =
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
                        newModel => fetchArticle id IncomingArticle

                    EditRoute id ->
                        newModel => fetchArticles IncomingArticles

                    _ ->
                        newModel => Cmd.none

        _ ->
            model => Cmd.none


updateFlash : Msg -> Model -> ( Model, Cmd Msg )
updateFlash msg model =
    case msg of
        ShowFlash flash ->
            let
                flashWithId =
                    { flash | id = generateId model.flashes }

                newModel =
                    { model | flashes = flashWithId :: model.flashes }
            in
                newModel => Animation.delayMessage 2000 (AnimationMsg flashWithId Animation.Initialize)

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

        _ ->
            model => Cmd.none


incomingData : Msg -> Model -> ( Model, Cmd Msg )
incomingData msg model =
    case msg of
        IncomingArticle (Ok article) ->
            publishArticle article model

        IncomingArticle (Err err) ->
            model => (showError <| stringifyError err)

        IncomingArticles (Ok articles) ->
            foldUpdate publishArticle articles model

        IncomingArticles (Err err) ->
            model => (showError <| stringifyError err)

        _ ->
            model => Cmd.none


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

        newModel =
            case model.route of
                EditRoute id ->
                    if article.id == id then
                        { model | editModel = { editModel | article = article } }
                    else
                        model

                _ ->
                    model
    in
        { newModel | context = newContext } => Cmd.none


stringifyError : Http.Error -> String
stringifyError error =
    case error of
        Http.BadUrl url ->
            "Cannot not find URL '" ++ url ++ "'."

        Http.Timeout ->
            "The server does not respond."

        Http.BadStatus response ->
            "The server responded with a failure code "
                ++ toString response.status.code
                ++ ": "
                ++ response.status.message
                ++ "\n"
                ++ "Response body: "
                ++ (Debug.log "Response body" response.body)

        Http.BadPayload str response ->
            "Response could not be parsed: "
                ++ (Debug.log "Parse error" str)
                ++ "\n\nResponse body: "
                ++ (Debug.log "Response body" response.body)

        _ ->
            "Cannot connect to the sever."


updateContextArticle : Model -> Article -> Model
updateContextArticle model article =
    let
        articles =
            updateOrAdd article model.context.articles

        context =
            model.context

        newContext =
            { context | articles = articles }
    in
        { model | context = newContext }

updateEdit : Msg -> Model -> ( Model, Cmd Msg )
updateEdit msg model =
    case msg of
        EditMsg msg ->
            EditState.update msg model.editModel
                |> withModel model
                |> mapUpdate (\childM mainM -> { mainM | editModel = childM })
                |> mapUpdate (\childM mainM -> updateContextArticle mainM childM.article)
                |> applyUpdates
                |> mapCmd EditMsg

        _ ->
            model => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    initDispatch msg model
        |> dispatch updateRoute
        |> dispatch updateFlash
        |> dispatch incomingData
        |> dispatch updateEdit
        |> collect


updateWithId : { a | id : b } -> List { a | id : b } -> List { a | id : b }
updateWithId item list =
    updateIf (.id >> (==) item.id) (always item) list

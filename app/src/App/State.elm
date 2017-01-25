port module App.State exposing (..)

import Navigation
import App.Types exposing (..)
import App.Routes exposing (parseLocation)
import Article.Rest as ArticleService
import Article.State as ArticleState
import Dashboard.Rest as DashboardService
import Dashboard.State as DashboardState
import Login.State as LoginState
import Login.Types as Login
import Shared.Types exposing (FlashMessage(..), Context)
import Task
import Process
import Json.Decode as Decode
import Json.Encode as Encode


-- INPUT PORTS


port storageInput : (Decode.Value -> msg) -> Sub msg



-- OUTPUT PORTS


port storage : Encode.Value -> Cmd msg


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        update (UrlChange location) (initialModel currentRoute)


subscriptions : Model -> Sub Msg
subscriptions model =
    storageInput mapStorageInput


encodeContext : Context -> Encode.Value
encodeContext context =
    let
        encodedToken =
            case context.jwtToken of
                Just token ->
                    Encode.string token

                Nothing ->
                    Encode.null
    in
        Encode.object
            [ ( "jwtToken", encodedToken )
            ]


decodeContext : Decode.Value -> Result String Context
decodeContext =
    Decode.map Context
        (Decode.field "jwtToken" (Decode.nullable Decode.string))
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


sendToStorage : Model -> Cmd Msg
sendToStorage model =
    encodeContext model.context |> storage


updateContextWithToken : Maybe String -> Model -> ( Model, Cmd Msg )
updateContextWithToken token model =
    let
        context =
            model.context

        newContext =
            { context | jwtToken = token }

        newModel =
            { model | context = newContext }
    in
        ( newModel, sendToStorage newModel )


showFlash : FlashMessage -> Model -> ( Model, Cmd Msg )
showFlash flashMsg model =
    let
        oldFlashMessages =
            model.flashMessages

        removeTask =
            Task.perform RemoveFlash (Process.sleep 2000 |> Task.andThen (\_ -> Task.succeed flashMsg))
    in
        ( { model | flashMessages = flashMsg :: oldFlashMessages }, removeTask )


interpretLoginMsg : Maybe Login.OutMsg -> Model -> ( Model, Cmd Msg )
interpretLoginMsg msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )

        Just outMsg ->
            case outMsg of
                Login.Token token ->
                    updateContextWithToken (Just token) model

                Login.Flash flashMsg ->
                    showFlash flashMsg model


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
                    PostsRoute ->
                        ( newModel, Cmd.map DashboardMsg DashboardService.fetch )

                    PostRoute id ->
                        ( newModel, Cmd.map ArticleMsg (ArticleService.fetch id) )

                    _ ->
                        ( newModel, Cmd.none )

        ArticleMsg subMsg ->
            let
                ( newModel, cmd ) =
                    ArticleState.update subMsg model.articleModel
            in
                ( { model | articleModel = newModel }, Cmd.none )

        DashboardMsg subMsg ->
            let
                ( newModel, cmd ) =
                    DashboardState.update subMsg model.dashboardModel
            in
                ( { model | dashboardModel = newModel }, Cmd.none )

        LoginMsg subMsg ->
            let
                ( newLoginModel, newCmd, outMsg ) =
                    LoginState.update subMsg model.loginModel

                ( newModel, newOutCmd ) =
                    interpretLoginMsg outMsg model
            in
                { newModel | loginModel = newLoginModel } ! [ newOutCmd, Cmd.map LoginMsg newCmd ]

        RemoveFlash flashMsg ->
            ( { model | flashMessages = List.filter (\f -> f /= flashMsg) model.flashMessages }, Cmd.none )

        SetContext context ->
            ( { model | context = context }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

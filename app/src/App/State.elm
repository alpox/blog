module App.State exposing (..)

import Navigation

import App.Types exposing (..)
import App.Routes exposing (parseLocation)

import Article.Rest as ArticleService
import Article.State as ArticleState

import Dashboard.Rest as DashboardService
import Dashboard.State as DashboardState

import Login.State as LoginState

init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        update (UrlChange location) (initialModel currentRoute)

updateModelWithToken : Maybe String -> Model -> Model
updateModelWithToken token model =
    let 
        context = model.context
        newContext = { context | jwtToken = token }
    in
        { model | context = newContext }

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
                    PostsRoute -> (newModel, Cmd.map DashboardMsg DashboardService.fetch)
                    PostRoute id -> (newModel, Cmd.map ArticleMsg (ArticleService.fetch id))
                    _ -> (newModel, Cmd.none)

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
                ( newLoginModel, cmd, token ) =
                    LoginState.update subMsg model.loginModel
                newModel = updateModelWithToken token model
            in
                ( { newModel | loginModel = newLoginModel }, Cmd.map LoginMsg cmd )
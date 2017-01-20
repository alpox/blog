module App.State exposing (..)

import Navigation

import App.Types exposing (..)
import App.Routes exposing (parseLocation)

import Article.Rest as ArticleService
import Article.State as ArticleState

import Dashboard.Rest as DashboardService
import Dashboard.State as DashboardState

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
                    PostsRoute -> (newModel, Cmd.map DashboardMsg DashboardService.fetch)
                    PostRoute id -> (newModel, Cmd.map ArticleMsg (ArticleService.fetch id))
                    NotFoundRoute -> (newModel, Cmd.none)

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
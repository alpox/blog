module App.Types exposing (..)

import Navigation
import Article.Types as Article
import Dashboard.Types as Dashboard

type Msg
    = UrlChange Navigation.Location
    | ArticleMsg Article.Msg
    | DashboardMsg Dashboard.Msg

type Route
    = PostsRoute
    | PostRoute Article.PostId
    | NotFoundRoute

type alias Model =
    { route : Route
    , articleModel : Article.Model
    , dashboardModel : Dashboard.Model
    }

initialModel : Route -> Model
initialModel route =
    { route = route
    , articleModel = Article.initialModel
    , dashboardModel = Dashboard.initialModel }
module App.Types exposing (..)

import Navigation
import Article.Types as Article
import Dashboard.Types as Dashboard
import Login.Types as Login

type Msg
    = UrlChange Navigation.Location
    | ArticleMsg Article.Msg
    | DashboardMsg Dashboard.Msg
    | LoginMsg Login.Msg

type Route
    = PostsRoute
    | PostRoute Article.PostId
    | LoginRoute
    | NotFoundRoute

type alias Context =
    { jwtToken: Maybe String
    }

type alias Model =
    { route : Route
    , articleModel : Article.Model
    , dashboardModel : Dashboard.Model
    , loginModel : Login.Model
    , context : Context
    }

initialContext : Context
initialContext =
    { jwtToken = Nothing
    }

initialModel : Route -> Model
initialModel route =
    { route = route
    , articleModel = Article.initialModel
    , dashboardModel = Dashboard.initialModel
    , loginModel = Login.initialModel
    , context = initialContext
    }
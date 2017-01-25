module App.Types exposing (..)

import Navigation
import Article.Types as Article
import Dashboard.Types as Dashboard
import Login.Types as Login
import Shared.Types exposing (..)


type Msg
    = UrlChange Navigation.Location
    | RemoveFlash FlashMessage
    | ArticleMsg Article.Msg
    | DashboardMsg Dashboard.Msg
    | LoginMsg Login.Msg


type Route
    = PostsRoute
    | PostRoute Article.PostId
    | LoginRoute
    | NotFoundRoute


type alias Model =
    { route : Route
    , flashMessages : List FlashMessage
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
    , flashMessages = []
    , articleModel = Article.initialModel
    , dashboardModel = Dashboard.initialModel
    , loginModel = Login.initialModel
    , context = initialContext
    }

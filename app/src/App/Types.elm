module App.Types exposing (..)

import Navigation
import Article.Types as Article
import Dashboard.Types as Dashboard
import Login.Types as Login
import Edit.Types as Edit
import Shared.Types exposing (..)


type Msg
    = UrlChange Navigation.Location
    | RemoveFlash FlashMessage
    | ArticleMsg Article.Msg
    | DashboardMsg Dashboard.Msg
    | LoginMsg Login.Msg
    | EditMsg Edit.Msg
    | SetContext Context
    | NoOp


type Route
    = PostsRoute
    | PostRoute PostId
    | EditRoute PostId
    | LoginRoute
    | NotFoundRoute


type alias Model =
    { route : Route
    , flashMessages : List FlashMessage
    , articleModel : Article.Model
    , dashboardModel : Dashboard.Model
    , loginModel : Login.Model
    , editModel : Edit.Model
    , context : Context
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , flashMessages = []
    , articleModel = Article.initialModel
    , dashboardModel = Dashboard.initialModel
    , loginModel = Login.initialModel
    , editModel = Edit.initialModel
    , context = initialContext
    }

module App.Types exposing (Model, Msg(..), Route(..), Context, initialModel)

import Navigation
import Http
import Shared.Flash exposing (Flash)
import Shared.Animation as Animation
import Shared.Article exposing (Article)
import Edit.Types as Edit


type Route
    = DashboardRoute
    | ArticleRoute String
    | EditRoute String
    | NotFoundRoute


type alias Model =
    { route : Route
    , flashes : List Flash
    , editModel : Edit.Model
    , context : Context
    }

type alias Context =
    { articles : List Article
    }

type Msg
    = UrlChange Navigation.Location
    | ShowFlash Flash
    | RemoveFlash Flash
    | NewContext Context
    | IncomingArticle (Result Http.Error Article)
    | IncomingArticles (Result Http.Error (List Article))
    | AnimationMsg Flash Animation.Msg
    | EditMsg Edit.Msg

initialContext : Context
initialContext =
    { articles = [] }

initialModel : Route -> Model
initialModel route =
    { route = route
    , flashes = []
    , editModel = Edit.initialModel
    , context = initialContext
    }

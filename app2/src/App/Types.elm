module App.Types exposing (Model, Msg(..), Route(..), initialModel)

import Navigation
import Http
import Shared.Animation as Animation
import Shared.Types exposing (Article, Context, Flash, initialContext)
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


type Msg
    = UrlChange Navigation.Location
    | SetUrl String
    | ShowFlash Flash
    | RemoveFlash Flash
    | NewContext Context
    | IncomingArticle (Result Http.Error Article)
    | IncomingArticles (Result Http.Error (List Article))
    | AnimationMsg Flash Animation.Msg
    | EditMsg Edit.Msg


initialModel : Route -> Model
initialModel route =
    { route = route
    , flashes = []
    , editModel = Edit.initialModel
    , context = initialContext
    }

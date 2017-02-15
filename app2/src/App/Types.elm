module App.Types exposing (Model, Msg(..), Route(..), initialModel)

import Navigation
import Http
import Time exposing (Time)
import Shared.Animation as Animation
import Shared.Types exposing (Article, Context, JWT, Flash, initialContext)
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
    , showLoginModal : Bool
    , username : String
    , password : String
    , currentTime : Time
    }


type Msg
    = UrlChange Navigation.Location
    | SetUrl String
    | ShowFlash Flash
    | ShowLoginModal
    | CloseLoginModal
    | RemoveFlash Flash
    | SetContext Context
    | NewContext Context
    | IncomingArticle (Result Http.Error Article)
    | IncomingArticles (Result Http.Error (List Article))
    | AnimationMsg Flash Animation.Msg
    | EditMsg Edit.Msg
    | SetUsername String
    | SetPassword String
    | Login
    | Logout
    | LoginResponse (Result Http.Error JWT)
    | Tick Time
    | NoOp

initialModel : Route -> Model
initialModel route =
    { route = route
    , flashes = []
    , editModel = Edit.initialModel
    , context = initialContext
    , showLoginModal = False
    , username = ""
    , password = ""
    , currentTime = Time.second
    }

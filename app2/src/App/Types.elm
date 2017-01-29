module App.Types exposing (Model, Msg(..), initialModel)

import Shared.Flash exposing (Flash)
import Navigation


type alias Model =
    { text : String
    , flashes : List Flash
    }


type Msg
    = UrlChange Navigation.Location
    | ShowFlash Flash
    | RemoveFlash Flash


initialModel =
    { text = ""
    , flashes = []
    }

module App.Types exposing (Model, Msg(..), initialModel)

import Shared.Flash
import Navigation


type alias Model =
    { text : String
    }


type Msg
    = UrlChange Navigation.Location
    | ShowFlash Shared.Flash.Msg


initialModel =
    { text = ""
    }

module Shared.Flash exposing (..)

import Shared.Animation exposing (Animation)
import Shared.Style as Style


type Msg
    = Info String
    | Warn String
    | Error String


type alias Flash =
    { id : Int
    , message : Msg
    , animation : Animation Style.CssClasses
    }
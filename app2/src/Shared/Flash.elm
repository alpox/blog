module Shared.Flash exposing (..)

import Task
import Time


type Msg
    = Info String
    | Warn String
    | Error String


type alias Flash =
    { time : Time.Time
    , message : Msg
    }

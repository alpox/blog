module Shared.Types exposing (..)


type FlashMessage
    = Info String
    | Warn String
    | Error String


type alias Context =
    { jwtToken : Maybe String
    }

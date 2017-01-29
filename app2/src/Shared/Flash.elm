module Shared.Flash exposing (..)

import Task


type Msg
    = Info String
    | Warn String
    | Error String


message : msg -> Cmd msg
message x =
    Task.perform identity (Task.succeed x)


showInfo : String -> Cmd Msg
showInfo msg =
    message (Info msg)


showWarn : String -> Cmd Msg
showWarn msg =
    message (Warn msg)


showError : String -> Cmd Msg
showError msg =
    message (Error msg)

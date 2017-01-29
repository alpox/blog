module Helper exposing (..)

import App.Types exposing (Msg(..))
import Shared.Flash exposing (Flash)
import Task exposing (andThen, succeed)
import Time


showFlashCommand : Shared.Flash.Msg -> Cmd Msg
showFlashCommand msg =
    Time.now
        |> andThen (\time -> Flash time msg |> succeed)
        |> Task.perform ShowFlash


showInfo : String -> Cmd Msg
showInfo =
    Shared.Flash.Info >> showFlashCommand


showWarn : String -> Cmd Msg
showWarn =
    Shared.Flash.Warn >> showFlashCommand


showError : String -> Cmd Msg
showError =
    Shared.Flash.Error >> showFlashCommand

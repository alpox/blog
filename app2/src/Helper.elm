module Helper exposing ()

import App.State exposing (Msg(..))

import Shared.Flash

showFlashCommand : Cmd Shared.Flash.Msg -> Cmd Msg
showFlashCommand =
    Cmd.map ShowFlash

showFlash : String -> Cmd Msg
showFlash msg =
    Shared.Flash.showInfo >> showFlashCommand
module Helper exposing (..)

import App.Types exposing (Msg(..))
import Shared.Types exposing (Flash, FlashMsg(..))
import Shared.Style exposing (CssClasses(..))
import Task exposing (andThen, succeed)


createFlash : FlashMsg -> Flash
createFlash msg =
    { id = 0
    , message = msg
    , animation =
        { classes = [ FlashAnimationBase ]
        , config =
            { baseClass = FlashAnimationBase
            , animationClass = FlashAnimationAnimating
            , endClass = FlashAnimationDone
            , delay =
                { init = 0
                , animation = 1000
                }
            }
        }
    }


showFlashCommand : FlashMsg -> Cmd Msg
showFlashCommand msg =
    (Task.succeed <| createFlash msg)
        |> Task.perform ShowFlash


showInfo : String -> Cmd Msg
showInfo =
    Info >> showFlashCommand


showWarn : String -> Cmd Msg
showWarn =
    Warn >> showFlashCommand


showError : String -> Cmd Msg
showError =
    Error >> showFlashCommand
    
module Helper exposing (..)

import App.Types exposing (Msg(..), Context)
import Shared.Flash exposing (Flash)
import Shared.Style exposing (CssClasses(..))
import Task exposing (andThen, succeed)


createFlash : Shared.Flash.Msg -> Flash
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


showFlashCommand : Shared.Flash.Msg -> Cmd Msg
showFlashCommand msg =
    (Task.succeed <| createFlash msg)
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

updateContext : Context -> Cmd Msg
updateContext context =
    Task.succeed context
    |> Task.perform NewContext
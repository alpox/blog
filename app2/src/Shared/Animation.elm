module Shared.Animation exposing (..)

import Time exposing (Time)
import Task
import Process


type Msg
    = Initialize
    | Animate
    | End


type alias Animation a =
    { classes : List a
    , config : AnimationConfig a
    }


type alias AnimationConfig a =
    { baseClass : a
    , animationClass : a
    , endClass : a
    , delay : AnimationDelay
    }


type AnimationState
    = Init
    | Animating
    | Done


type alias AnimationDelay =
    { init : Time
    , animation : Time
    }


update : Msg -> Animation a -> ( Animation a, Cmd Msg )
update msg animation =
    let
        config =
            animation.config

        delay =
            config.delay

        updateClass classes =
            { animation | classes = classes }
    in
        case msg of
            Initialize ->
                ( updateClass [ config.baseClass ]
                , delayMessage delay.init Animate
                )

            Animate ->
                ( updateClass [ config.baseClass, config.animationClass, config.endClass ]
                , delayMessage delay.animation End
                )

            End ->
                ( updateClass [ config.baseClass, config.endClass ]
                , Cmd.none
                )


delayMessage : Time -> msg -> Cmd msg
delayMessage time msg =
    Process.sleep time
        |> Task.perform (always msg)

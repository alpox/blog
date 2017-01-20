module Main exposing (..)

import App.View exposing (..)
import App.State exposing (..)
import App.Types exposing (..)

import Navigation

main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
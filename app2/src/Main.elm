module Main exposing (..)

import Navigation
import Html exposing (Html, text)
import App.Style exposing (..)
import App.Types exposing (Model, Msg(..))
import App.View exposing (view)
import App.State exposing (init, update)


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

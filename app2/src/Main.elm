module Main exposing (..)

import Navigation
import Html exposing (Html, text)
import App.Style exposing (..)


type alias Model =
    { text : String
    }


type Msg
    = UrlChange Navigation.Location


initialModel =
    { text = ""
    }


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    text "test"

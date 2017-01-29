module App.State exposing (init, update)

import App.Types exposing (Model, Msg, initialModel)
import Navigation


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )

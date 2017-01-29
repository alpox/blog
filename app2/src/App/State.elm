module App.State exposing (init, update)

import Rocket exposing ((=>))
import App.Types exposing (Model, Msg(..), initialModel)
import Shared.Flash exposing (Flash)
import Task
import Navigation
import Process
import Time exposing (millisecond)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( initialModel
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ShowFlash flash ->
            newFlash model flash 2000

        RemoveFlash flash ->
            removeFlash model flash

        _ ->
            ( model, Cmd.none )


newFlash : Model -> Flash -> Float -> ( Model, Cmd Msg )
newFlash model flash duration =
    { model | flashes = flash :: model.flashes }
        => (Process.sleep (duration * millisecond)
                |> Task.andThen (\_ -> Task.succeed flash)
                |> Task.perform RemoveFlash
           )


removeFlash : Model -> Flash -> ( Model, Cmd Msg )
removeFlash model flash =
    { model | flashes = List.filter (\f -> f.time /= flash.time) model.flashes } => Cmd.none

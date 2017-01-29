module App.View exposing (view)

import App.Types exposing (Model, Msg)
import Html exposing (Html, text, div)
import Shared.Flash as Flash


view : Model -> Html Msg
view model =
    div [] <|
        List.map
            (\f ->
                case f.message of
                    Flash.Info msg ->
                        text msg

                    Flash.Error msg ->
                        text msg

                    Flash.Warn msg ->
                        text msg
            )
            model.flashes

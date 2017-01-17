module Main exposing (..)

import Html exposing (Html, button, div, text, h1)
import Html.CssHelpers
import Style


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"

main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Model =
    Int

model : Model
model = 0

-- UPDATE
type Msg = Dummy


update : Msg -> Model -> Model
update msg model = model

-- VIEW
view : Model -> Html Msg
view model =
    div [ class [ Style.Container ] ]
        [ div [ class [ Style.ProfilePicture ] ] []
        , h1 [] [ text "This is alpox' blog" ]
        ]

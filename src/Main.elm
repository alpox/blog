module Main exposing (..)

import Html exposing (Html, button, div, text, h1)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Style


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"


main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    Int


model : Model
model =
    0



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div [ class [ Style.Container ] ]
        [ div [ class [ Style.ProfilePicture ] ] []
        , h1 [] [ text "This is alpox' blog" ]
        ]

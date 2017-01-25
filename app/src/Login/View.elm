module Login.View exposing (view)

import Login.Types exposing (..)
import Login.Style as Style exposing (..)

import App.Types exposing (Context)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsLogin"

view : Model -> Context -> Html Msg
view model context =
    div [] [ input [ onInput UsernameChange, type_ "text", placeholder "Username" ] []
    , input [ onInput PasswordChange, type_ "password", placeholder "Password" ] []
    , button [ onClick Login ] [ text "Login" ]
    , text <| if context.jwtToken /= Nothing then "You are logged in." else "You are logged out."
    , text model.error
    ]
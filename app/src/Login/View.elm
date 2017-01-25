module Login.View exposing (view)

import Login.Types exposing (..)
import Login.Style as Style exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsLogin"


view : Model -> Html Msg
view model =
    div [ class [ Container ] ]
        [ input [ onInput UsernameChange, type_ "text", placeholder "Username", value model.username ] []
        , input [ onInput PasswordChange, type_ "password", placeholder "Password", value model.password ] []
        , button [ onClick Login ] [ text "Login" ]
        ]

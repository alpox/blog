module Login.View exposing (view)

import Login.Types exposing (..)
import Login.Style as Style exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers
import Shared.Types exposing (Context)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsLogin"


loginFrame : LoginCredentials -> List (Html Msg)
loginFrame model =
    [ input [ onInput UsernameChange, type_ "text", placeholder "Username", value model.username ] []
    , input [ onInput PasswordChange, type_ "password", placeholder "Password", value model.password ] []
    , button [ onClick Login ] [ text "Login" ]
    ]


view : Model -> Context -> Html Msg
view model context =
    div [ class [ Container ] ] <|
        if context.jwtToken == Nothing then
            loginFrame model.loginCredentials
        else
            [ text "Hahaaa!" ]

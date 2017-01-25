module Login.State exposing (update)

import Login.Types exposing (..)
import Login.Rest exposing (login)
import Shared.Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        -- Handle input events
        UsernameChange input ->
            ( { model | username = input }, Cmd.none, Nothing )

        PasswordChange input ->
            ( { model | password = input }, Cmd.none, Nothing )

        -- Handle login messages
        Login ->
            ( model, login model.username model.password, Nothing )

        LoginResponse (Ok token) ->
            ( model, Cmd.none, Just (Token token) )

        LoginResponse (Err _) ->
            ( model, Cmd.none, Just (Flash (Error "Incorrect login credentials!")) )

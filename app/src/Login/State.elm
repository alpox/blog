module Login.State exposing (update)

import Login.Types exposing (..)
import Login.Rest exposing (login)
import Shared.Types exposing (..)
import Navigation


updateUsername : String -> LoginCredentials -> LoginCredentials
updateUsername username cred =
    { cred | username = username }


updatePassword : String -> LoginCredentials -> LoginCredentials
updatePassword password cred =
    { cred | password = password }


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        -- Handle input events
        UsernameChange input ->
            ( { model | loginCredentials = updateUsername input model.loginCredentials }, Cmd.none, Nothing )

        PasswordChange input ->
            ( { model | loginCredentials = updatePassword input model.loginCredentials }, Cmd.none, Nothing )

        -- Handle login messages
        Login ->
            ( model, login model.loginCredentials.username model.loginCredentials.password, Nothing )

        LoginResponse (Ok token) ->
            ( model, Cmd.none, Just (Token token) )

        LoginResponse (Err _) ->
            ( model, Cmd.none, Just (Flash (Error "Incorrect login credentials!")) )

        -- Handle result of post
        Retrieve (Ok newPosts) ->
            ( { model | posts = newPosts }, Cmd.none, Nothing )

        Retrieve (Err error) ->
            ( model, Cmd.none, Just (Flash (Error "Was not able to fetch posts")) )

        SetPostTableState state ->
            ( { model | postTableState = state }, Cmd.none, Nothing )

        StartEdit post ->
            ( model, Cmd.none, Just (UrlChangeRequest <| "#/edit/" ++ post.id) )

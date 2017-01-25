module Login.Rest exposing (login)

import Util.Graphql exposing (query, withVariable, send)

import Json.Decode as Decode
import Json.Encode as Encode

import Login.Types exposing (Msg(..))

login : String -> String -> Cmd Msg
login username password =
    query """
    mutation($username: String!, $password: String!) {
        login(username: $username, password: $password) {
            token
        }
    }
    """
    |> withVariable ("username", Encode.string username)
    |> withVariable ("password", Encode.string password)
    |> send LoginResponse decoder

decoder : Decode.Decoder String
decoder =
    Decode.at [ "login", "token" ] Decode.string
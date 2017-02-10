module Shared.Misc exposing (stringifyError, isLoggedIn)

import Http
import Time exposing (Time)
import Shared.Types exposing (Context)

stringifyError : Http.Error -> String
stringifyError error =
    case error of
        Http.BadUrl url ->
            "Cannot not find URL '" ++ url ++ "'."

        Http.Timeout ->
            "The server does not respond."

        Http.BadStatus response ->
            "The server responded with a failure code "
                ++ toString response.status.code
                ++ ": "
                ++ response.status.message
                ++ "\n"
                ++ "Response body: "
                ++ (Debug.log "Response body" response.body)

        Http.BadPayload str response ->
            "Response could not be parsed: "
                ++ (Debug.log "Parse error" str)
                ++ "\n\nResponse body: "
                ++ (Debug.log "Response body" response.body)

        _ ->
            "Cannot connect to the sever."


getToken : Context -> Maybe String
getToken context =
    case context.jwt of
        Just jwt ->
            Just jwt.token
        Nothing ->
            Nothing

isLoggedIn : Context -> Time -> Bool
isLoggedIn context time =
    case context.jwt of
        Nothing -> False
        Just jwt -> jwt.exp > (time / 1000)
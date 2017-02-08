module Shared.Misc exposing (stringifyError)

import Http


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

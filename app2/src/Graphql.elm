module Graphql exposing (query, withVariable, withToken, send, toTask)

import Http
import Task exposing (Task)
import Json.Encode exposing (Value, object, string, object)
import Json.Decode as Decode


type alias Query =
    { query : String
    , variables : List (String, Value)
    , headers: List Http.Header }

defaultQuery : Query
defaultQuery =
    { query = ""
    , variables = []
    , headers = []
    }

createBody : Query -> Value 
createBody query =
    object
        [ ("query", string query.query)
        , ("variables", object query.variables)
        ]

query : String -> Query
query queryString =
    { defaultQuery | query = queryString }

withVariable : (String, Value) -> Query -> Query
withVariable var query =
    { query | variables = var :: query.variables }

withHeader : String -> String -> Query -> Query
withHeader key value query =
    { query | headers = Http.header key value :: query.headers }

withToken : String -> Query -> Query
withToken token query =
    withHeader "Authorization" ("Bearer " ++ token) query

postRequest : List Http.Header -> Http.Body -> Decode.Decoder a -> Http.Request a
postRequest headers body decoder =
    Http.request
    { method = "POST"
    , headers = headers
    , url = "/graphql"
    , body = body
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

send : (Result Http.Error a -> msg) -> Decode.Decoder a -> Query -> Cmd msg
send response decoder query =
    ((createBody query
    |> Http.jsonBody
    |> postRequest query.headers) <| queryDecoder decoder)
    |> Http.send response

toTask : Decode.Decoder a -> Query -> Task Http.Error a
toTask decoder query =
    ((createBody query
    |> Http.jsonBody
    |> postRequest query.headers) <| queryDecoder decoder)
    |> Http.toTask
    
queryDecoder : Decode.Decoder a -> Decode.Decoder a
queryDecoder decoder =
    Decode.at ["data"] decoder
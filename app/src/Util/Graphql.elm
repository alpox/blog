module Util.Graphql exposing (query, withVariable, send)

import Json.Encode exposing (Value, object, string, object)
import Json.Decode as Decode

import Http

type alias Query =
    { query : String
    , variables : List (String, Value) }

defaultQuery : Query
defaultQuery =
    { query = ""
    , variables = []
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

send : (Result Http.Error a -> msg) -> Decode.Decoder a -> Query -> Cmd msg
send response decoder query =
    ((createBody query
    |> Http.jsonBody
    |> Http.post "/graphql") <| queryDecoder decoder)
    |> Http.send response
    
queryDecoder : Decode.Decoder a -> Decode.Decoder a
queryDecoder decoder =
    Decode.at ["data"] decoder
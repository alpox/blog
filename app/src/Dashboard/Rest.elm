module Dashboard.Rest exposing (..)

import Article.Types exposing (Post)
import Dashboard.Types exposing (Msg(..))
import Json.Decode as Decode exposing (field)
import Json.Decode.Pipeline exposing (decode, optional, required)

import Util.Graphql exposing (query, withVariable, send)

fetch : Cmd Msg
fetch =
    query """
    {
        posts {
            id
            title
            summary
        }
    }
    """
    |> send Retrieve postDecoder

postDecoder : Decode.Decoder (List Post)
postDecoder =
    (decode Post
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> optional "content" Decode.string ""
        |> required "summary" Decode.string)
    |> Decode.list
    |> Decode.at ["posts"]
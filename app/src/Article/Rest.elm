module Article.Rest exposing (..)

import Article.Types exposing (..)
import Json.Decode as Decode exposing (field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Json.Encode as Encode

import Util.Graphql exposing (..)

fetch : PostId -> Cmd Msg
fetch id =
    query """
    query($id: ID!) {
        post(id: $id) {
            id
            title
            content
            summary
        }
    }
    """ 
    |> withVariable ("id", Encode.string id)
    |> send Retrieve postDecoder

postDecoder : Decode.Decoder Post
postDecoder =
    Decode.at ["post"] <| (decode Post
            |> optional "id" Decode.string "0"
            |> required "title" Decode.string
            |> required "content" Decode.string
            |> optional "summary" Decode.string "")
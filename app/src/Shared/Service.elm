module Shared.Service exposing (fetchPost, fetchPosts)

import Shared.Types exposing (..)
import Json.Decode as Decode exposing (field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Json.Encode as Encode
import Http
import Util.Graphql exposing (..)


fetchPosts : (Result Http.Error (List Post) -> msg) -> Cmd msg
fetchPosts messageType =
    query """
    {
        posts {
            id
            title
            summary
        }
    }
    """
        |> send messageType postsDecoder


fetchPost : PostId -> (Result Http.Error Post -> msg) -> Cmd msg
fetchPost id messageType =
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
        |> withVariable ( "id", Encode.string id )
        |> send messageType postDecoder


postDecoder : Decode.Decoder Post
postDecoder =
    Decode.at [ "post" ] <|
        (decode Post
            |> optional "id" Decode.string "0"
            |> required "title" Decode.string
            |> required "content" Decode.string
            |> optional "summary" Decode.string ""
        )


postsDecoder : Decode.Decoder (List Post)
postsDecoder =
    (decode Post
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> optional "content" Decode.string ""
        |> required "summary" Decode.string
    )
        |> Decode.list
        |> Decode.at [ "posts" ]

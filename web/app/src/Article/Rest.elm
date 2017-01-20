module Article.Rest exposing (..)

import Article.Types exposing (..)
import Json.Decode as Decode exposing (field)
import Http

fetch : PostId -> Cmd Msg
fetch id =
    Http.get ("/api/posts/" ++ id) postDecoder
        |> Http.send Retrieve

decodeId : Int -> Decode.Decoder PostId
decodeId decodeInt =
    toString decodeInt |> Decode.succeed

postDecoder : Decode.Decoder Post
postDecoder =
    Decode.map4 Post
        (field "id" Decode.int |> Decode.andThen decodeId)
        (field "title" Decode.string)
        (field "content" Decode.string)
        (field "summary" Decode.string)
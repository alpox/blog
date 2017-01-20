module Dashboard.Rest exposing (..)

import Article.Rest exposing (postDecoder)
import Dashboard.Types exposing (Msg(..))
import Json.Decode as Decode exposing (field)
import Http

fetch : Cmd Msg
fetch =
    Http.get "/api/posts" (Decode.list postDecoder)
        |> Http.send Retrieve
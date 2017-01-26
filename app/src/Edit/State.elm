module Edit.State exposing (..)

import Edit.Types exposing (..)
import Shared.Types exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        Retrieve (Ok newPost) ->
            ( { model | post = newPost }, Cmd.none, Nothing )

        Retrieve (Err error) ->
            ( model, Cmd.none, Just (Flash (Error "Post not found")) )

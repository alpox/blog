module Dashboard.State exposing (..)

import Dashboard.Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Retrieve (Ok newPosts) ->
            ( { model | posts = newPosts }, Cmd.none )

        Retrieve (Err error) ->
            ( model, Cmd.none )
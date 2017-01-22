module Article.State exposing (..)

import Article.Types exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Retrieve (Ok newPost) ->
            ( { model | post = Just newPost }, Cmd.none )

        Retrieve (Err error) ->
            ( { model | post = Nothing }, Cmd.none )
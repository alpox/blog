module Edit.View exposing (..)

import Html exposing (Html, text, div)
import Edit.Types exposing (..)
import Shared.Types exposing (..)


view : Model -> Context -> Html Msg
view { post } context =
    div []
        [ text post.id
        , text post.summary
        ]

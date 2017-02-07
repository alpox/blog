module Edit.State exposing (..)

import Rocket exposing ((=>))
import Edit.Types exposing (Msg(..), Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetArticle article ->
            { model | article = article } => Cmd.none

        TitleChange newTitle ->
            let
                article =
                    model.article

                newArticle =
                    { article | title = newTitle }
            in
                { model | article = newArticle } => Cmd.none

        ContentChange newContent ->
            let
                article =
                    model.article

                newArticle =
                    { article | content = newContent }
            in
                { model | article = newArticle } => Cmd.none

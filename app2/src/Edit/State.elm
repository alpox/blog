module Edit.State exposing (..)

import Task
import Edit.Types exposing (Msg(..), Model)
import App.Types as AppTypes
import Shared.Service as Service
import Shared.Misc exposing (stringifyError)
import Helper exposing (showInfo, showError)


update : Msg -> Model -> ( Model, Cmd Msg, Cmd AppTypes.Msg )
update msg model =
    case msg of
        SetUrl url ->
            ( model, Cmd.none, Task.perform AppTypes.SetUrl <| Task.succeed url )

        SetArticle article ->
            ( { model | article = article }, Cmd.none, Cmd.none )

        TitleChange newTitle ->
            let
                article =
                    model.article

                newArticle =
                    { article | title = newTitle }
            in
                ( { model | article = newArticle }, Cmd.none, Cmd.none )

        SummaryChange newSummary ->
            let
                article =
                    model.article

                newArticle =
                    { article | summary = newSummary }
            in
                ( { model | article = newArticle }, Cmd.none, Cmd.none )

        ContentChange newContent ->
            let
                article =
                    model.article

                newArticle =
                    { article | content = newContent }
            in
                ( { model | article = newArticle }, Cmd.none, Cmd.none )

        SaveArticle ->
            ( model, Service.updateArticle model.article ArticleUpdateResponse, Cmd.none )

        ArticleUpdateResponse (Ok article) ->
            ( { model | article = article }, Cmd.none, showInfo "Successfully saved article." )

        ArticleUpdateResponse (Err err) ->
            ( model, Cmd.none, showError <| stringifyError err )

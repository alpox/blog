module Edit.State exposing (..)

import Task
import Navigation
import Edit.Types exposing (Msg(..), Model)
import App.Types as AppTypes
import Shared.Service as Service
import Shared.Misc exposing (stringifyError)
import Shared.List exposing (updateOrAdd)
import Shared.Types exposing (initialArticle, Context, Article)
import Helper exposing (showInfo, showError)


update : Msg -> Model -> Context -> ( Model, Cmd Msg, Cmd AppTypes.Msg )
update msg model context =
    case msg of
        SetUrl url ->
            ( model, Cmd.none, Task.perform AppTypes.SetUrl <| Task.succeed url )

        SetArticle article ->
            ( { model | article = article }
            , Cmd.none
            , updateContextWithArticle article context
            )

        TitleChange newTitle ->
            let
                article =
                    model.article

                newArticle =
                    { article | title = newTitle }
            in
                ( { model | article = newArticle }
                , Cmd.none
                , updateContextWithArticle newArticle context
                )

        SummaryChange newSummary ->
            let
                article =
                    model.article

                newArticle =
                    { article | summary = newSummary }
            in
                ( { model | article = newArticle }
                , Cmd.none
                , updateContextWithArticle newArticle context
                )

        ContentChange newContent ->
            let
                article =
                    model.article

                newArticle =
                    { article | content = newContent }
            in
                ( { model | article = newArticle }
                , Cmd.none
                , updateContextWithArticle newArticle context
                )

        SaveArticle ->
            let
                cmd =
                    Service.updateOrInsertArticle model.article context ArticleUpdateResponse
            in
                ( model, cmd, showIfNotLoggedIn context )

        ArticleUpdateResponse (Ok article) ->
            let
                newContext =
                    { context | articles = updateOrAdd article <| List.filter (.id >> (/=) "new") context.articles }
            in
                ( { model | article = article }
                , Cmd.none
                , Cmd.batch
                    [ showInfo "Successfully saved article."
                    , updateContext newContext
                    , Navigation.modifyUrl <| "/#/edit/" ++ article.id
                    ]
                )

        ArticleUpdateResponse (Err err) ->
            ( model, Cmd.none, showError <| stringifyError err )

        ArticleDeleteResponse (Ok id) ->
            ( model, Cmd.none, showInfo <| "Article successfully deleted." )

        ArticleDeleteResponse (Err err) ->
            ( model, Cmd.none, showError <| stringifyError err )

        NewArticle ->
            ( { model | article = initialArticle }
            , Cmd.none
            , Cmd.batch
                [ updateContextWithArticle initialArticle context
                , Navigation.modifyUrl "/#/edit/new"
                ]
            )

        RemoveArticle ->
            let
                newContext =
                    { context | articles = List.filter (.id >> (/=) model.article.id) context.articles }
            in
                ( { model
                    | article = Maybe.withDefault initialArticle <| List.head newContext.articles
                    , deleteAttempt = False
                  }
                , deleteArticle model context
                , Cmd.batch
                    [ updateContext newContext
                    , showIfNotLoggedIn context
                    ]
                )

        AttemptRemoveArticle ->
            ( { model | deleteAttempt = True }, Cmd.none, Cmd.none )

        StopRemoveAttempt ->
            ( { model | deleteAttempt = False }, Cmd.none, Cmd.none )


showIfNotLoggedIn : Context -> Cmd AppTypes.Msg
showIfNotLoggedIn context =
    if context.isLoggedIn then
        Cmd.none
    else
        showError "You are not logged in!"


deleteArticle : Model -> Context -> Cmd Msg
deleteArticle model context =
    if model.article.id == "new" then
        Cmd.none
    else
        Service.deleteArticle model.article context ArticleDeleteResponse


updateContext : Context -> Cmd AppTypes.Msg
updateContext context =
    Task.perform AppTypes.SetContext <| Task.succeed context


updateContextWithArticle : Article -> Context -> Cmd AppTypes.Msg
updateContextWithArticle article context =
    let
        articles =
            updateOrAdd article context.articles
    in
        updateContext { context | articles = articles }

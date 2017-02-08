module App.State exposing (init, update)

import Task
import Http exposing (Response)
import Navigation
import Rocket exposing ((=>))
import App.Types exposing (Model, Msg(..), Route(..), initialModel)
import App.Routes exposing (parseLocation)
import Shared.Animation as Animation
import Shared.List exposing (updateIf, updateOrAdd, generateId, findById, find)
import Shared.Types exposing (Article)
import Shared.Service exposing (fetchArticleIfNecessary, fetchArticles)
import Shared.Misc exposing (stringifyError)
import Shared.Update exposing (initDispatch, dispatch, collect, withModel, mapUpdate, mapCmd, applyUpdates, evaluateMaybe, mapMainCmd)
import Helper exposing (showInfo, showWarn, showError)
import Edit.State as EditState
import Edit.Types as EditTypes


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            parseLocation location
    in
        update (UrlChange location) (initialModel currentRoute)



update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            let
                newRoute =
                    parseLocation location

                newModel =
                    { model | route = newRoute }
            in
                case newRoute of
                    DashboardRoute ->
                        newModel => fetchArticles IncomingArticles

                    ArticleRoute id ->
                        newModel => fetchArticleIfNecessary id model.context IncomingArticle

                    EditRoute id ->
                        newModel => fetchArticles IncomingArticles

                    _ ->
                        newModel => Cmd.none

        SetUrl url ->
            model => (Navigation.newUrl <| "/#/" ++ url)


        ShowFlash flash ->
            let
                flashWithId =
                    { flash | id = generateId model.flashes }

                newModel =
                    { model | flashes = flashWithId :: model.flashes }
            in
                newModel => Animation.delayMessage 2000 (AnimationMsg flashWithId Animation.Initialize)

        RemoveFlash flash ->
            { model | flashes = List.filter (.id >> (/=) flash.id) model.flashes } => Cmd.none

        AnimationMsg flash animMsg ->
            let
                ( animation, animationCmd ) =
                    Animation.update animMsg flash.animation

                newFlash =
                    { flash | animation = animation }

                newModel =
                    { model | flashes = updateWithId newFlash model.flashes }

                nextCmd =
                    case animMsg of
                        Animation.End ->
                            Task.perform RemoveFlash (Task.succeed flash)

                        _ ->
                            Cmd.none
            in
                newModel
                    => Cmd.batch
                        [ Cmd.map (AnimationMsg flash) animationCmd
                        , nextCmd
                        ]

        EditMsg msg ->
            EditState.update msg model.editModel
                |> withModel model
                |> mapUpdate (\childM mainM -> { mainM | editModel = childM })
                |> mapUpdate (\childM mainM -> updateContextArticle mainM childM.article)
                |> applyUpdates
                |> mapCmd EditMsg
                |> mapMainCmd

        IncomingArticle (Ok article) ->
            publishArticle article model

        IncomingArticle (Err err) ->
            model => (showError <| stringifyError err)

        IncomingArticles (Ok articles) ->
            foldUpdate publishArticle articles model

        IncomingArticles (Err err) ->
            model => (showError <| stringifyError err)

        _ ->
            model => Cmd.none


foldUpdate : (a -> Model -> ( Model, Cmd Msg )) -> List a -> Model -> ( Model, Cmd Msg )
foldUpdate updateFn list model =
    let
        foldMethod item ( lastModel, lastCmd ) =
            let
                ( newModel, newCmd ) =
                    updateFn item lastModel
            in
                newModel => Cmd.batch [ lastCmd, newCmd ]
    in
        List.foldl foldMethod ( model, Cmd.none ) list


publishArticle : Article -> Model -> ( Model, Cmd Msg )
publishArticle article model =
    let
        articles =
            updateOrAdd article model.context.articles

        context =
            model.context

        newContext =
            { context | articles = articles }

        editModel =
            model.editModel

        newModel =
            case model.route of
                EditRoute id ->
                    if article.id == id then
                        { model | editModel = { editModel | article = article } }
                    else
                        model

                _ ->
                    model
    in
        { newModel | context = newContext } => Cmd.none


updateContextArticle : Model -> Article -> Model
updateContextArticle model article =
    let
        articles =
            updateOrAdd article model.context.articles

        context =
            model.context

        newContext =
            { context | articles = articles }
    in
        { model | context = newContext }


updateWithId : { a | id : b } -> List { a | id : b } -> List { a | id : b }
updateWithId item list =
    updateIf (.id >> (==) item.id) (always item) list

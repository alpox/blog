module App.View exposing (view)

import Html exposing (Html, text, div, h1, h2, a, span)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Html.CssHelpers
import Rocket exposing ((=>))
import Shared.Markdown as Markdown
import Shared.Types exposing (Article, Context, Flash, FlashMsg(..))
import Shared.List exposing (findById)
import Shared.Style as SharedStyle
import App.Types exposing (Model, Msg(..), Route(..))
import App.Style as Style
import Edit.View as Edit


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"


flash : Flash -> Html Msg
flash flash =
    let
        ( flashTypeClass, msg ) =
            case flash.message of
                Info msg ->
                    SharedStyle.FlashInfo => msg

                Error msg ->
                    SharedStyle.FlashError => msg

                Warn msg ->
                    SharedStyle.FlashWarn => msg
    in
        div [ class <| flashTypeClass :: SharedStyle.Flash :: flash.animation.classes ]
            [ text msg
            ]


page : Model -> Html Msg
page model =
    case model.route of
        DashboardRoute ->
            dashboardView model.context

        ArticleRoute id ->
            case findById id model.context.articles of
                Just article ->
                    articleView article

                Nothing ->
                    text <| "Article with id " ++ id ++ " not found."

        _ ->
            text "Route not found"


dashboardArticle : Article -> Html Msg
dashboardArticle article =
    div [ class [ Style.DashboardArticle ], onClick <| SetUrl <| "article/" ++ article.id ]
        [ h2 [] [ text article.title ]
        , span [] [ text article.summary ]
        ]


dashboardView : Context -> Html Msg
dashboardView context =
    div [] <| List.map dashboardArticle context.articles


articleView : Article -> Html Msg
articleView article =
    div [ class [ Style.Article ] ]
        [ h1 [] [ text article.title ]
        , span [] [ Markdown.toHtml article.content ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class [ SharedStyle.FlashContainer ] ] <|
            List.map flash model.flashes
        , case model.route of
            EditRoute _ ->
                Html.map EditMsg <| Edit.view model.context model.editModel

            _ ->
                div [ class [ Style.PageFrame ] ]
                    [ page model
                    ]
        ]

module App.View exposing (view)

import Html exposing (Html, text, div, h1, h2, a, span)
import Html.Attributes exposing (href)
import Html.CssHelpers
import Rocket exposing ((=>))
import Shared.Markdown as Markdown
import Shared.Article exposing (Article)
import Shared.List exposing (findById)
import App.Types exposing (Model, Msg(..), Route(..), Context)
import App.Style as Style
import Shared.Flash as Flash exposing (Flash)
import Shared.Style as SharedStyle
import Edit.View as Edit


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"


flash : Flash -> Html Msg
flash flash =
    let
        ( flashTypeClass, msg ) =
            case flash.message of
                Flash.Info msg ->
                    SharedStyle.FlashInfo => msg

                Flash.Error msg ->
                    SharedStyle.FlashError => msg

                Flash.Warn msg ->
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
    a [ href <| "/#/article/" ++ article.id ]
        [ div [ class [ Style.DashboardArticle ] ]
            [ h2 [] [ text article.title ]
            , span [] [ text article.summary ]
            ]
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

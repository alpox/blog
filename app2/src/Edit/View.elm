module Edit.View exposing (..)

import Html exposing (Html, text, div, ul, li, a, textarea, input, button, span)
import Html.Attributes as Attributes exposing (contenteditable, href, value, type_, placeholder)
import Html.Events exposing (onInput)
import Html.CssHelpers
import App.Types exposing (Context)
import Shared.Article exposing (Article)
import Shared.Markdown as Markdown
import Shared.Icon exposing (icon)
import Edit.Types exposing (Msg(..), Model)
import Edit.Style as Style


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsEdit"


articleListItem : Article -> Html Msg
articleListItem article =
    a [ href <| "/#/edit/" ++ article.id ]
        [ li []
            [ text article.title
            ]
        ]


view : Context -> Model -> Html Msg
view context model =
    div [ class [ Style.Edit ] ]
        [ div [ class [ Style.EditNav ] ]
            [ div [ class [ Style.ButtonList ] ] [
                    button [] [ icon "paper-plane-o", text " Save" ]
                ]
            ]
        , div [ class [ Style.ArticleList ] ]
            [ ul [] <| List.map articleListItem context.articles
            ]
        , div [ class [ Style.ArticleEdit ] ]
            [ input [ class [ Style.ArticleTitleEdit ], onInput TitleChange, type_ "text", value model.article.title, placeholder "Title" ] []
            , span [ class [ Style.TitleBorder ] ] []
            , textarea [ class [ Style.ArticleContentEdit ], onInput ContentChange, value model.article.content ]
                []
            ]
        , div [ class [ Style.ArticlePreview ] ]
            [ Markdown.toHtml model.article.content
            ]
        ]

module Edit.View exposing (..)

import Html exposing (Html, h1, text, div, ul, li, a, textarea, input, button, span)
import Html.Attributes as Attributes exposing (contenteditable, href, value, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Html.CssHelpers
import Shared.Types exposing (Article, Context)
import Shared.Markdown as Markdown
import Shared.Icon exposing (icon)
import Edit.Types exposing (Msg(..), Model)
import Edit.Style as Style


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsEdit"


articleListItem : String -> Article -> Html Msg
articleListItem currentId article =
    let
        activeClass =
            if article.id == currentId then
                [ Style.Active ]
            else
                []
    in
        a [ onClick <| SetUrl <| "edit/" ++ article.id ]
            [ li [ class activeClass ]
                [ text article.title
                ]
            ]


view : Context -> Model -> Html Msg
view context model =
    div [ class [ Style.Edit ] ]
        [ div [ class [ Style.EditNav ] ]
            [ div [ class [ Style.ButtonList ] ]
                [ button [ onClick SaveArticle ] [ icon "paper-plane-o", text " Save" ]
                ]
            ]
        , div [ class [ Style.EditContainer ] ]
            [ div [ class [ Style.SideBar ] ]
                [ ul [] <| List.map (articleListItem model.article.id) context.articles
                , div [ class [ Style.EditButtons ] ]
                    [ button [ class [ Style.ButtonAdd ] ] [ icon "plus" ]
                    , button [ class [ Style.ButtonRemove ] ] [ icon "trash-o" ]
                    ]
                ]
            , div [ class [ Style.ArticleEdit ] ]
                [ input [ class [ Style.ArticleTitleEdit ], onInput TitleChange, type_ "text", value model.article.title, placeholder "Title" ] []
                , span [ class [ Style.Separator ] ] []
                , textarea [ class [ Style.ArticleSummaryEdit ], onInput SummaryChange, value model.article.summary ] []
                , span [ class [ Style.Separator ] ] []
                , textarea [ class [ Style.ArticleContentEdit ], onInput ContentChange, value model.article.content ]
                    []
                ]
            , div [ class [ Style.ArticlePreview ] ]
                [ h1 [] [ text model.article.title ]
                , Markdown.toHtml model.article.content
                ]
            ]
        ]

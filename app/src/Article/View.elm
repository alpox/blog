module Article.View exposing (..)

import Article.Types exposing (..)

import Html exposing (..)
import Html.CssHelpers

import Util.Markdown

import Html.Lazy exposing (lazy)

import Article.Style as Style exposing (..)

{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsArticle"

view : Model -> Html Msg
view model =
    case model.post of
        Just post ->
            section [ class [ Style.Post ] ]
                [ article []
                    [ h1 [] [ text post.title ]
                    , lazy (\c -> Util.Markdown.toHtml c) post.content
                    ]
                ]
        Nothing -> text "Loading..."
module Dashboard.View exposing (..)

import Article.Types exposing (Post)
import Dashboard.Types exposing (..)
import Dashboard.Style as Style exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers

import Util.Markdown

import Html.Lazy exposing (lazy)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsDashboard"

view : Model -> Html Msg
view model = div [] (List.map dashboardAbstract model.posts)

dashboardAbstract : Post -> Html Msg
dashboardAbstract post =
    a [ href ("#/post/" ++ post.id) ]
        [ section [ class [ Style.PostAbstractContainer ] ]
            [ header [ class [ Style.PostAbstractTitle ] ]
                [ h2 [] [ text post.title ] ]
            , article [ class [ Style.PostAbstract ] ]
                [ lazy (\c -> Util.Markdown.toHtml c) post.summary
                ]
            ]
        ]
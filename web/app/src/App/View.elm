module App.View exposing (..)

import App.Types exposing (..)

import App.Style as Style exposing (..)

import Dashboard.View as Dashboard
import Article.View as Article

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers

{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"

page : Model -> Html Msg
page model =
    case model.route of
        PostsRoute -> Html.map DashboardMsg (Dashboard.view model.dashboardModel)
        PostRoute id -> Html.map ArticleMsg (Article.view model.articleModel)
        NotFoundRoute -> div [] [ text "Route not found." ]

view : Model -> Html Msg
view model =
    div [ class [ Style.Container ] ]
        [ div [ class [ Style.ProfilePicture ] ] []
        , h1 [] [ text "This is alpox's blog" ]
        , page model
        , footer []
            [ div [ class [ Style.SocialLinks ] ]
                [ a [ href "https://github.com/alpox" ]
                    [ img [ src "/img/github.png" ] []
                    ]
                ]
            ]
        ]
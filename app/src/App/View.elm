module App.View exposing (..)

import App.Types exposing (..)
import App.Style as Style exposing (..)
import Dashboard.View as Dashboard
import Article.View as Article
import Login.View as Login
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.CssHelpers
import Shared.Types exposing (FlashMessage(..), Context)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"


page : Model -> Html Msg
page model =
    case model.route of
        PostsRoute ->
            Html.map DashboardMsg (Dashboard.view model.dashboardModel)

        PostRoute id ->
            Html.map ArticleMsg (Article.view model.articleModel)

        _ ->
            div [] [ text "Route not found." ]


flashMessage : FlashMessage -> Html Msg
flashMessage flashMsg =
    let
        -- (Css Class, Message as string)
        ( flashClass, msg ) =
            case flashMsg of
                Info msg ->
                    ( Style.FlashInfo, msg )

                Warn msg ->
                    ( Style.FlashWarn, msg )

                Error msg ->
                    ( Style.FlashError, msg )
    in
        div [ class [ Style.FlashMessage, flashClass ] ]
            [ text msg
            ]


view : Model -> Html Msg
view model =
    div [ class [ Style.FullHeight ] ] <|
        (List.map flashMessage model.flashMessages)
            ++ [ div [ class [ Style.Container ] ] <|
                    case model.route of
                        LoginRoute ->
                            [ Html.map LoginMsg (Login.view model.loginModel model.context) ]

                        _ ->
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
               ]

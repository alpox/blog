module App.View exposing (view)

import Html exposing (Html, input, text, div, h1, h2, h3, a, img, span, button, p)
import Html.Attributes exposing (href, src, type_, placeholder)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers
import Date exposing (Date)
import Date.Format as DateFormat
import Rocket exposing ((=>))
import Shared.Markdown as Markdown
import Shared.Types exposing (Article, Context, Flash, FlashMsg(..))
import Shared.List exposing (findById)
import Shared.Style as SharedStyle
import Shared.Icon exposing (icon)
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


presentationTime : Date -> String
presentationTime date =
    DateFormat.format "%e. %B %Y  %H:%M" <| date


dashboardArticle : Article -> Html Msg
dashboardArticle article =
    div [ class [ Style.DashboardArticle ] ]
        [ h3 [] [ text article.title ]
        , div [ class [ Style.Summary ] ] [ span [] [ text article.summary ] ]
        , div [ class [ Style.TagLine ] ]
            [ span [] [ text <| "On " ++ presentationTime article.insertedAt ++ " / by Alpox" ]
            , span [ onClick <| SetUrl <| "article/" ++ article.id ] [ text "read more" ]
            ]
        ]


dashboardView : Context -> Html Msg
dashboardView context =
    div [] <|
        h1 [] [ text "Latest posts" ]
            :: List.map dashboardArticle context.articles


articleView : Article -> Html Msg
articleView article =
    div [ class [ Style.Article ] ]
        [ h1 [] [ text article.title ]
        , span [] [ Markdown.toHtml article.content ]
        ]


loginModal : Model -> Html Msg
loginModal model =
    let
        classes =
            Style.LoginModal
                :: if model.showLoginModal then
                    []
                   else
                    [ Style.Hidden ]
    in
        div [ class classes ]
            [ button [ class [ Style.CloseModal ], onClick CloseLoginModal ]
                [ icon "times"
                ]
            , div [ class [ Style.LoginForm ] ]
                [ h2 [] [ text "Login" ]
                , div [ class [ Style.FormElement ] ]
                    [ span [] [ text "Username: " ]
                    , input [ type_ "text", placeholder "Max", onInput SetUsername ] []
                    ]
                , div [ class [ Style.FormElement ] ]
                    [ span [] [ text "Password: " ]
                    , input [ type_ "password", placeholder "Secret", onInput SetPassword ] []
                    ]
                , button [ class [ Style.ButtonLogin ], onClick Login ]
                    [ icon "user"
                    , text " Login"
                    ]
                ]
            ]


navigationBar : Model -> Html Msg
navigationBar model =
    div [ class [ Style.NavBar ] ]
        [ div [ class [ Style.ButtonList ] ]
            [ button [ onClick (SetUrl "") ]
                [ icon "home"
                , text " Home"
                ]
            ]
        , div [ class [ Style.ButtonList ] ]
            (if model.context.isLoggedIn then
                [ button [ onClick (SetUrl "edit/") ]
                    [ icon "edit"
                    , text " Edit"
                    ]
                , button [ onClick Logout ]
                    [ icon "arrow-right"
                    , text " Logout"
                    ]
                ]
             else
                [ button [ onClick ShowLoginModal ]
                    [ icon "user"
                    , text " Login"
                    ]
                ]
            )
        ]


htmlIfEditRoute : Html Msg -> Html Msg -> Model -> Html Msg
htmlIfEditRoute html default model =
    case model.route of
        EditRoute _ ->
            html

        _ ->
            default


sideBar : Html Msg
sideBar =
    div [ class [ Style.FloatingSideBar ] ]
        [ div []
            [ img [ src "/img/profile.png" ] []
            , div [ class [ Style.SideBarSection ] ]
                [ h2 [] [ text "Alpox" ]
                , p [] [ text "Software engineer," ]
                , p [] [ text "Full-stack developer" ]
                , p [] [ text "and data juggler" ]
                , div [ class [ Style.SocialIcons ] ]
                    [ a [ href "http://github.com/alpox" ] [ img [ src "/img/github.png" ] [] ]
                    , a [ href "https://ch.linkedin.com/in/elias-bernhaut-10bbb610b" ] [ img [ src "/img/linkedin.png" ] [] ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ (flip htmlIfEditRoute) (navigationBar model) (text "") model
        , loginModal model
        , div [ class [ SharedStyle.FlashContainer ] ] <|
            List.map flash model.flashes
        , htmlIfEditRoute
            (Html.map EditMsg <| Edit.view model.context model.editModel)
            (div []
                [ div [ class [ Style.Slider ] ]
                    []
                , div [ class [ Style.PageAnchor ] ]
                    [ div [ class [ Style.PageFrame ] ]
                        [ page model
                        ]
                    , sideBar
                    ]
                ]
            )
            model
        ]

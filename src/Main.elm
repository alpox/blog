module Main exposing (..)

import Html exposing (Html, button, div, footer, header, section, article, text, h1, h2, hr, a, img)
import Html.Attributes exposing (src, href)
import Html.CssHelpers
import Navigation
import Style


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbs"


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }



-- MODEL


type alias Model =
    { history : List Navigation.Location
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model [ location ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , Cmd.none
            )



-- VIEW


postContent : Model -> Html Msg
postContent model =
    case model.history of
        { hash } :: _ ->
            if String.isEmpty hash then
                testPoster
            else
                postContainer hash

        [] ->
            testPoster


testPoster =
    div []
        (List.repeat 5 (postPoster "testpost" "This is a post title" "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."))


postContainer : String -> Html Msg
postContainer id =
    section [ class [ Style.Post ] ]
        [ article []
            [ text id
            ]
        ]


postPoster : String -> String -> String -> Html Msg
postPoster id title abstract =
    a [ href ("#" ++ id) ]
        [ section [ class [ Style.PostPoster ] ]
            [ header [ class [ Style.PostPosterTitle ] ]
                [ h2 [] [ text title ] ]
            , article [ class [ Style.PostAbstract ] ]
                [ text abstract ]
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class [ Style.Container ] ]
        [ div [ class [ Style.ProfilePicture ] ] []
        , h1 [] [ text "This is alpox's blog" ]
        , postContent model
        , footer []
            [ div [ class [ Style.SocialLinks ] ]
                [ a [ href "https://github.com/alpox" ]
                    [ img [ src "img/github.png" ] []
                    ]
                ]
            ]
        ]

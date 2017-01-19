module Main exposing (..)

import Html exposing (Html, map, button, div, footer, header, section, article, text, h1, h2, hr, a, img)
import Html.Attributes exposing (src, href)
import Html.CssHelpers
import Html.Lazy exposing (lazy)
import Navigation
import Markdown
import Type exposing (PostId, Post)
import Routes exposing (parseLocation)
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

testPosts : PostId -> Post
testPosts postId =
    case postId of
        "first" -> 
            { id = postId
            , title = "First post"
            , content = "# This is a content! `blaabla`"
            }
        "second" ->
            { id = postId
            , title = "Second post"
            , content = """
## This is a content!

    postContainer : Post -> Html Msg
    postContainer post =
        section [ class [ Style.Post ] ]
            [ article []
                [ h1 [] [ text post.title ]
                , lazy (\\c -> Markdown.toHtml [] c) post.content
                ]
            ]
"""
            }
        _ ->
            { id = postId
            , title = "Another post"
            , content = "# This is a content! `blaabla`"
            }


postContent : Model -> Html Msg
postContent model =
    case model.history of
        location :: _ -> renderRoute location
        [] -> testPoster

renderRoute : Navigation.Location -> Html Msg
renderRoute location =
    case (parseLocation location) of
        Routes.PostsRoute -> testPoster
        Routes.PostRoute id -> testPosts id |> postContainer
        Routes.NotFoundRoute -> div [] [ text "Route not found." ]


testPoster : Html Msg
testPoster =
    div [] [
      postPoster "first" "This is a post title" "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    , postPoster "second" "This is a post title" "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    , postPoster "bla" "This is a post title" "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet."
    ]


postContainer : Post -> Html Msg
postContainer post =
    section [ class [ Style.Post ] ]
        [ article []
            [ h1 [] [ text post.title ]
            , lazy (\c -> Markdown.toHtml [] c) post.content
            ]
        ]


postPoster : String -> String -> String -> Html Msg
postPoster id title abstract =
    a [ href ("/post/" ++ id) ]
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
                    [ img [ src "/img/github.png" ] []
                    ]
                ]
            ]
        ]

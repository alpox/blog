module Routes exposing (..)

import Navigation exposing (Location)
import Type exposing (PostId)
import UrlParser exposing (..)

type Route
    = PostsRoute
    | PostRoute PostId
    | NotFoundRoute

matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map PostsRoute top
        , map PostsRoute (s "posts")
        , map PostRoute (s "post" </> string)
        ]

parseLocation : Location -> Route
parseLocation location =
    case (parsePath matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
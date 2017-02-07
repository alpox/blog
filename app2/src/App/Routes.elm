module App.Routes exposing (parseLocation)

import Navigation exposing (Location)
import App.Types exposing (Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map DashboardRoute top
        , map ArticleRoute (s "article" </> string)
        , map EditRoute (s "edit" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute

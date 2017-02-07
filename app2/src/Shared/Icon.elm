module Shared.Icon exposing (icon)

import Html exposing (Html, i)
import Html.Attributes exposing (class)

icon : String -> Html a
icon identifier =
    i [ class <| "fa fa-" ++ identifier ] []
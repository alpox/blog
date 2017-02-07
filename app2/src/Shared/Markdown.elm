module Shared.Markdown exposing (toHtml)

import Markdown
import Html
import Html.Attributes exposing (class)

basicOptions : Markdown.Options
basicOptions =
    { githubFlavored = Just { tables = True, breaks = True }
    , defaultHighlighting = Just "elm"
    , sanitize = True
    , smartypants = True
    }

toHtml : String -> Html.Html a
toHtml = Markdown.toHtmlWith basicOptions [ class "markdown-body" ]
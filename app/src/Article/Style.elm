module Article.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (h1)
import Css.Namespace exposing (namespace)

type CssClasses
    = Post

css : Stylesheet
css =
    (stylesheet << namespace "bbsArticle")
        [ (.) Post
            [ descendants
                [ h1
                    [ textAlign left
                    , fontSize (em 2)
                    ]
                ]
            ]
        ]

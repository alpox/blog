module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, body, h1, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = PageHost
    | Container
    | ProfilePicture


type CssIds
    = Page


css =
    (stylesheet << namespace "bbs")
        [ each [ html, body ]
            [ margin (px 0)
            , padding (px 0)
            , minHeight (pct 100)
            , height (pct 100)
            ]
        , h1
            [ textAlign center ]
        , (.) PageHost
            [ height (pct 100)
            ]
        , (.) Container
            [ width (pct 80)
            , height (pct 100)
            , margin auto
            , padding2 (px 20) (px 10)
            , backgroundColor (rgba 220 220 220 0.5)
            ]
        , (.) ProfilePicture
            [ width (px 300)
            , height (px 300)
            , backgroundImage (url "img/profile.png")
            , backgroundSize cover
            , margin auto
            , borderRadius (pct 100)
            ]
        ]


primaryAccentColor =
    hex "ccffaa"

module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, body, li)
import Css.Namespace exposing (namespace)


type CssClasses
    = Container


type CssIds
    = Page


css =
    (stylesheet << namespace "bbs")
        [ each [ html, body ]
            [ margin (px 0)
            , padding (px 0)
            ]
        , (.) Container
            [ width (pct 80)
            , margin auto
            , backgroundColor (rgb 220 220 220)
            ]
        ]


primaryAccentColor =
    hex "ccffaa"

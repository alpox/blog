module Login.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (input, button)
import Css.Namespace exposing (namespace)


type CssClasses
    = Container


white : Color
white =
    hex "FFF"


css : Stylesheet
css =
    (stylesheet << namespace "bbsLogin")
        [ (.) Container
            [ width (pct 70)
            , minWidth (px 500)
            , padding (px 16)
            , margin auto
            , border3 (px 2) solid (hex "CCC")
            , backgroundColor (hex "FAFAFA")
            , descendants
                [ input
                    [ display block
                    , padding2 (px 4) (px 8)
                    , fontSize (em 1.1)
                    , marginBottom (px 8)
                    ]
                , button
                    [ backgroundColor white
                    , borderStyle none
                    , borderRadius (px 2)
                    , padding2 (px 6) (px 12)
                    , boxShadow4 (px 1) (px 1) (px 4) (hex "AAA")
                    , cursor pointer
                    , fontWeight bold
                    , hover
                        [ boxShadow4 (px 1) (px 1) (px 10) (hex "AAA")
                        ]
                    ]
                ]
            ]
        ]

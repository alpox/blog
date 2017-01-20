module Dashboard.Style exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
    = PostAbstractContainer
    | PostAbstractTitle
    | PostAbstract

css : Stylesheet
css =
    (stylesheet << namespace "bbsDashboard")
        [ (.) PostAbstractContainer
            [ margin auto
            , marginTop (px 50)
            , padding2 (px 4) (px 20)
            , width (pct 100)
            , boxSizing borderBox
            , boxShadow3 (px 1) (px 1) (px 4)
            , borderRadius (px 4)
            , overflow hidden
            , backgroundColor (hex "fff")
            , cursor pointer
            , hover
                [ boxShadow3 (px 1) (px 1) (px 8)
                ]
            , children
                [ (.) PostAbstractTitle
                    [ borderBottom3 (px 1) solid (rgb 200 200 200)
                    ]
                , (.) PostAbstract
                    [ paddingTop (px 16)
                    , paddingBottom (px 16)
                    ]
                ]
            ]
        ]

module App.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, body, h1, h2, h3, h4, footer, ul, li, a)
import Css.Namespace exposing (namespace)
import Shared.Style as SharedStyle
import Edit.Style as EditStyle


type CssClasses
    = Container
    | PageFrame
    | Article
    | DashboardArticle


footerSize : Float
footerSize =
    100


css : List Stylesheet
css =
    appCss :: SharedStyle.css :: EditStyle.css :: []


unsetLink : List Mixin
unsetLink =
    let
        unset =
            [ color initial
            , textDecoration none
            ]
    in
        unset
            ++ [ hover unset
               , focus unset
               , active unset
               ]


appCss : Stylesheet
appCss =
    (stylesheet << namespace "bbs")
        [ everything
            [ boxSizing borderBox
            , outline none
            ]
        , each [ html, body ]
            [ margin (px 0)
            , padding (px 0)
            , minHeight (pct 100)
            , height (pct 100)
            , fontFamilies [ "Droid Sans", .value sansSerif ]
            , backgroundImage (url "/img/background.jpg")
            , backgroundSize cover
            ]
        , each [ h1, h2, h3, h4 ]
            [ color (rgb 40 40 40)
            , margin (px 0)
            , marginBottom (px 8)
            ]
        , ul
            [ margin (px 0)
            , padding (px 0)
            , children
                [ li
                    [ listStyleType none
                    ]
                ]
            ]
        , selector ".markdown-body ul"
            [ children
                [ li
                    [ listStyleType initial
                    ]
                ]
            ]
        , a unsetLink
        , class PageFrame
            [ backgroundColor (hex "FFF")
            , width (pct 70)
            , height (pct 100)
            , position absolute
            , right (px 0)
            , boxSizing borderBox
            , overflow hidden
            ]
        , class Article
            [ padding2 (px 32) (px 24)
            ]
        , class DashboardArticle
            [ padding2 (px 16) (px 24)
            , marginTop (px 16)
            , cursor pointer
            , hover
                [ transform <| scale 1.01
                , property "transition" "transform 0.1s ease-in-out"
                , backgroundColor (hex "F5F5F5")
                ]
            ]
        ]

module App.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, span, input, body, h1, h2, h3, h4, footer, ul, li, a, button)
import Css.Namespace exposing (namespace)
import Css.Colors exposing (gray, black)
import Shared.Style as SharedStyle
import Edit.Style as EditStyle


type CssClasses
    = Container
    | PageFrame
    | Article
    | DashboardArticle
    | NavBar
    | Slider
    | ButtonList
    | Hidden
    | LoginForm
    | FormElement
    | ButtonLogin
    | LoginModal
    | CloseModal
    | Separator


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
            , backgroundImage (url "/img/fresh_snow.png")
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
            , padding2 (px 16) (px 24)
            , width (pct 70)
            , height (pct 100)
            , position absolute
            , left (pct 50)
            , top (px 400)
            , transform <| translateX (pct -50)
            , boxSizing borderBox
            , overflow hidden
            , boxShadow4 (px 0) (px 0) (px 10) gray
            , descendants
                [ h1
                    [ firstChild
                        [ marginTop (px 16)
                        , marginBottom (px 32)
                        , borderLeft3 (px 2) solid (hex "004d40")
                        , paddingLeft (px 24)
                        ]
                    ]
                ]
            ]
        , class DashboardArticle
            [ position relative
            , padding2 (px 16) (px 24)
            , paddingLeft (px 8)
            , marginLeft (px -8)
            , marginTop (px 16)
            , cursor pointer
            , hover
                [ transform <| scale 1.01
                , property "transition" "transform 0.1s ease-in-out"
                , backgroundColor (hex "F5F5F5")
                ]
            ]
        , class CloseModal
            [ width (px 32)
            , height (px 32)
            , position absolute
            , right (px 16)
            , top (px 16)
            , borderRadius (pct 100)
            , backgroundColor (hex "DDD")
            , border3 (px 1) solid gray
            , cursor pointer
            , hover
                [ backgroundColor (hex "CCC")
                ]
            ]
        , class NavBar
            [ displayFlex
            , justifyContent spaceBetween
            , height (px 50)
            , backgroundColor (hex "FFF")
            , borderBottom3 (px 1) solid (hex "004d40")
            , children
                [ class ButtonList
                    [ displayFlex
                    , firstChild
                        [ children
                            [ button
                                [ border (px 0)
                                , borderRight3 (px 1) dashed (hex "004d40")
                                , hover
                                    [ borderRight3 (px 1) solid (hex "004d40")
                                    ]
                                ]
                            ]
                        ]
                    , children
                        [ button
                            [ padding2 (px 0) (px 16)
                            , border (px 0)
                            , backgroundColor transparent
                            , cursor pointer
                            , borderLeft3 (px 1) dashed (hex "004d40")
                            , fontSize (em 1.3)
                            , color (hex "004d40")
                            , hover
                                [ borderLeft3 (px 1) solid (hex "004d40")
                                , backgroundColor (hex "FDFDFD")
                                , cursor pointer
                                , property "user-select" "none"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , class Slider
            [ width (pct 100)
            , height (px 350)
            , borderBottom3 (px 1) solid black
            , backgroundImage (url "/img/background_rope.jpeg")
            , backgroundSize cover
            , property "background-position" "50% 60%"
            ]
        , class LoginModal
            [ displayFlex
            , width (px 500)
            , height (px 300)
            , padding (px 32)
            , position absolute
            , left (pct 50)
            , top (pct 50)
            , transform <| translate2 (pct -50) (pct -50)
            , boxShadow4 (px 2) (px 2) (px 50) gray
            , backgroundColor (hex "FFF")
            , borderRadius (px 4)
            , border3 (px 2) solid gray
            , zIndex (int 1000)
            ]
        , class LoginForm
            [ displayFlex
            , flexFlow1 column
            , margin auto
            , width (px 300)
            , children
                [ h2
                    [ marginBottom (px 24)
                    , borderLeft3 (px 1) solid (hex "004d40")
                    , paddingLeft (px 16)
                    ]
                ]
            ]
        , class FormElement
            [ displayFlex
            , justifyContent spaceBetween
            , marginBottom (px 16)
            , children
                [ span
                    [ fontSize (em 1.1)
                    , margin2 auto (px 0)
                    ]
                , input
                    [ border3 (px 1) solid (hex "004d40")
                    , padding2 (px 4) (px 8)
                    , fontSize (pt 12)
                    ]
                ]
            ]
        , class ButtonLogin
            [ flexShrink (num 3)
            , padding2 (px 4) (px 8)
            , fontSize (em 1.1)
            , backgroundColor (hex "FFF")
            , border3 (px 1) dashed (hex "004d40")
            , hover
                [ border3 (px 1) solid (hex "004d40")
                , backgroundColor (hex "FDFDFD")
                , cursor pointer
                , property "user-select" "none"
                ]
            ]
        , class Hidden
            [ display none
            ]
        , class Separator
            [ position absolute
            , left (px 8)
            , bottom (px 0)
            , width (pct 10)
            , height (px 1)
            , backgroundColor (hex "004d40")
            ]
        ]

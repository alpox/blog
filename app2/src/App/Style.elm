module App.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, span, input, div, body, h1, h2, h3, h4, img, footer, ul, li, a, button)
import Css.Namespace exposing (namespace)
import Css.Colors exposing (gray, black)
import Shared.Style as SharedStyle
import Edit.Style as EditStyle


type CssClasses
    = Container
    | PageFrame
    | PageAnchor
    | Article
    | DashboardArticle
    | Summary
    | TagLine
    | NavBar
    | Slider
    | ButtonList
    | Hidden
    | LoginForm
    | FormElement
    | ButtonLogin
    | LoginModal
    | CloseModal
    | FloatingSideBar
    | SideBarSection
    | SocialIcons


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
            , color (rgb 100 100 100)
            ]
        , each [ h1, h2, h3, h4 ]
            [ color (rgb 60 60 60)
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
            , width (pct 60)
            , property "min-height" "calc(100vh - 400px)"
            , top (px 350)
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
        , class PageAnchor
            [ displayFlex
            ]
        , class DashboardArticle
            [ position relative
            , padding2 (px 16) (px 24)
            , paddingLeft (px 8)
            , marginLeft (px -8)
            , marginTop (px 16)
            , children
                [ h3 [ color (hex "004d40") ]
                , class Summary
                    [ padding2 (px 16) (px 0)
                    ]
                , class TagLine
                    [ displayFlex
                    , justifyContent spaceBetween
                    , height (px 36)
                    , lineHeight (px 36)
                    , fontSize (em 0.8)
                    , borderTop3 (px 1) solid (hex "DDD")
                    , borderBottom3 (px 1) solid (hex "DDD")
                    , children
                        [ span
                            [ lastChild
                                [ cursor pointer
                                , color (hex "004d40")
                                ]
                            ]
                        ]
                    ]
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
            , zIndex (int 1000)
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
        , class FloatingSideBar
            [ flexGrow (num 1)
            , children
                [ div
                    [ position relative
                    , backgroundColor (hex "FFF")
                    , margin2 (px 32) (px 64)
                    , padding (px 16)
                    , textAlign center
                    , boxShadow4 (px 0) (px 0) (px 10) gray
                    , borderRadius (px 4)
                    , children
                        [ img
                            [ position absolute
                            , width (px 192)
                            , height (px 192)
                            , left (pct 50)
                            , top (px 20)
                            , padding (px 16)
                            , backgroundColor (hex ("FFF"))
                            , borderRadius (pct 100)
                            , transform <| translateX (pct -50)
                            ]
                        , class SideBarSection
                            [ paddingTop (px 100)
                            , marginTop (px 100)
                            , borderTop3 (px 3) solid (hex "004d40")
                            , children
                                [ class SocialIcons
                                    [ displayFlex
                                    , justifyContent center
                                    , descendants
                                        [ a
                                            [ marginLeft (px 16)
                                            , marginTop (px 8)
                                            , cursor pointer
                                            ]
                                        , img [ width (px 42) ]
                                        ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ]

module Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, body, h1, h2, h3, h4, footer, li, a)
import Css.Namespace exposing (namespace)


type CssClasses
    = PageHost
    | Container
    | ProfilePicture
    | Post
    | PostPoster
    | PostPosterTitle
    | PostAbstract
    | SocialLinks


footerSize : Float
footerSize =
    100


css : Stylesheet
css =
    (stylesheet << namespace "bbs")
        [ each [ html, body ]
            [ margin (px 0)
            , padding (px 0)
            , minHeight (pct 100)
            , height (pct 100)
            ]
        , h1
            [ textAlign center
            ]
        , each [ h1, h2, h3, h4 ]
            [ color (rgb 40 40 40)
            , fontFamilies [ "Philosopher", .value sansSerif ]
            ]
        , footer
            [ position absolute
            , bottom (px 0)
            , left (px 0)
            , property "box-shadow" "inset 0px 10px 10px -10px #222"
            , width (pct 100)
            , height (px footerSize)
            , boxSizing borderBox
            , backgroundColor (rgb 245 245 245)
            , descendants
                [ (.) SocialLinks
                    [ position relative
                    , top (pct 50)
                    , textAlign center
                    , transform (translateY (pct -50))
                    , children [ a [ display block ] ]
                    ]
                ]
            ]
        , (.) Post
            [ descendants
                [ h1
                    [ textAlign left
                    , fontSize (em 2)
                    ]
                ]
            ]
        , (.) PageHost
            [ height (pct 100)
            ]
        , (.) Container
            [ position relative
            , width (pct 80)
            , minHeight (pct 100)
            , margin auto
            , padding2 (px 20) (px 32)
            , boxShadow4 (px 0) (px 0) (px 8) (rgb 100 100 100)
            , paddingBottom (px (footerSize + 32))
              -- Make space for absolute positioned footer
            , backgroundColor (rgba 220 220 220 0.5)
            , descendants
                [ a
                    [ textDecoration none
                    , color initial
                    ]
                ]
            ]
        , (.) ProfilePicture
            [ width (px 300)
            , height (px 300)
            , backgroundImage (url "img/profile.png")
            , backgroundSize cover
            , margin auto
            , borderRadius (pct 100)
            ]
        , (.) PostPoster
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
                [ (.) PostPosterTitle
                    [ borderBottom3 (px 1) solid (rgb 200 200 200)
                    ]
                , (.) PostAbstract
                    [ paddingTop (px 16)
                    , paddingBottom (px 16)
                    ]
                ]
            ]
        ]

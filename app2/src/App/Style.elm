module App.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (html, body, h1, h2, h3, h4, footer, li, a)
import Css.Namespace exposing (namespace)


type CssClasses
    = Container


footerSize : Float
footerSize =
    100


css : List Stylesheet
css =
    appCss :: []


appCss : Stylesheet
appCss =
    (stylesheet << namespace "bbs")
        [ each [ html, body ]
            [ margin (px 0)
            , padding (px 0)
            , minHeight (pct 100)
            , height (pct 100)
            , fontFamilies [ "Droid Sans", .value sansSerif ]
            ]
        , h1
            [ textAlign center
            ]
        , each [ h1, h2, h3, h4 ]
            [ color (rgb 40 40 40)
            ]
        ]

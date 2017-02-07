module Edit.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (li, button)
import Css.Namespace exposing (namespace)


type CssClasses
    = Edit
    | EditNav
    | ArticleList
    | ArticleEdit
    | ArticleTitleEdit
    | ArticleContentEdit
    | ArticlePreview
    | TitleBorder
    | ButtonList


css : Stylesheet
css =
    (stylesheet << namespace "bbsEdit")
        [ class Edit
            [ displayFlex
            , flexFlow2 row wrap
            , height (vh 100)
            , backgroundColor (hex "FFF")
            ]
        , class EditNav
            [ height (px 50)
            , width (pct 100)
            , backgroundColor (hex "FFF")
            , borderBottom3 (px 1) solid (hex "01579b")
            , zIndex (int 100)
            ]
        , class ArticleList
            [ height (pct 100)
            , width (pct 20)
            , boxShadow4 (px 0) (px 0) (px 10) (hex "aaa")
            , descendants
                [ li
                    [ display block
                    , padding2 (px 16) (px 16)
                    , fontSize (em 1.1)
                    , fontWeight bold
                    , cursor pointer
                    , borderBottom3 (px 1) solid (hex "DDD")
                    , property "user-select" "none"
                    , hover
                        [ backgroundColor (hex "DDD")
                        ]
                    ]
                ]
            ]
        , class ArticleEdit
            [ displayFlex
            , flexFlow1 column
            , height (pct 100)
            , width (pct 40)
            , borderLeft3 (px 1) solid (hex "01579b")
            , borderRight3 (px 1) solid (hex "01579b")
            ]
        , class ArticleTitleEdit
            [ height (px 50)
            , fontSize (em 1.3)
            , padding2 (px 0) (px 16)
            , border (px 0)
            ]
        , class ArticleContentEdit
            [ padding (px 16)
            , flexGrow (num 1)
            , resize none
            , border (px 0)
            ]
        , class ArticlePreview
            [ height (pct 100)
            , width (pct 40)
            , padding (px 24)
            ]
        , class TitleBorder
            [ width (pct 90)
            , margin auto
            , borderBottom3 (px 1) solid (hex "01579b")
            ]
        , class ButtonList
            [ displayFlex
            , justifyContent flexEnd
            , height (pct 100)
            , children
                [ button
                    [ paddingRight (px 8)
                    , paddingLeft (px 8)
                    , backgroundColor (hex "FFF")
                    , borderRadius (px 0)
                    , border (px 0)
                    , borderLeft3 (px 1) dashed (hex "4fc3f7")
                    , color (hex "03a9f4")
                    , fontSize (em 1.3)
                    , hover
                        [ borderLeft3 (px 1) solid (hex "4fc3f7")
                        , backgroundColor (hex "FDFDFD")
                        , cursor pointer
                        , property "user-select" "none"
                        ]
                    ]
                ]
            ]
        ]

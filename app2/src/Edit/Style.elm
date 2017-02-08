module Edit.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (li, button)
import Css.Namespace exposing (namespace)
import Css.Colors exposing (black)


type CssClasses
    = Edit
    | EditNav
    | EditButtons
    | EditContainer
    | ButtonAdd
    | ButtonRemove
    | SideBar
    | ArticleEdit
    | ArticleTitleEdit
    | ArticleSummaryEdit
    | ArticleContentEdit
    | ArticlePreview
    | Separator
    | ButtonList
    | Active


css : Stylesheet
css =
    (stylesheet << namespace "bbsEdit")
        [ class Edit
            [ displayFlex
            , flexFlow1 column
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
        , class EditButtons
            [ displayFlex
            , justifyContent center
            , children
                [ button
                    [ width (px 40)
                    , height (px 40)
                    , lineHeight (px 39)
                    , padding (px 0)
                    , border3 (px 1) solid black
                    , borderRadius (pct 100)
                    , fontSize (em 1.2)
                    , marginBottom (px 8)
                    , cursor pointer
                    , firstChild
                        [ marginRight (px 16)
                        ]
                    ]
                , class ButtonAdd
                    [ backgroundColor (rgba 76 175 80 0.5)
                    , hover
                        [ backgroundColor (rgb 76 175 80)
                        ]
                    ]
                , class ButtonRemove
                    [ backgroundColor (rgba 239 83 80 0.5)
                    , hover
                        [ backgroundColor (rgb 239 83 80)
                        ]
                    ]
                ]
            ]
        , class EditContainer
            [ displayFlex
            , flexFlow1 row
            , flexGrow (num 1)
            ]
        , class SideBar
            [ displayFlex
            , flexFlow1 column
            , justifyContent spaceBetween
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
        , class ArticleSummaryEdit
            [ flexGrow (num 1)
            , padding (px 16)
            , resize none
            , border (px 0)
            ]
        , class ArticleContentEdit
            [ padding (px 16)
            , flexGrow (num 4)
            , resize none
            , border (px 0)
            ]
        , class ArticlePreview
            [ width (pct 40)
            , padding (px 24)
            ]
        , class Separator
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
        , class Active
            [ backgroundColor (hex "DDD")
            ]
        ]

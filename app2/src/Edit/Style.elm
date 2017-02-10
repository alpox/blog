module Edit.Style exposing (..)

import Css exposing (..)
import Css.Elements exposing (li, button, i)
import Css.Namespace exposing (namespace)
import Css.Colors exposing (black, gray, red)


type CssClasses
    = Edit
    | EditNav
    | EditButtons
    | EditContainer
    | ButtonGreen
    | ButtonRed
    | SideBar
    | ArticleEdit
    | ArticleTitleEdit
    | ArticleSummaryEdit
    | ArticleContentEdit
    | ArticlePreview
    | Separator
    | ButtonList
    | ModifyButtons
    | Active
    | Hidden
    | DeleteModal
    | Right


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
            [ displayFlex
            , justifyContent spaceBetween
            , height (px 50)
            , width (pct 100)
            , backgroundColor (hex "FFF")
            , borderBottom3 (px 1) solid (hex "01579b")
            , zIndex (int 100)
            ]
        , class EditButtons
            [ children
                [ button
                    [ width (px 40)
                    , height (px 40)
                    , lineHeight (px 0)
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
                , class ButtonGreen
                    [ backgroundColor (rgba 76 175 80 0.5)
                    , hover
                        [ backgroundColor (rgb 76 175 80)
                        ]
                    ]
                , class ButtonRed
                    [ backgroundColor (rgba 239 83 80 0.5)
                    , hover
                        [ backgroundColor (rgb 239 83 80)
                        ]
                    ]
                ]
            ]
        , class ModifyButtons
            [ displayFlex
            , justifyContent center
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
            , height (pct 100)
            , firstChild
                [ children
                    [ button
                        [ border (px 0)
                        , borderRight3 (px 1) dashed (hex "4fc3f7")
                        , hover
                            [ borderRight3 (px 1) solid (hex "4fc3f7")
                            ]
                        ]
                    ]
                ]
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
        , class DeleteModal
            [ displayFlex
            , alignItems center
            , padding (px 32)
            , paddingLeft (px 64)
            , position absolute
            , width (px 800)
            , height (px 300)
            , zIndex (int 1000)
            , boxShadow4 (px 2) (px 2) (px 50) gray
            , borderRadius (px 4)
            , border3 (px 2) solid gray
            , backgroundColor (hex "FFF")
            , left (pct 50)
            , top (pct 50)
            , transform <| translate2 (pct -50) (pct -50)
            , children
                [ i
                    [ fontSize (em 5)
                    , color red
                    , textAlign center
                    , marginRight (px 64)
                    ]
                ]
            , descendants
                [ class EditButtons
                    [ marginTop (px 16)
                    ]
                ]
            ]
        , class Hidden
            [ display none
            ]
        , class Right
            [ justifyContent spaceBetween
            ]
        ]

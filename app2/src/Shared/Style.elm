module Shared.Style exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Colors exposing (gray)


type CssClasses
    = Flash
    | FlashContainer
    | FlashAnimationBase
    | FlashAnimationAnimating
    | FlashAnimationDone
    | FlashInfo
    | FlashWarn
    | FlashError


css : Stylesheet
css =
    (stylesheet << namespace "bbs")
        [ class Flash
            [ padding2 (px 8) (px 16)
            , borderRadius (px 4)
            , boxShadow4 (px 1) (px 1) (px 10) gray
            , marginTop (px 8)
            , width (px 250)
            ]
        , class FlashContainer
            [ position fixed
            , top (px 16)
            , right (px 16)
            , zIndex (int 100)
            ]
        , class FlashAnimationBase
            [ opacity (num 1)
            ]
        , class FlashAnimationAnimating
            [ property "transition" "opacity 1s linear" ]
        , class FlashAnimationDone
            [ opacity (num 0)
            ]
        , class FlashInfo
            [ backgroundColor (hex "81C784") ]
        , class FlashWarn
            [ backgroundColor (hex "ffB74D") ]
        , class FlashError
            [ backgroundColor (hex "E57373") ]
        ]

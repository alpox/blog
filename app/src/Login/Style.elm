module Login.Style exposing (..)

import Css exposing (..)
import Css.Namespace exposing (namespace)

type CssClasses
    = NoClass

css : Stylesheet
css =
    (stylesheet << namespace "bbsLogin")
        [
        ]

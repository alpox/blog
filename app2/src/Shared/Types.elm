module Shared.Types
    exposing
        ( Context
        , initialContext
        , Flash
        , FlashMsg(..)
        , Article
        , initialArticle
        )

import Shared.Animation exposing (Animation)
import Shared.Style as Style


type alias Context =
    { articles : List Article
    }


initialContext : Context
initialContext =
    { articles = [] }


type FlashMsg
    = Info String
    | Warn String
    | Error String


type alias Flash =
    { id : Int
    , message : FlashMsg
    , animation : Animation Style.CssClasses
    }


type alias Article =
    { id : String
    , title : String
    , content : String
    , summary : String
    }


initialArticle : Article
initialArticle =
    { id = ""
    , title = "This is a title"
    , content = "This is some content\n --- \n And a section."
    , summary = ""
    }

module Shared.Types
    exposing
        ( Context
        , JWT
        , jwtDecoder
        , initialContext
        , Flash
        , FlashMsg(..)
        , Article
        , initialArticle
        )

import Time exposing (Time)
import Json.Decode as Decode
import Shared.Animation exposing (Animation)
import Shared.Style as Style


type alias JWT =
    { token : String
    , exp : Time
    }


type alias Context =
    { articles : List Article
    , jwt : Maybe JWT
    , isLoggedIn : Bool
    }


initialContext : Context
initialContext =
    { articles = []
    , jwt = Nothing
    , isLoggedIn = False
    }


jwtDecoder : Decode.Decoder JWT
jwtDecoder =
    Decode.map2 JWT
        (Decode.field "token" Decode.string)
        (Decode.field "exp" Decode.float) 


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
    { id = "new"
    , title = "Title"
    , content = "Content"
    , summary = "Summary"
    }

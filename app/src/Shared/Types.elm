module Shared.Types exposing (..)


type FlashMessage
    = Info String
    | Warn String
    | Error String


type alias PostId =
    String


type alias Post =
    { id : PostId
    , title : String
    , content : String
    , summary : String
    }


type alias Context =
    { jwtToken : Maybe String
    }


initialPost =
    { id = ""
    , title = ""
    , content = ""
    , summary = ""
    }


initialContext : Context
initialContext =
    { jwtToken = Nothing
    }

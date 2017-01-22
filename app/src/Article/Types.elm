module Article.Types exposing (..)

import Http

type Msg
    = Retrieve (Result Http.Error Post)

type alias PostId = String

type alias Post = 
    { id : PostId
    , title : String
    , content : String
    , summary : String
    }

type alias Model =
    { post : Maybe Post
    , error: Maybe Http.Error
    }

initialModel : Model
initialModel =
    { post = Nothing
    , error = Nothing
    }
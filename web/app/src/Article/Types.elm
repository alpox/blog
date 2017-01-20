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
    }

initialModel : Model
initialModel =
    { post = Nothing
    }
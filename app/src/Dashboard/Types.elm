module Dashboard.Types exposing (..)

import Http

import Article.Types exposing (PostId, Post)

type Msg = 
    Retrieve (Result Http.Error (List Post))

type alias Model = 
    { posts : List Post
    , error: Maybe Http.Error 
    }

initialModel : Model
initialModel =
    { posts = []
    , error = Nothing
    }
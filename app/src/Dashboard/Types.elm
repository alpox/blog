module Dashboard.Types exposing (..)

import Http

import Article.Types exposing (PostId, Post)

type Msg = 
    Retrieve (Result Http.Error (List Post))

type alias Model = { posts : List Post }

initialModel : Model
initialModel =
    { posts = [] }
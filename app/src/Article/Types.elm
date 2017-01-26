module Article.Types exposing (..)

import Shared.Types exposing (Post)
import Http


type Msg
    = Retrieve (Result Http.Error Post)


type alias Model =
    { post : Maybe Post
    , error : Maybe Http.Error
    }


initialModel : Model
initialModel =
    { post = Nothing
    , error = Nothing
    }

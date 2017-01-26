module Edit.Types exposing (..)

import Http
import Shared.Types exposing (..)


type Msg
    = Retrieve (Result Http.Error Post)


type OutMsg
    = Flash FlashMessage


type alias Model =
    { post : Post
    }


initialModel =
    { post = initialPost
    }

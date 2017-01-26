module Login.Types exposing (..)

import Shared.Types exposing (..)
import Http
import Table


type Msg
    = LoginResponse (Result Http.Error String)
    | Login
    | UsernameChange String
    | PasswordChange String
    | SetPostTableState Table.State
    | Retrieve (Result Http.Error (List Post))
    | StartEdit Post


type OutMsg
    = Flash FlashMessage
    | Token String
    | UrlChangeRequest String


type alias LoginCredentials =
    { username : String
    , password : String
    }


type alias Model =
    { loginCredentials : LoginCredentials
    , postTableState : Table.State
    , posts : List Post
    }


initialLoginCredentials =
    { username = ""
    , password = ""
    }


initialModel =
    { loginCredentials = initialLoginCredentials
    , postTableState = Table.initialSort "Title"
    , posts = []
    }

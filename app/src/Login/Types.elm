module Login.Types exposing (..)

import Shared.Types exposing (..)
import Http


type Msg
    = LoginResponse (Result Http.Error String)
    | Login
    | UsernameChange String
    | PasswordChange String


type OutMsg
    = Flash FlashMessage
    | Token String


type alias LoginCredentials =
    { username : String
    , password : String
    }


type alias Model =
    { loginCredentials : LoginCredentials
    }


initialLoginCredentials =
    { username = ""
    , password = ""
    }


initialModel =
    { loginCredentials = initialLoginCredentials
    }

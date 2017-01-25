module Login.Types exposing (..)

import Http

type Msg =
    LoginResponse (Result Http.Error String)
    | Login
    | UsernameChange String
    | PasswordChange String

type alias Model =
    { username: String
    , password: String
    , error: String
    }

initialModel =
    { username = ""
    , password = ""
    , error = ""
    }
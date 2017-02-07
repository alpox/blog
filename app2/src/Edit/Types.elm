module Edit.Types exposing (..)

import Shared.Article exposing (Article, initialArticle)

type Msg
    = SetArticle Article
    | TitleChange String
    | ContentChange String

type alias Model =
    { article : Article
    }

initialModel : Model
initialModel =
    { article = initialArticle
    }
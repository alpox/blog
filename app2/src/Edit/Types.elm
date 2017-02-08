module Edit.Types exposing (..)

import Http
import Shared.Types exposing (Article, initialArticle)


type Msg
    = SetUrl String
    | SetArticle Article
    | TitleChange String
    | SummaryChange String
    | ContentChange String
    | SaveArticle
    | ArticleUpdateResponse (Result Http.Error Article)


type alias Model =
    { article : Article
    }


initialModel : Model
initialModel =
    { article = initialArticle
    }

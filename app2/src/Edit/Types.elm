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
    | ArticleDeleteResponse (Result Http.Error String)
    | NewArticle
    | RemoveArticle
    | AttemptRemoveArticle
    | StopRemoveAttempt


type alias Model =
    { article : Article
    , deleteAttempt : Bool
    }


initialModel : Model
initialModel =
    { article = initialArticle
    , deleteAttempt = False
    }

module Shared.Article exposing (Article, initialArticle, fetchArticle, fetchArticles)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Graphql exposing (query, withVariable, send)


type alias Article =
    { id : String
    , title : String
    , content : String
    , summary : String
    }


initialArticle : Article
initialArticle =
    { id = ""
    , title = "This is a title"
    , content = "This is some content\n --- \n And a section."
    , summary = ""
    }


fetchArticles : (Result Http.Error (List Article) -> msg) -> Cmd msg
fetchArticles messageType =
    query """
    {
        posts {
            id
            title
            content
            summary
        }
    }
    """
        |> (send messageType <| Decode.at [ "posts" ] <| Decode.list articleDecoder)


fetchArticle : String -> (Result Http.Error Article -> msg) -> Cmd msg
fetchArticle id messageType =
    query """
    query($id: ID!) {
        post(id: $id) {
            id
            title
            content
            summary
        }
    }
    """
        |> withVariable ( "id", Encode.string id )
        |> (send messageType <| Decode.at [ "post" ] articleDecoder)


articleDecoder : Decode.Decoder Article
articleDecoder =
    (Decode.map4 Article
        (field "id" Decode.string)
        (field "title" Decode.string)
        (field "content" Decode.string)
        (field "summary" Decode.string)
    )

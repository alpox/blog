module Shared.Service exposing (fetchArticle, fetchArticleIfNecessary, fetchArticles, updateArticle)

import Http
import Json.Decode as Decode exposing (field)
import Json.Encode as Encode
import Graphql exposing (query, withVariable, send)
import Shared.List exposing (findById)
import Shared.Types exposing (Context, Article)


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


fetchArticleIfNecessary : String -> Context -> (Result Http.Error Article -> msg) -> Cmd msg
fetchArticleIfNecessary id context messageType =
    case findById id context.articles of
        Just article ->
            Cmd.none

        Nothing ->
            fetchArticle id messageType


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


articleEncoder : Article -> Encode.Value
articleEncoder article =
    (Encode.object
        [ ( "title", Encode.string article.title )
        , ( "content", Encode.string article.content )
        , ( "summary", Encode.string article.summary )
        ]
    )


updateArticle : Article -> (Result Http.Error Article -> msg) -> Cmd msg
updateArticle article resultMsg =
    query """
        mutation($id: String!, $post: UpdatePostParams!) {
            updatePost(id: $id, post: $post) {
                id
                title
                content
                summary
            }
        }
    """
        |> withVariable ( "id", Encode.string article.id )
        |> withVariable ( "post", articleEncoder article )
        |> (send resultMsg <| Decode.at [ "updatePost" ] articleDecoder)
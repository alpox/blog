module Shared.Service
    exposing
        ( login
        , fetchArticle
        , fetchArticleIfNecessary
        , fetchArticles
        , deleteArticle
        , updateOrInsertArticle
        , articleEncoder
        , articleDecoder
        )

import Http
import Date
import Json.Decode as Decode exposing (field)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Json.Encode as Encode
import Graphql exposing (query, withVariable, withToken, send, toTask)
import Shared.List exposing (findById)
import Shared.Types exposing (Context, Article, JWT)


login : String -> String -> (Result Http.Error JWT -> msg) -> Cmd msg
login username password messageType =
    query """
        mutation ($password: String!, $username: String!) {
            login(username: $username, password: $password) {
                token
                exp
            }
        }
        """
        |> withVariable ( "username", Encode.string username )
        |> withVariable ( "password", Encode.string password )
        |> (send messageType <| Decode.at [ "login" ] jwtDecoder)


jwtDecoder : Decode.Decoder JWT
jwtDecoder =
    Decode.map2 JWT
        (Decode.field "token" Decode.string)
        (Decode.field "exp" <| Decode.map (String.toFloat >> Result.withDefault 0) Decode.string)


fetchArticles : (Result Http.Error (List Article) -> msg) -> Cmd msg
fetchArticles messageType =
    query """
    {
        posts {
            id
            title
            content
            summary
            insertedAt
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
            insertedAt
        }
    }
    """
        |> withVariable ( "id", Encode.string id )
        |> (send messageType <| Decode.at [ "post" ] articleDecoder)


dateDecoder : Decode.Decoder Date.Date
dateDecoder =
    Decode.string
        |> Decode.andThen
            (\val ->
                case Date.fromString val of
                    Err err ->
                        Decode.fail err

                    Ok date ->
                        Decode.succeed date
            )


articleDecoder : Decode.Decoder Article
articleDecoder =
    decode Article
        |> required "id" Decode.string
        |> required "title" Decode.string
        |> required "content" Decode.string
        |> required "summary" Decode.string
        |> required "insertedAt" dateDecoder
        |> optional "saved" Decode.bool True


articleEncoder : Article -> Encode.Value
articleEncoder article =
    (Encode.object
        [ ( "title", Encode.string article.title )
        , ( "content", Encode.string article.content )
        , ( "summary", Encode.string article.summary )
        ]
    )


deleteArticle : Article -> Context -> (Result Http.Error String -> msg) -> Cmd msg
deleteArticle article context resultMsg =
    case context.jwt of
        Just jwt ->
            query """
                mutation ($id: String!) {
                    post: deletePost(id: $id) {
                        id
                    }
                }
            """
                |> withVariable ( "id", Encode.string article.id )
                |> withToken jwt.token
                |> (send resultMsg <| Decode.at [ "post" ] <| (field "id" Decode.string))

        Nothing ->
            Cmd.none


updateOrInsertArticle : Article -> Context -> (Result Http.Error Article -> msg) -> Cmd msg
updateOrInsertArticle article context resultMsg =
    let
        ( queryString, idVariable ) =
            if article.id == "new" then
                ( """
                mutation($post: UpdatePostParams!) {
                    post: insertPost(post: $post) {
                        id
                        title
                        content
                        summary
                        insertedAt
                    }
                }
            """, [] )
            else
                ( """
                mutation($id: String!, $post: UpdatePostParams!) {
                    post: updatePost(id: $id, post: $post) {
                        id
                        title
                        content
                        summary
                        insertedAt
                    }
                }
            """, [ ( "id", Encode.string article.id ) ] )

        variables =
            idVariable ++ [ ( "post", articleEncoder article ) ]
    in
        case context.jwt of
            Just jwt ->
                query queryString
                    |> (flip (List.foldl withVariable) variables)
                    |> withToken jwt.token
                    |> (send resultMsg <| Decode.at [ "post" ] articleDecoder)

            Nothing ->
                Cmd.none

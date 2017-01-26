module Login.View exposing (view)

import Login.Types exposing (..)
import Login.Style as Style
import Shared.Types exposing (Post)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers
import Shared.Types exposing (Context)
import Table exposing (defaultCustomizations)


{ id, class, classList } =
    Html.CssHelpers.withNamespace "bbsLogin"


loginFrame : LoginCredentials -> List (Html Msg)
loginFrame model =
    [ input [ onInput UsernameChange, type_ "text", placeholder "Username", value model.username ] []
    , input [ onInput PasswordChange, type_ "password", placeholder "Password", value model.password ] []
    , button [ onClick Login ] [ text "Login" ]
    ]


toTableAttrs : List (Attribute Msg)
toTableAttrs =
    [ class [ Style.PostTable ]
    ]


postTableEditView : Post -> Table.HtmlDetails Msg
postTableEditView post =
    Table.HtmlDetails []
        [ i
            [ Html.Attributes.class "fa fa-pencil"
            , onClick (StartEdit post)
            ]
            []
        ]


postTableEditColumn : Table.Column Post Msg
postTableEditColumn =
    Table.veryCustomColumn
        { name = "Edit"
        , viewData = postTableEditView
        , sorter = Table.unsortable
        }


postTableConfig : Table.Config Post Msg
postTableConfig =
    Table.customConfig
        { toId = .id
        , toMsg = SetPostTableState
        , columns =
            [ postTableEditColumn
            , Table.stringColumn "Title" .title
            , Table.stringColumn "Summary" .summary
            ]
        , customizations =
            { defaultCustomizations | tableAttrs = toTableAttrs }
        }


view : Model -> Context -> Html Msg
view model context =
    div [ class [ Style.Container ] ] <|
        if context.jwtToken == Nothing then
            loginFrame model.loginCredentials
        else
            [ div [ class [] ]
                [ Table.view postTableConfig model.postTableState model.posts
                ]
            ]

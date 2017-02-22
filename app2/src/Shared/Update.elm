module Shared.Update
    exposing
        ( initDispatch
        , dispatch
        , collect
        , withModel
        , mapUpdate
        , mapCmd
        , mapMainCmd
        , applyUpdates
        , evaluateMaybe
        , sendMessage
        , sendSingleMessage
        )

import Task


initDispatch : msg -> model -> ( msg, model, Cmd msg )
initDispatch msg model =
    ( msg, model, Cmd.none )


dispatch :
    (msg -> model -> ( model, Cmd msg ))
    -> ( msg, model, Cmd msg )
    -> ( msg, model, Cmd msg )
dispatch updateFn ( msg, model, cmd ) =
    let
        ( newModel, newCmd ) =
            updateFn msg model
    in
        ( msg, newModel, Cmd.batch [ cmd, newCmd ] )


collect : ( msg, model, Cmd msg ) -> ( model, Cmd msg )
collect ( _, model, cmd ) =
    ( model, cmd )


withModel : model -> ( child, Cmd msg, outMsg ) -> ( child, model, Cmd msg, outMsg )
withModel model ( child, cmd, outMsg ) =
    ( child, model, cmd, outMsg )


mapUpdate : (child -> model -> model) -> ( child, model, Cmd msg, outMsg ) -> ( child, model, Cmd msg, outMsg )
mapUpdate updateFn ( childModel, model, cmd, outMsg ) =
    ( childModel, updateFn childModel model, cmd, outMsg )


applyUpdates : ( child, model, Cmd msg, outMsg ) -> ( model, Cmd msg, outMsg )
applyUpdates ( _, model, cmd, outMsg ) =
    ( model, cmd, outMsg )


mapCmd : (a -> msg) -> ( model, Cmd a, outMsg ) -> ( model, Cmd msg, outMsg )
mapCmd mapType ( model, cmd, outMsg ) =
    ( model, Cmd.map mapType cmd, outMsg )


mapMainCmd :
    ( model, Cmd msg, Cmd msg )
    -> ( model, Cmd msg )
mapMainCmd ( model, cmd, outCmd ) =
    ( model, Cmd.batch [ cmd, outCmd ] )


evaluateMaybe :
    (outMsg -> model -> ( model, Cmd msg ))
    -> Cmd msg
    -> ( model, Cmd msg, Maybe outMsg )
    -> ( model, Cmd msg )
evaluateMaybe interpretOutMsg defaultCmd ( model, cmd, outMsg ) =
    let
        ( newModel, newCmd ) =
            case outMsg of
                Just someMsg ->
                    interpretOutMsg someMsg model

                Nothing ->
                    ( model, defaultCmd )
    in
        ( newModel, Cmd.batch [ cmd, newCmd ] )


sendMessage : (a -> msg) -> a -> Cmd msg
sendMessage msg input =
    Task.perform msg <| Task.succeed input


sendSingleMessage : msg -> Cmd msg
sendSingleMessage msg =
    Task.perform (always msg) <| Task.succeed ()

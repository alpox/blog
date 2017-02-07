module Shared.Update
    exposing
        ( initDispatch
        , dispatch
        , collect
        , withModel
        , mapUpdate
        , mapCmd
        , applyUpdates
        )


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
    (model, cmd)


withModel : model -> ( child, Cmd msg ) -> ( child, model, Cmd msg )
withModel model ( child, cmd ) =
    ( child, model, cmd )


mapUpdate : (child -> model -> model) -> ( child, model, Cmd msg ) -> ( child, model, Cmd msg )
mapUpdate updateFn ( childModel, model, cmd ) =
    ( childModel, updateFn childModel model, cmd )


applyUpdates : ( child, model, Cmd msg ) -> ( model, Cmd msg )
applyUpdates ( _, model, cmd ) =
    (model, cmd)


mapCmd : (a -> msg) -> ( model, Cmd a ) -> ( model, Cmd msg )
mapCmd mapType ( model, cmd ) =
    (model, Cmd.map mapType cmd)

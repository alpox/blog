module Shared.List exposing (updateIf, updateOrAdd, generateId, find, findById)


updateIf : (a -> Bool) -> (a -> a) -> List a -> List a
updateIf predicate updateFn list =
    case list of
        [] ->
            list

        first :: rest ->
            (if predicate first then
                updateFn first
             else
                first
            )
                :: updateIf predicate updateFn rest


find : (a -> Bool) -> List a -> Maybe a
find predicate list =
    case list of
        [] ->
            Nothing

        first :: rest ->
            if predicate first then
                Just first
            else
                find predicate rest


findById : a -> List { b | id : a } -> Maybe { b | id : a }
findById id list =
    find (.id >> (==) id) list


generateId : List { a | id : Int } -> Int
generateId list =
    let
        firstGap last ids =
            case ids of
                first :: rest ->
                    if last < first - 1 then
                        last + 1
                    else
                        firstGap first rest

                [] ->
                    last + 1
    in
        List.map .id list
            |> List.sort
            |> firstGap 0


updateOrAdd : { b | id : a } -> List { b | id : a } -> List { b | id : a }
updateOrAdd item list =
    case list of
        first :: rest ->
            if first.id == item.id then
                item :: rest
            else
                first :: updateOrAdd item rest

        [] ->
            item :: []

module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


main : Program () Model Msg
main =
    Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

-- model

type alias Model = Int
init: Model
init = 0


-- update

type Msg =
    Increment
    | Decrement

update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


-- view
view : Model -> Html Msg
view model =
    div []
    [ button [onClick Increment] [text "Increment"]
    , p [] [text <| String.fromInt model]
    , button [onClick Decrement] [text "Decrement"]
    ]

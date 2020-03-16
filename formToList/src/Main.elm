module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (value, disabled)
import Html.Events exposing (onClick, onInput)


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


-- model
type alias Model =
    { input : String
    , memos : List String
    }
init : Model
init =
    { input = ""
    , memos = []
    }


-- update
type Msg =
    Input String
    | Submit

update : Msg -> Model -> Model
update msg model =
    case msg of
        Input v ->
            { model | input = v}

        Submit ->
            { model
                | memos = model.input :: model.memos
                , input = ""
            }


-- view
view : Model -> Html Msg
view model =
    div []
        [ input [onInput Input, value model.input] []
        , button [onClick Submit, disabled (String.isEmpty (String.trim model.input))] [text "submit"]
        , br [] []
        , ul [] (List.map memoItem model.memos)
        ]

memoItem : String -> Html Msg
memoItem v=
    li [] [text v]
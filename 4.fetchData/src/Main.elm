module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- model


type alias Model =
    { result : String }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { result = "" }
    , Cmd.none
    )



-- update


type Msg
    = Click
    | GotRepo (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click ->
            ( model
            , Http.get
                { url = "https://api.github.com/repos/elm/core"
                , expect = Http.expectString GotRepo
                }
            )

        GotRepo (Ok repo) ->
            ( { model | result = repo }, Cmd.none )

        GotRepo (Err error) ->
            ( { model | result = Debug.toString error }, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text "Get repo" ]
        , div [] [ text model.result ]
        ]

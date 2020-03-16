module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href, src, value, width)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as D exposing (Decoder)


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
    { result : String
    , input : String
    , userState : UserState
    }


type UserState
    = Init
    | Waiting
    | Loaded User
    | Failed Http.Error


init : () -> ( Model, Cmd Msg )
init _ =
    ( { result = ""
      , input = ""
      , userState = Init
      }
    , Cmd.none
    )



-- update


type Msg
    = Input String
    | Send
    | Receive (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Input v ->
            ( { model | input = v }
            , Cmd.none
            )

        Send ->
            ( { model
                | input = ""
                , userState = Waiting
              }
            , Http.get
                { url = "https://api.github.com/users/" ++ model.input
                , expect = Http.expectJson Receive userDecoder
                }
            )

        Receive (Ok user) ->
            ( { model | userState = Loaded user }, Cmd.none )

        Receive (Err error) ->
            ( { model | userState = Failed error }, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    div []
        [ input [ value model.input, onInput Input ] []
        , button [ onClick Send ] [ text "search user" ]
        , br [] []
        , case model.userState of
            Init ->
                p [] [ text "type someone's name" ]

            Waiting ->
                p [] [ text "fetching data ...." ]

            Failed err ->
                p [] [ text <| "something went wrong ..." ++ Debug.toString err ]

            Loaded user ->
                div []
                    [ img [ src user.avatarUrl, width 300 ] [ text "success" ]
                    , p [] [ text user.name ]
                    , a [ href user.htmlUrl ] [ text user.htmlUrl ]
                    , case user.bio of
                        Just bio ->
                            p [] [ text bio ]

                        Nothing ->
                            p [] []
                    ]
        ]



-- data


type alias User =
    { login : String
    , avatarUrl : String
    , name : String
    , htmlUrl : String
    , bio : Maybe String
    }


userDecoder : Decoder User
userDecoder =
    D.map5 User
        (D.field "login" D.string)
        (D.field "avatar_url" D.string)
        (D.field "name" D.string)
        (D.field "html_url" D.string)
        (D.maybe (D.field "bio" D.string))

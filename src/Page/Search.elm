module Page.Search exposing (..)

import Html exposing (Html, button, div, h1, input, text)
import Html.Events exposing (onClick, onInput)
import Session exposing (Session)


type alias Model =
    { session : Session, term : String }


type Msg
    = ExecuteSearch
    | SetTerm String


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session, term = "" }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExecuteSearch ->
            -- Return your search command here
            ( model, Cmd.none )

        SetTerm term ->
            ( { model | term = term }, Cmd.none )


view : Model -> { title : String, content : List (Html Msg) }
view _ =
    { title = "Search"
    , content =
        [ div []
            [ h1 [] [ text "Search page" ]
            , div []
                [ input [ onInput SetTerm ] []
                , button [ onClick ExecuteSearch ] [ text "Search now" ]
                ]
            ]
        ]
    }

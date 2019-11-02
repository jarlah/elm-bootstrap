module Page.Home exposing (..)

import Html exposing (Html, div, h1, text)
import Session exposing (Session)


type alias Model =
    { session : Session }


type Msg
    = NoMsgYet


init : Session -> ( Model, Cmd Msg )
init session =
    ( { session = session }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )


view : Model -> { title : String, content : List (Html Msg) }
view _ =
    { title = "Home"
    , content =
        [ div []
            [ h1 []
                [ text "Home" ]
            , div []
                [ text "This is a simple kick starter app" ]
            ]
        ]
    }

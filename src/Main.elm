module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html exposing (Html, a, div, li, span, text, ul)
import Page.About as About
import Page.Home as Home
import Page.Search as Search
import Route exposing (Route)
import Session exposing (Session)
import Url exposing (Url)


type Model
    = Redirect Session
    | NotFound Session
    | SearchModel Search.Model
    | HomeModel Home.Model
    | AboutModel About.Model


type Msg
    = SearchMsg Search.Msg
    | HomeMsg Home.Msg
    | AboutMsg About.Msg
    | ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    changeRouteTo (Route.fromUrl url) (Redirect (Session.fromFlags key flags))


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        session =
            toSession model
    in
    case maybeRoute of
        Nothing ->
            ( NotFound session, Cmd.none )

        Just Route.About ->
            About.init session
                |> updateWith AboutModel AboutMsg

        Just Route.Home ->
            Home.init session
                |> updateWith HomeModel HomeMsg

        Just Route.Search ->
            Search.init session
                |> updateWith SearchModel SearchMsg


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


view : Model -> Document Msg
view model =
    let
        viewPage toMsg config =
            let
                { title, content } =
                    config
            in
            { title = title ++ " - Bootstrap"
            , body =
                [ div []
                    [ a [ Route.href Route.Home ] [ text "Home" ]
                    , span [] [ text " | " ]
                    , a [ Route.href Route.About ] [ text "About" ]
                    , span [] [ text " | " ]
                    , a [ Route.href Route.Search ] [ text "Search" ]
                    ]
                , div []
                    (List.map
                        (Html.map toMsg)
                        content
                    )
                ]
            }

        blankView s =
            { title = "redirecting", body = [ div [] [ text s ] ] }
    in
    case model of
        AboutModel aboutModel ->
            viewPage AboutMsg (About.view aboutModel)

        HomeModel homeModel ->
            viewPage HomeMsg (Home.view homeModel)

        SearchModel searchModel ->
            viewPage SearchMsg (Search.view searchModel)

        Redirect _ ->
            blankView ""

        NotFound _ ->
            blankView "The page you requested was not found"


toSession : Model -> Session
toSession page =
    case page of
        NotFound session ->
            session

        Redirect session ->
            session

        SearchModel model ->
            model.session

        HomeModel model ->
            model.session

        AboutModel model ->
            model.session


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( ClickedLink urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            ( model, Cmd.none )

                        Just _ ->
                            ( model
                            , Nav.pushUrl (.navKey (toSession model)) (Url.toString url)
                            )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( ChangedUrl url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( AboutMsg subMsg, AboutModel searchModel ) ->
            About.update subMsg searchModel
                |> updateWith AboutModel AboutMsg

        ( HomeMsg subMsg, HomeModel searchModel ) ->
            Home.update subMsg searchModel
                |> updateWith HomeModel HomeMsg

        ( SearchMsg subMsg, SearchModel searchModel ) ->
            Search.update subMsg searchModel
                |> updateWith SearchModel SearchMsg

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.application
        { init = init
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        , subscriptions = subscriptions
        , update = update
        , view = view
        }

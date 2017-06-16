module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (controls, src, autoplay)
import Html.Events exposing (onClick)
import RemoteData exposing (RemoteData, WebData)
import Http
import Json.Decode exposing (int, string, float, nullable, Decoder, list, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Dict


-- MODEL


type alias Model =
    { songs : WebData (List Song)
    , activeSong : Maybe Song
    }


type alias Song =
    { audioUrl : String
    , description : String
    , title : String
    }


type Msg
    = Noop
    | SongsLoad
    | SongsFeedLoaded (WebData (List Song))
    | SelectSong Song


init =
    update SongsLoad { songs = RemoteData.NotAsked, activeSong = Nothing }



-- UPDATE


getSongs : Cmd Msg
getSongs =
    let
        url =
            "http://localhost:3123/music"
    in
        Http.send RemoteData.fromResult (Http.get url fullDecoder)
            |> Cmd.map SongsFeedLoaded


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        SongsLoad ->
            ( { model | songs = RemoteData.Loading }, getSongs )

        SongsFeedLoaded songs ->
            ( { model | songs = songs }, Cmd.none )

        SelectSong song ->
            ( { model | activeSong = Just song }, Cmd.none )


songDecoder : Decoder Song
songDecoder =
    decode Song
        |> required "id" string
        |> required "description" string
        |> required "title" string


songsDecoder : Decoder (List Song)
songsDecoder =
    list songDecoder


fullDecoder : Decoder (List Song)
fullDecoder =
    at [ "items" ] songsDecoder


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    case model.songs of
        RemoteData.NotAsked ->
            text "Not asked yet"

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success songs ->
            div []
                [ Maybe.withDefault (text "No song selected") (Maybe.map viewPlayer model.activeSong)
                , ul [] <|
                    List.map (\song -> li [ onClick (SelectSong song) ] [ text song.title ]) songs
                ]

        RemoteData.Failure err ->
            text "Error during loading"


viewPlayer : Song -> Html Msg
viewPlayer song =
    div []
        [ h2 [] [ text song.title ]
        , audio
            [ src song.audioUrl
            , controls True
            , autoplay True
            ]
            []
        ]


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

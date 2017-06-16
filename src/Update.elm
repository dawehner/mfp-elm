module Update exposing (update, subscriptions)

import Http
import Model exposing (..)
import RemoteData
import Json.Decode exposing (int, string, float, nullable, Decoder, list, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)

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


module Update exposing (subscriptions, update)

import Http
import Json.Decode exposing (Decoder, field, float, int, list, nullable, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import List.Extra
import Model exposing (..)
import Random
import Random.Extra
import RemoteData


getSongs : String -> Cmd Msg
getSongs url =
    Http.get {
        url = url
        , expect = Http.expectJson (RemoteData.fromResult >> SongsFeedLoaded) fullDecoder
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SongsLoad ->
            ( { model | songs = RemoteData.Loading }, getSongs model.songsUrl )

        SongsFeedLoaded songs ->
            ( { model | songs = songs }, Cmd.none )

        SelectSong maybeSong ->
            ( { model | activeSong = maybeSong }, Cmd.none )

        SelectRandomSong ->
            case model.songs of
                RemoteData.Success songs ->
                    ( model, Random.generate SelectSong (Random.Extra.sample songs) )

                _ ->
                    ( model, Cmd.none )


songDecoder : Decoder Song
songDecoder =
    succeed Song
        |> required "id" string
        |> required "description" string
        |> required "title" string


songsDecoder : Decoder (List Song)
songsDecoder =
    list songDecoder


fullDecoder : Decoder (List Song)
fullDecoder =
    field "items" songsDecoder


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

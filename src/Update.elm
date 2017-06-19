module Update exposing (update, subscriptions)

import Http
import Model exposing (..)
import RemoteData
import Json.Decode exposing (int, string, float, nullable, Decoder, list, field)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Random
import List.Extra
import Random.Extra


getSongs : String -> Cmd Msg
getSongs url =
    Http.send RemoteData.fromResult (Http.get url fullDecoder)
        |> Cmd.map SongsFeedLoaded


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
    decode Song
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

module Update exposing (update, subscriptions)

import Http
import Model exposing (..)
import RemoteData
import Json.Decode exposing (int, string, float, nullable, Decoder, list, at)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Random
import List.Extra


getSongs : String -> Cmd Msg
getSongs url =
    Http.send RemoteData.fromResult (Http.get url fullDecoder)
        |> Cmd.map SongsFeedLoaded


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )

        SongsLoad ->
            ( { model | songs = RemoteData.Loading }, getSongs model.songsUrl )

        SongsFeedLoaded songs ->
            ( { model | songs = songs }, Cmd.none )

        SelectSong song ->
            ( { model | activeSong = Just song }, Cmd.none )

        SelectRandomSong ->
            case model.songs of
                RemoteData.Success songs ->
                    ( model, Random.generate SelectSong (randomSong songs) )

                _ ->
                    ( model, Cmd.none )


randomSong : List Song -> Random.Generator Song
randomSong songs =
    let
        length =
            List.length songs
    in
        Random.int 0 (length - 1)
            |> Random.map
                (\int ->
                    List.Extra.getAt int songs
                        -- Is there a better way to ensure that there is at least one of the songs returned.
                        |>
                            Maybe.withDefault { audioUrl = "", title = "", description = "" }
                )


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

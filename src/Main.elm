module Main exposing (main)

import Browser
import Model exposing (..)
import RemoteData exposing (RemoteData(..))
import Update exposing (subscriptions, update)
import View exposing (view)


init : () -> ( Model, Cmd Msg )
init _ =
    update SongsLoad { songs = RemoteData.NotAsked, activeSong = Nothing, songsUrl = "music.json" }


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

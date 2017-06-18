module Main exposing (main)

import Html
import RemoteData exposing (RemoteData, WebData)
import Http
import Model exposing (..)
import View exposing (view)
import Update exposing (update, subscriptions)


init =
    update SongsLoad { songs = RemoteData.NotAsked, activeSong = Nothing, songsUrl = "music.json" }


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

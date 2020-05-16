module Main exposing (main)

import Html
import Http
import Model exposing (..)
import RemoteData exposing (RemoteData, WebData)
import Update exposing (subscriptions, update)
import View exposing (view)
import Browser

init : () -> (Model, Cmd Msg)
init _ =
    update SongsLoad { songs = RemoteData.NotAsked, activeSong = Nothing, songsUrl = "music.json" }


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

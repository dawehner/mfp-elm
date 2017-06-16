module Main exposing (main)

import Html
import RemoteData exposing (RemoteData, WebData)
import Http
import Model exposing (..)
import View exposing (view)
import Update exposing (update, subscriptions)


-- MODEL


init =
    update SongsLoad { songs = RemoteData.NotAsked, activeSong = Nothing }



-- UPDATE
-- VIEW


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }

module Model exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { songs : WebData (List Song)
    , activeSong : Maybe Song
    , songsUrl: String
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
    | SelectRandomSong

module View exposing (view)

import RemoteData
import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (controls, src, autoplay, href)
import Html.Events exposing (onClick, onWithOptions)
import Json.Decode


view : Model -> Html Msg
view model =
    div []
        [ viewApp model
        , footer [] [ text "Music from ", a [ href "http://musicforprogramming.net/" ] [ text "musicforprogramming.net" ] ]
        ]


onClickPreventDefault : msg -> Attribute msg
onClickPreventDefault msg =
    onWithOptions
        "click"
        { preventDefault = True
        , stopPropagation = False
        }
        (Json.Decode.succeed msg)


viewApp : Model -> Html Msg
viewApp model =
    case model.songs of
        RemoteData.NotAsked ->
            text "Not asked yet"

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success songs ->
            div []
                [ Maybe.withDefault (text "No song selected") (Maybe.map viewPlayer model.activeSong)
                , div [] [ a [ href "", onClickPreventDefault (SelectRandomSong) ] [ text "Play random song!" ] ]
                , ul [] <|
                    List.map (\song -> li [] [ a [ href "", onClickPreventDefault (SelectSong (Just song)) ] [ text song.title ] ]) songs
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

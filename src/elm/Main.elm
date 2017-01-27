module Main exposing (..)

import Html exposing (..)
import Ports exposing (..)
import Types exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)

-- import Html.Attributes exposing (..)

import Html.Events exposing (onClick)


-- APP


main : Program Never Model Msg
main =
    Html.program { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


subscriptions : model -> Sub msg
subscriptions model =
    Sub.none


init : ( Model, Cmd msg )
init =
    ( { focused = Nothing
      , jobs =
            [ { name = "job1"
              , gets =
                    [ { name = "jobGets1"
                      , passed = []
                      }
                    ]
              }
            , { name = "job2"
              , gets =
                    [ { name = "jobGets1"
                      , passed = []
                      }
                    ]
              }
            ]
      }
    , Cmd.none
    )



-- UPDATE

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Submit ->
            ( model, Ports.toYAML model.jobs )

        Join jobName get ->
            case model.focused of
                Nothing ->
                    Debug.crash "I got nothing for focused"

                Just jobToAppend ->
                    let
                        updateGets gets =
                            List.map
                                (\aGet ->
                                    if aGet.name == get.name then
                                        { aGet | passed = jobToAppend :: get.passed }
                                    else
                                        aGet
                                )
                                gets

                        updateJob =
                            List.map
                                (\job ->
                                    if job.name == jobName then
                                        { job | gets = updateGets job.gets }
                                    else
                                        job
                                )
                                model.jobs
                    in
                        ( { model | jobs = updateJob }, Cmd.none )

        Select jobName ->
            ( { model | focused = Just jobName }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [] <|
        List.map jobRenderer model.jobs
            ++ [ button [ onClick Submit ] [ Html.text "boom" ]
                 , roundRect
               ]


jobRenderer : Job -> Html Msg
jobRenderer job =
    div []
        [ div [] [ button [ onClick <| Select job.name ] [ Html.text <| "select " ++ job.name ] ]
        , div [] <| List.map (getsRenderer job.name) job.gets
        ]


getsRenderer : String -> Get -> Html Msg
getsRenderer jobName get =
    div []
        [ div [] [ button [ onClick <| Join jobName get ] [ Html.text "join " ] ]
        ]

roundRect : Html.Html msg
roundRect =
      svg
            [ width "120", height "120", viewBox "0 0 120 120" ]
                  [ rect [ x "10", y "10", width "100", height "100", rx "15", ry "15" ] [] ]

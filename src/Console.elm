port module Console exposing (main)

import Bench exposing (suite)
import Benchmark exposing (Benchmark)
import Platform
import Process
import Task exposing (Task)


main : Platform.Program () Benchmark Msg
main =
    Platform.worker
        { init =
            always
                ( suite
                , Cmd.batch
                    [ progress "Starting..."
                    , next suite
                    ]
                )
        , update = update
        , subscriptions = always Sub.none
        }


port progress : String -> Cmd msg


type Msg
    = Step Benchmark


update : Msg -> Benchmark -> ( Benchmark, Cmd Msg )
update msg _ =
    case msg of
        Step benchmark ->
            ( benchmark
            , Cmd.batch
                [ progress "Stepping"
                , next benchmark
                ]
            )


next : Benchmark -> Cmd Msg
next benchmark =
    if Benchmark.done benchmark then
        progress "Done"

    else
        Benchmark.step benchmark
            |> breakForRender
            |> Task.perform Step


breakForRender : Task x a -> Task x a
breakForRender task =
    Task.andThen (\_ -> task) (Process.sleep 0)

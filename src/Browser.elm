module Browser exposing (main)

import Bench exposing (suite)
import Benchmark.Runner as Benchmark exposing (BenchmarkProgram)


main : BenchmarkProgram
main =
    Benchmark.program suite

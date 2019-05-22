module Bench exposing (suite)

import Benchmark exposing (Benchmark, benchmark)


suite : Benchmark
suite =
    let
        intList =
            List.range 1 1000
    in
    Benchmark.describe "Codegen experiments"
        [ benchmark "map"
            (\_ -> List.map identity intList)
        ]

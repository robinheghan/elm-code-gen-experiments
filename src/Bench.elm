module Bench exposing (suite)

import Benchmark exposing (Benchmark, benchmark)


suite : Benchmark
suite =
    let
        intList =
            List.range 1 1000

        stringList =
            List.map String.fromInt intList
    in
    Benchmark.describe "Codegen experiments"
        [ Benchmark.describe "Reverse"
            [ benchmark "ints" <|
                \_ -> List.reverse intList
            , benchmark "strings" <|
                \_ -> List.reverse stringList
            ]
        , Benchmark.describe "ReduceLeft"
            [ benchmark "int +" <|
                \_ -> List.foldl (+) 0 intList
            , benchmark "string ++" <|
                \_ -> List.foldl (++) "" stringList
            ]
        , Benchmark.describe "Map"
            [ benchmark "* 2" <|
                \_ -> List.map (\a -> a * 2) intList
            , benchmark "String reverse" <|
                \_ -> List.map String.reverse stringList
            ]
        , Benchmark.describe "Filter"
            [ benchmark "isEven" <|
                \_ -> List.filter (\a -> modBy 2 a == 0) intList
            , benchmark "String.endsWith 2" <|
                \_ -> List.filter (\a -> String.endsWith "2" a) stringList
            ]
        ]

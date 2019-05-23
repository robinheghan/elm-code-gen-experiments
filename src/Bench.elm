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
                \_ -> reverse intList
            , benchmark "strings" <|
                \_ -> reverse stringList
            ]
        , Benchmark.describe "ReduceLeft"
            [ benchmark "int +" <|
                \_ -> foldl (+) 0 intList
            , benchmark "string ++" <|
                \_ -> foldl (++) "" stringList
            ]
        , Benchmark.describe "Map"
            [ benchmark "* 2" <|
                \_ -> map (\a -> a * 2) intList
            , benchmark "String reverse" <|
                \_ -> map String.reverse stringList
            ]
        , Benchmark.describe "Filter"
            [ benchmark "isEven" <|
                \_ -> filter (\a -> modBy 2 a == 0) intList
            , benchmark "String.endsWith 2" <|
                \_ -> filter (\a -> String.endsWith "2" a) stringList
            ]
        ]


filter : (a -> Bool) -> List a -> List a
filter isGood list =
    foldr
        (\x xs ->
            if isGood x then
                x :: xs

            else
                xs
        )
        []
        list


map : (a -> b) -> List a -> List b
map f xs =
    foldr (\x acc -> f x :: acc) [] xs


foldl : (a -> b -> b) -> b -> List a -> b
foldl func acc list =
    case list of
        [] ->
            acc

        x :: xs ->
            foldl func (func x acc) xs


foldr : (a -> b -> b) -> b -> List a -> b
foldr fn acc ls =
    foldrHelper fn acc 0 ls


foldrHelper : (a -> b -> b) -> b -> Int -> List a -> b
foldrHelper fn acc ctr ls =
    case ls of
        [] ->
            acc

        a :: r1 ->
            case r1 of
                [] ->
                    fn a acc

                b :: r2 ->
                    case r2 of
                        [] ->
                            fn a (fn b acc)

                        c :: r3 ->
                            case r3 of
                                [] ->
                                    fn a (fn b (fn c acc))

                                d :: r4 ->
                                    let
                                        res =
                                            if ctr > 500 then
                                                foldl fn acc (reverse r4)

                                            else
                                                foldrHelper fn acc (ctr + 1) r4
                                    in
                                    fn a (fn b (fn c (fn d res)))


reverse : List a -> List a
reverse list =
    foldl (::) [] list

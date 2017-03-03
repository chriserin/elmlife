module Grid exposing (Grid, rows, neighbors, at, Address, blinker, empty)

import List exposing (take, drop, indexedMap, head, filterMap, map, concatMap, filter, length)
import Debug exposing (log)


type alias Grid a =
    { width : Int, cells : List a }


type alias Address =
    { row : Int, col : Int }


rows : Grid a -> List (List a)
rows grid =
    groupsOf grid.width grid.cells


groupsOf size list =
    let
        rest =
            drop size list
    in
        (take size list)
            :: (if rest == [] then
                    []
                else
                    (groupsOf size rest)
               )


neighbors : Grid a -> List ( a, List a )
neighbors grid =
    indexedMap (\i cell -> ( cell, (cellNeighbors i grid) )) grid.cells


at : Address -> Grid a -> Maybe a
at address grid =
    if address.col > (grid.width - 1) || address.col < 0 then
        Nothing
    else if address.row > ((height grid) - 1) || address.row < 0 then
        Nothing
    else
        head <| drop ((grid.width * address.row) + address.col) grid.cells


height : Grid a -> Int
height grid =
    (length grid.cells) // grid.width


cellNeighbors i grid =
    filterMap (\address -> (at address grid)) (neighborAddresses i grid)


toAddress i grid =
    Address (i // grid.width) (i % grid.width)


neighborAddresses : Int -> Grid a -> List Address
neighborAddresses i grid =
    let
        cell =
            toAddress i grid

        rows =
            [ cell.row - 1, cell.row, cell.row + 1 ]

        cols =
            [ cell.col - 1, cell.col, cell.col + 1 ]
    in
        filter (\address -> not <| address == cell) <| concatMap (\row -> (map (\col -> (Address row col)) cols)) rows


empty : Grid a
empty =
    Grid 0 []


blinker =
    (Grid 5
        ((List.repeat 7 False)
            ++ [ True ]
            ++ (List.repeat 4 False)
            ++ [ True ]
            ++ (List.repeat 4 False)
            ++ [ True ]
            ++ (List.repeat 7 False)
        )
    )

import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

type Coord =
  #(Int, Int)

fn find_tops(current: Coord, map) {
  let assert Ok(val) = dict.get(map, current)
  use <- bool.guard(val == 9, [current])

  [#(1, 0), #(0, 1), #(-1, 0), #(0, -1)]
  |> list.map(lib.tuple_add(current, _))
  |> list.map(fn(x) { #(dict.get(map, x), x) })
  |> list.filter(fn(x) { x.0 == Ok(val + 1) })
  |> list.map(fn(x) { find_tops(x.1, map) })
  |> list.flatten
}

pub fn solve(input: String) {
  let map =
    input
    |> lib.string_to_coordinates
    |> dict.from_list
    |> dict.map_values(fn(_, v) { lib.parse_int(v) })

  let tops =
    dict.filter(map, fn(_, v) { v == 0 })
    |> dict.keys
    |> list.map(find_tops(_, map))

  let p1 =
    tops
    |> list.map(list.unique)
    |> list.map(list.length)
    |> int.sum

  let p2 =
    tops
    |> list.map(list.length)
    |> int.sum

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day10.txt")
  let input = string.trim(input)
  let test_input =
    "89010123
78121874
87430965
96549874
45678903
32019012
01329801
10456732"
  io.debug(solve(input))
}

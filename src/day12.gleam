import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import lib
import simplifile

fn edges(coord: #(Int, Int), map: dict.Dict(#(Int, Int), String)) {
  let letter = dict.get(map, coord) |> lib.unwrap
  [#(1, 0), #(-1, 0), #(0, 1), #(0, -1)]
  |> list.filter_map(fn(x) { dict.get(map, lib.tuple_add(coord, x)) })
  |> list.filter(fn(x) { x == letter })
  |> list.length
  |> int.subtract(4, _)
}

fn get_field(map: Dict(#(Int, Int), String), start: #(Int, Int)) {
  use <- bool.guard(!dict.has_key(map, start), #([], map))

  let letter = dict.get(map, start) |> lib.unwrap

  // Get all adjacent plots with same letter
  let adj =
    [#(1, 0), #(-1, 0), #(0, 1), #(0, -1)]
    |> list.filter_map(fn(x) {
      dict.get(map, lib.tuple_add(start, x))
      |> result.map(fn(v) { #(lib.tuple_add(start, x), v) })
    })
    |> list.filter(fn(x) { x.1 == letter })
    |> list.map(fn(x) { x.0 })

  // Remove current plot so we don't go in circles
  let map = dict.delete(map, start)

  let #(l, m) =
    list.fold(adj, #([], map), fn(acc, x) {
      let #(l, m) = get_field(acc.1, x)
      #(list.append(l, acc.0), m)
    })

  let l = list.prepend(l, start)
  #(l, m)
}

pub fn solve(input: String) {
  let map =
    input
    |> lib.string_to_coordinates
    |> dict.from_list
  let groups =
    dict.keys(map)
    |> list.fold(#([], map), fn(acc, x) {
      let #(l, m) = get_field(acc.1, x)
      #([l, ..acc.0], m)
    })
  groups.0
  |> list.filter(fn(x) { !list.is_empty(x) })
  |> list.map(fn(x) {
    list.length(x) * { list.map(x, edges(_, map)) |> int.sum }
  })
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day12.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

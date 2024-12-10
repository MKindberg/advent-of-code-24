import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string

pub type Coord =
  #(Int, Int)

pub fn string_to_coordinates(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> grid_to_coordinates
}

pub fn grid_to_coordinates(grid: List(List(String))) -> List(#(Coord, String)) {
  grid
  |> list.zip(list.range(1, list.length(grid)))
  |> list.map(fn(x) {
    let coordinates =
      list.zip(
        list.range(1, list.length(x.0)),
        list.repeat(x.1, list.length(x.0)),
      )
    list.zip(coordinates, x.0)
  })
  |> list.flatten
}

pub fn tuple_map(t: #(a, a), f: fn(a) -> b) -> #(b, b) {
  #(f(t.0), f(t.1))
}

pub fn tuple_add(a: #(Int, Int), b: #(Int, Int)) -> #(Int, Int) {
  #(a.0 + b.0, a.1 + b.1)
}

pub fn parse_int(i: String) {
  i |> int.parse |> unwrap
}

pub fn unwrap(r) {
  r |> result.lazy_unwrap(fn() { panic })
}

pub fn out_of_bounds(n: Coord, width, height) -> Bool {
  use <- bool.guard(n.0 > width, True)
  use <- bool.guard(n.0 < 1, True)
  use <- bool.guard(n.1 > height, True)
  use <- bool.guard(n.1 < 1, True)
  False
}

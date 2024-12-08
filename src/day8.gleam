import gleam/bool
import gleam/dict
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import simplifile

type Coord =
  #(Int, Int)

fn grid_to_coordinates(grid: List(List(String))) -> List(#(String, #(Int, Int))) {
  grid
  |> list.zip(list.range(1, list.length(grid)))
  |> list.map(fn(x) {
    let coordinates =
      list.zip(
        list.range(1, list.length(x.0)),
        list.repeat(x.1, list.length(x.0)),
      )
    list.zip(x.0, coordinates)
  })
  |> list.flatten
  |> list.filter(fn(x) { x.0 != "." })
}

fn diff(n1: Coord, n2: Coord) -> Coord {
  #(n1.0 - n2.0, n1.1 - n2.1)
}

fn out_of_bounds(n: Coord, width, height) -> Bool {
  use <- bool.guard(n.0 > width, True)
  use <- bool.guard(n.0 < 1, True)
  use <- bool.guard(n.1 > height, True)
  use <- bool.guard(n.1 < 1, True)
  False
}

fn tuple_add(t1: #(Int, Int), t2: #(Int, Int)) {
  #(t1.0 + t2.0, t1.1 + t2.1)
}

fn tuple_add_n(t1: #(Int, Int), t2: #(Int, Int), n) {
  #(t1.0 + t2.0 * n, t1.1 + t2.1 * n)
}

fn antinodes_pair(p: #(#(String, Coord), #(String, Coord))) {
  let c1 = p.0.1
  let c2 = p.1.1
  let d = diff(c1, c2)
  let nd = #(-d.0, -d.1)

  let a1 = tuple_add(c1, d)
  let a2 = tuple_add(c2, nd)

  [a1, a2]
}

fn antinodes_pair2(p: #(#(String, Coord), #(String, Coord)), inside_bounds) {
  let c1 = p.0.1
  let c2 = p.1.1
  let d = diff(c1, c2)
  let nd = #(-d.0, -d.1)

  let a1 =
    yielder.range(0, 1000)
    |> yielder.map(tuple_add_n(c1, d, _))
    |> yielder.take_while(inside_bounds)
    |> yielder.to_list
  let a2 =
    yielder.range(0, 1000)
    |> yielder.map(tuple_add_n(c2, nd, _))
    |> yielder.take_while(inside_bounds)
    |> yielder.to_list

  list.append(a1, a2)
}

fn antinodes(l, inside_bounds) {
  l
  |> list.combination_pairs
  |> list.map(antinodes_pair)
  |> list.flatten
  |> list.filter(inside_bounds)
}

fn antinodes2(l, inside_bounds) {
  l
  |> list.combination_pairs
  |> list.map(antinodes_pair2(_, inside_bounds))
  |> list.flatten
  |> list.filter(inside_bounds)
}

pub fn part1(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width = list.first(grid) |> result.unwrap([]) |> list.length
  let inside_bounds = fn(c) { !out_of_bounds(c, width, height) }

  grid
  |> grid_to_coordinates
  |> list.group(fn(x) { x.0 })
  |> dict.to_list
  |> list.map(fn(x) { x.1 })
  // |> list.chunk(fn(x) { x.0 })
  |> list.map(antinodes(_, inside_bounds))
  |> list.flatten
  |> list.unique
  |> list.length
}

pub fn part2(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width = list.first(grid) |> result.unwrap([]) |> list.length
  let inside_bounds = fn(c) { !out_of_bounds(c, width, height) }

  grid
  |> grid_to_coordinates
  |> list.group(fn(x) { x.0 })
  |> dict.to_list
  |> list.map(fn(x) { x.1 })
  // |> list.chunk(fn(x) { x.0 })
  |> list.map(antinodes2(_, inside_bounds))
  |> list.flatten
  |> list.unique
  |> list.length
}

const test_input = "............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day8.txt")
  let input = string.trim(input)
  io.debug(part1(test_input))
  io.debug(part1(input))
  io.debug(part2(test_input))
  io.debug(part2(input))
}

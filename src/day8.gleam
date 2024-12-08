import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import simplifile

type Coord =
  #(Int, Int)

fn grid_to_coordinates(grid: List(List(String))) -> List(#(String, Coord)) {
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

fn gen_2_antinodes(p: #(Coord, Coord), inside_bounds) {
  let d = diff(p.0, p.1)
  let nd = tuple_map(d, int.negate)

  let a1 = tuple_add(p.0, d)
  let a2 = tuple_add(p.1, nd)

  [a1, a2] |> list.filter(inside_bounds)
}

fn gen_all_antinodes(p: #(Coord, Coord), inside_bounds) {
  let d = diff(p.0, p.1)
  let nd = tuple_map(d, int.negate)

  let a1 =
    yielder.range(0, 1000)
    |> yielder.map(tuple_add_n(p.0, d, _))
    |> yielder.take_while(inside_bounds)
    |> yielder.to_list
  let a2 =
    yielder.range(0, 1000)
    |> yielder.map(tuple_add_n(p.1, nd, _))
    |> yielder.take_while(inside_bounds)
    |> yielder.to_list

  list.append(a1, a2)
}

fn antinodes(l, generator, inside_bounds) {
  l
  |> list.combination_pairs
  |> list.map(generator(_, inside_bounds))
  |> list.flatten
}

fn count_unique(l) -> Int {
  l
  |> list.flatten
  |> list.unique
  |> list.length
}

fn tuple_map(t: #(a, a), f: fn(a) -> b) -> #(b, b) {
  #(f(t.0), f(t.1))
}

pub fn solve(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width = list.first(grid) |> result.unwrap([]) |> list.length
  let inside_bounds = fn(c) { !out_of_bounds(c, width, height) }

  let groups =
    grid
    |> grid_to_coordinates
    |> list.sort(fn(a, b) { string.compare(a.0, b.0) })
    |> list.chunk(fn(x) { x.0 })
    |> list.map(list.map(_, fn(x) { x.1 }))

  #(gen_2_antinodes, gen_all_antinodes)
  |> tuple_map(fn(f) { list.map(groups, antinodes(_, f, inside_bounds)) })
  |> tuple_map(count_unique)
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
  io.debug(solve(test_input))
  io.debug(solve(input))
}

import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn tuple_map(t: #(a, a), func: fn(a) -> b) {
  #(func(t.0), func(t.1))
}

fn to_int(in: String) -> Int {
  case int.parse(in) {
    Ok(n) -> n
    _ -> panic
  }
}

fn to_lists(in: String) {
  in
  |> string.split("\n")
  |> list.map(fn(x) { string.split_once(x, "   ") })
  |> result.values
  |> list.map(tuple_map(_, to_int))
  |> list.unzip
}

pub fn solve(input: String) {
  #(part1(input), part2(input))
}

fn part1(input: String) {
  let #(l1, l2) =
    to_lists(input)
    |> tuple_map(list.sort(_, int.compare))
  list.zip(l1, l2)
  |> list.map(fn(x) { int.absolute_value(x.0 - x.1) })
  |> int.sum
}

fn part2(input: String) {
  let #(l1, l2) = to_lists(input)
  list.map(l1, fn(x) { x * list.count(l2, fn(y) { x == y }) })
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day1.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

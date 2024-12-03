import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import simplifile

fn is_safe(l: List(Int)) -> Bool {
  let diffs = l |> list.zip(list.drop(l, 1)) |> list.map(fn(x) { x.0 - x.1 })
  list.all(diffs, fn(x) { x > 0 && x < 4 })
  || list.all(diffs, fn(x) { x < 0 && x > -4 })
}

fn is_safe2(l: List(Int)) -> Bool {
  yielder.range(0, list.length(l))
  |> yielder.map(fn(n) { list.append(list.take(l, n), list.drop(l, n + 1)) })
  |> yielder.map(is_safe)
  |> yielder.any(fn(x) { x })
}

fn to_int(s: String) -> List(Int) {
  s |> string.split(" ") |> list.map(int.parse) |> result.values
}

pub fn part1(input: String) {
  input
  |> string.split("\n")
  |> list.map(to_int)
  |> list.map(is_safe)
  |> list.count(fn(x) { x })
}

pub fn part2(input: String) {
  input
  |> string.split("\n")
  |> list.map(to_int)
  |> list.map(is_safe2)
  |> list.count(fn(x) { x })
}

pub fn main() {
  let input =
    simplifile.read("input/day2.txt") |> result.unwrap("") |> string.trim
  io.debug(part1(input))
  io.debug(part2(input))
}

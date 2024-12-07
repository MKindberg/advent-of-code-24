import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn to_ints(in: String) {
  let assert Ok(#(ans, vals)) = in |> string.split_once(": ")

  let assert Ok(ans) = ans |> int.parse
  let assert Ok(vals) =
    vals |> string.split(" ") |> list.map(int.parse) |> result.all

  #(ans, vals)
}

fn is_solvable(vals, ans) -> Bool {
  let assert [first, ..rest] = vals
  is_solvable_iter(rest, ans, first)
}

fn is_solvable_iter(vals, ans, acc) -> Bool {
  use <- bool.guard(acc > ans, False)

  case vals {
    [] -> acc == ans
    [f, ..rest] ->
      is_solvable_iter(rest, ans, acc + f)
      || is_solvable_iter(rest, ans, acc * f)
  }
}

fn concat(a, b) -> Int {
  { int.to_string(a) <> int.to_string(b) } |> int.parse |> result.unwrap(0)
}

fn is_solvable2(vals, ans) -> Bool {
  let assert [first, ..rest] = vals
  is_solvable_iter2(rest, ans, first)
}

fn is_solvable_iter2(vals, ans, acc) -> Bool {
  use <- bool.guard(acc > ans, False)

  case vals {
    [] -> acc == ans
    [f, ..rest] ->
      is_solvable_iter2(rest, ans, acc + f)
      || is_solvable_iter2(rest, ans, acc * f)
      || is_solvable_iter2(rest, ans, concat(acc, f))
  }
}

pub fn part1(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(to_ints)
  |> list.filter(fn(x) { is_solvable(x.1, x.0) })
  |> list.map(fn(x) { x.0 })
  |> int.sum
}

pub fn part2(input: String) {
  input
  |> string.trim
  |> string.split("\n")
  |> list.map(to_ints)
  |> list.filter(fn(x) { is_solvable2(x.1, x.0) })
  |> list.map(fn(x) { x.0 })
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day7.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

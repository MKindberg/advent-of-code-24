import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

fn transform(i: Int) -> List(Int) {
  use <- bool.guard(i == 0, [1])
  let assert Ok(digits) = int.digits(i, 10)
  let len = list.length(digits)
  use <- bool.lazy_guard(len % 2 == 0, fn() {
    [
      list.take(digits, len / 2) |> int.undigits(10) |> lib.unwrap,
      list.drop(digits, len / 2) |> int.undigits(10) |> lib.unwrap,
    ]
  })
  [i * 2024]
}

fn blink(d: Dict(Int, Int)) -> Dict(Int, Int) {
  use acc, key, val <- dict.fold(d, dict.new())
  use acc, x <- list.fold(transform(key), acc)
  lib.dict_add(acc, x, val)
}

fn stones_after_n(n: Int, input: Dict(Int, Int)) -> Int {
  list.range(1, n)
  |> list.fold(input, fn(acc, _) { blink(acc) })
  |> dict.values
  |> int.sum
}

pub fn solve(input: String) {
  let input = input |> string.split(" ") |> list.map(lib.parse_int)
  let input =
    input
    |> list.map(fn(x) { #(x, list.count(input, fn(y) { y == x })) })
    |> dict.from_list

  [25, 75] |> list.map(stones_after_n(_, input))
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day11.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

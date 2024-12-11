import gleam/bool
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

fn blink(l: List(Int)) -> List(Int) {
  l |> list.map(transform) |> list.flatten
}

pub fn solve(input: String) {
  let input = input |> string.split(" ") |> list.map(lib.parse_int)
  list.range(1, 25)
  |> list.fold(input, fn(acc, _) { blink(acc) })
  |> list.length
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day11.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

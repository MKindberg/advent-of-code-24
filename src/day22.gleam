import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import lib
import simplifile

fn mix(a, b) {
  int.bitwise_exclusive_or(a, b)
}

fn prune(a) {
  int.modulo(a, 16_777_216) |> lib.unwrap
}

fn next(n) {
  let n =
    n
    |> mix(n * 64)
    |> prune
  let n =
    n
    |> mix(n / 32)
  n
  |> mix(n * 2048)
  |> prune
}

fn loop(n, f, arg) {
  use <- bool.lazy_guard(n <= 1, fn() { f(arg) })
  loop(n - 1, f, f(arg))
}

fn gen_2000(start) {
  loop(2000, next, start)
}
pub fn solve(input: String) {
  let initials =
    input |> string.split("\n") |> list.map(int.parse) |> result.values
  let p1 = initials |> list.map(gen_2000) |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day22.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

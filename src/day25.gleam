import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn num_pins(l) {
  l
  |> list.drop(1)
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(list.count(_, fn(x) { x == "#" }))
}

fn try(lock, key) {
  list.zip(lock, key) |> list.all(fn(x) { x.0 + x.1 <= 5 })
}

fn try_lock(lock, keys) {
  use matches, key <- list.fold(keys, 0)
  use <- bool.guard(try(lock, key), matches + 1)
  matches
}

pub fn solve(input: String) {
  let #(locks, keys) =
    input
    |> string.split("\n\n")
    |> list.partition(string.starts_with(_, "#####"))

  let locks = locks |> list.map(string.split(_, "\n")) |> list.map(num_pins)
  let keys =
    keys
    |> list.map(string.split(_, "\n"))
    |> list.map(list.reverse)
    |> list.map(num_pins)
  locks |> list.map(try_lock(_, keys)) |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day25.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

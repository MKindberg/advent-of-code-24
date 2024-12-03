import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn part1(input: String) {
  let assert Ok(r) = regexp.from_string("mul\\((\\d{1,3}),(\\d{0,3})\\)")
  regexp.scan(r, input)
  |> list.map(fn(x) { x.submatches })
  |> list.flatten
  |> option.values
  |> list.map(int.parse)
  |> result.values
  |> list.sized_chunk(2)
  |> list.map(int.product)
  |> int.sum
}

fn filter_do(in: String) -> String {
  let assert Ok(r) = regexp.from_string("don't\\(\\).*?(do\\(\\)|$)")
  regexp.split(r, in)
  |> string.join("")
}

pub fn part2(input: String) {
  input |> string.split("\n") |> string.join("") |> filter_do |> part1
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day3.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

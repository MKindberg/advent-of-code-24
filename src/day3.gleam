import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

fn to_ints(l) -> List(Int) {
  l |> option.values |> list.map(int.parse) |> result.values
}

pub fn part1(input: String) {
  let assert Ok(r) = regexp.from_string("mul\\((\\d{1,3}),(\\d{0,3})\\)")
  regexp.scan(r, input)
  |> list.map(fn(x) { x.submatches })
  |> list.map(to_ints)
  |> list.map(int.product)
  |> int.sum
}

pub fn part2(input: String) {
  let assert Ok(r) = regexp.from_string("don't\\(\\).*?(do\\(\\)|$)")
  input
  |> string.replace(each: "\n", with: "")
  |> regexp.replace(each: r, with: "")
  |> part1
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day3.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

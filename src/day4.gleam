import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import simplifile

fn search_h(l: List(String), word: String) -> Int {
  l
  |> list.map(string.split(_, word))
  |> list.map(fn(x) { list.length(x) - 1 })
  |> int.sum
}

fn search_v(l: List(String), word: String) -> Int {
  l
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(string.join(_, ""))
  |> search_h(word)
}

fn to_diag1(l: List(String)) -> List(String) {
  list.zip(list.range(0, 3), l)
  |> list.map(fn(x) { string.drop_start(x.1, x.0) |> string.drop_end(3 - x.0) })
}

fn to_diag2(l: List(String)) -> List(String) {
  list.zip(list.range(3, 0), l)
  |> list.map(fn(x) { string.drop_start(x.1, x.0) })
}

fn search_d1(l: List(String), word: String) -> Int {
  list.window(l, 4)
  |> list.map(to_diag1)
  |> list.map(search_v(_, word))
  |> int.sum
}

fn search_d2(l: List(String), word: String) -> Int {
  list.window(l, 4)
  |> list.map(to_diag2)
  |> list.map(search_v(_, word))
  |> int.sum
}

fn search(l, word: String) {
  [search_h, search_v, search_d1, search_d2]
  |> list.map(fn(f) { f(l, word) })
  |> int.sum
}

pub fn part1(input: String) {
  let l = string.split(input, "\n")
  search(l, "XMAS") + search(l, "SAMX")
}

fn starts_with_x(l: List(List(String))) -> Bool {
  case l {
    [["M", _, "M", ..], [_, "A", _, ..], ["S", _, "S", ..], ..] -> True
    [["S", _, "S", ..], [_, "A", _, ..], ["M", _, "M", ..], ..] -> True
    [["M", _, "S", ..], [_, "A", _, ..], ["M", _, "S", ..], ..] -> True
    [["S", _, "M", ..], [_, "A", _, ..], ["S", _, "M", ..], ..] -> True
    _ -> False
  }
}

fn num_x(l: List(List(String))) -> Int {
  l
  // Window over columns
  |> list.map(list.window(_, 3))
  |> list.transpose
  |> list.map(starts_with_x)
  |> list.count(fn(x) { x })
}

pub fn part2(input: String) {
  input
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  // Window over rows
  |> list.window(3)
  |> list.map(num_x)
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day4.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

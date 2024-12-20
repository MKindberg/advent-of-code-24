import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import lib
import simplifile

fn is_valid(pattern: String, types: List(String)) -> Bool {
  use <- bool.guard(string.is_empty(pattern), True)
  types
  |> list.filter(string.starts_with(pattern, _))
  |> list.map(fn(t) { string.drop_start(pattern, string.length(t)) })
  |> list.any(is_valid(_, types))
}

fn num_valid(
  pattern: String,
  types: List(String),
  cache: Dict(Int, Int),
) -> #(Int, Dict(Int, Int)) {
  use <- bool.guard(string.is_empty(pattern), #(1, cache))
  use <- bool.lazy_guard(dict.has_key(cache, string.length(pattern)), fn() {
    #(dict.get(cache, string.length(pattern)) |> lib.unwrap, cache)
  })

  string.to_graphemes(pattern)
  |> list.fold_right([], fn(acc, x) {
    list.last(acc)
    |> result.unwrap([])
    |> list.prepend(x)
    |> list.prepend(acc, _)
  })
  |> list.map(string.join(_, ""))

  let #(n, cache) =
    types
    |> list.filter(fn(x) { string.starts_with(pattern, x) })
    |> list.map(fn(x) { string.drop_start(pattern, string.length(x)) })
    |> list.fold(#(0, cache), fn(acc, x) {
      let a = num_valid(x, types, acc.1)
      #(a.0 + acc.0, a.1)
    })

  let cache = dict.insert(cache, string.length(pattern), n)

  #(n, cache)
}

pub fn solve(input: String) {
  let assert Ok(#(types, patterns)) = string.split_once(input, "\n\n")
  let types = types |> string.split(", ")
  let patterns = patterns |> string.split("\n")

  let p1 = patterns |> list.map(is_valid(_, types)) |> list.count(fn(x) { x })
  let p2 =
    patterns
    |> list.map(num_valid(_, types, dict.new()))
    |> list.map(fn(x) { x.0 })
    |> int.sum

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day19.txt")
  let input = string.trim(input)
  //     let input =
  //       "r, wr, b, g, bwu, rb, gb, br
  //
  // brwrr
  // bggr
  // gbbr
  // rrbgbr
  // ubwu
  // bwurrg
  // brgr
  // bbrgwb
  // " |> string.trim()
  io.debug(solve(input))
}

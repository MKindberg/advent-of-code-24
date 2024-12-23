import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/string
import lib
import simplifile

fn dict_append(d, k, v) {
  dict.upsert(d, k, fn(e) {
    case e {
      Some(l) -> [v, ..l]
      None -> [v]
    }
  })
}

fn group(d, l) -> Bool {
  let assert [a, b, c] = l
  let aa = dict.get(d, a) |> lib.unwrap
  let bb = dict.get(d, b) |> lib.unwrap

  list.contains(aa, b) && list.contains(aa, c) && list.contains(bb, c)
}

fn dict_from_list(l: List(#(String, String))) {
  l
  |> list.fold(dict.new(), fn(d, x) {
    d |> dict_append(x.0, x.1) |> dict_append(x.1, x.0)
  })
}

fn contains_t(l) {
  list.any(l, string.starts_with(_, "t"))
}

pub fn solve(input: String) {
  let paths =
    input
    |> string.split("\n")
    |> list.map(string.split_once(_, "-"))
    |> result.values
    |> dict_from_list
    |> dict.map_values(fn(_, v) { list.reverse(v) })

  let p1 =
    paths
    |> dict.filter(fn(_, v) { list.length(v) > 1 })
    |> dict.to_list
    |> list.map(fn(x) {
      list.combinations(x.1, 2) |> list.map(list.prepend(_, x.0))
    })
    |> list.flatten
    |> list.filter(contains_t)
    |> list.filter(fn(x) { group(paths, x) })
    |> list.map(list.sort(_, string.compare))
    |> list.unique
    |> list.length

  p1
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day23.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

import gleam/bool
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
  use <- bool.guard(list.is_empty(l), True)

  let assert Ok(#(first, rest)) = list.pop(l, fn(_) { True })
  let connections = dict.get(d, first) |> lib.unwrap
  list.all(rest, list.contains(connections, _)) && group(d, rest)
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

fn num_groups_t(paths, len) {
  paths
  |> dict.filter(fn(_, v) { list.length(v) >= len - 1 })
  |> dict.to_list
  |> list.map(fn(x) {
    list.combinations(x.1, len - 1) |> list.map(list.prepend(_, x.0))
  })
  |> list.flatten
  |> list.filter(contains_t)
  |> list.filter(fn(x) { group(paths, x) })
  |> list.map(list.sort(_, string.compare))
  |> list.unique
  |> list.map(string.join(_, ","))
  |> list.length
}

fn groups_of_size(paths, len) {
  paths
  |> dict.filter(fn(_, v) { list.length(v) >= len - 1 })
  |> dict.to_list
  |> list.map(fn(x) {
    list.combinations(x.1, len - 1) |> list.map(list.prepend(_, x.0))
  })
  |> list.flatten
  |> list.filter(fn(x) { group(paths, x) })
  |> list.map(list.sort(_, string.compare))
  |> list.unique
}

pub fn solve(input: String) {
  let paths =
    input
    |> string.split("\n")
    |> list.map(string.split_once(_, "-"))
    |> result.values
    |> dict_from_list
    |> dict.map_values(fn(_, v) { list.reverse(v) })

  let p1 = num_groups_t(paths, 3)
  let p2 = groups_of_size(paths, 13) |> list.flatten |> string.join(",")

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day23.txt")
  let input = string.trim(input)
  let test_input =
    "kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn"
  io.debug(solve(input))
}

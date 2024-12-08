import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import simplifile

fn append_to_dict(
  d: dict.Dict(a, List(b)),
  kv: #(a, b),
) -> dict.Dict(a, List(b)) {
  case dict.get(d, kv.0) {
    Ok(l) -> dict.insert(d, kv.0, [kv.1, ..l])
    _ -> dict.insert(d, kv.0, [kv.1])
  }
}

fn tuple_to_int(t: #(String, String)) -> #(Int, Int) {
  #(t.0 |> int.parse |> result.unwrap(0), t.1 |> int.parse |> result.unwrap(0))
}

fn parse_rules(in: String) -> dict.Dict(Int, List(Int)) {
  let d = dict.new()
  in
  |> string.split("\n")
  |> list.map(string.split_once(_, "|"))
  |> result.values
  |> list.map(tuple_to_int)
  |> list.fold(d, append_to_dict)
}

fn parse_updates(in: String) -> List(List(Int)) {
  in
  |> string.split("\n")
  |> list.map(string.split(_, ","))
  |> list.map(list_to_ints)
}

fn get_middle(update: List(Int)) -> Int {
  let len = list.length(update)
  update
  |> list.drop(len / 2)
  |> list.first
  |> result.unwrap(0)
}

pub fn solve(input: String) {
  #(part1(input), part2(input))
}

pub fn part1(input: String) {
  let assert [rules, updates] = string.split(input, "\n\n")
  let rules = parse_rules(rules)
  let updates = parse_updates(updates)

  updates
  |> list.map(list.sort(_, fn(a, b) { compare_rules(rules, a, b) }))
  |> list.zip(updates)
  |> list.filter(fn(x) { x.0 == x.1 })
  |> list.map(fn(x) { x.0 })
  |> list.map(get_middle)
  |> int.sum
}

fn list_to_ints(l: List(String)) {
  list.map(l, int.parse) |> result.values
}

fn compare_rules(rules, a: Int, b: Int) {
  let l1 = dict.get(rules, a) |> result.unwrap([])
  let l2 = dict.get(rules, b) |> result.unwrap([])
  use <- bool.guard(list.contains(l1, b), order.Lt)
  use <- bool.guard(list.contains(l2, a), order.Gt)
  order.Eq
}

pub fn part2(input: String) {
  let assert [rules, updates] = string.split(input, "\n\n")
  let rules = parse_rules(rules)
  let updates = parse_updates(updates)

  updates
  |> list.map(list.sort(_, fn(a, b) { compare_rules(rules, a, b) }))
  |> list.zip(updates)
  |> list.filter(fn(x) { x.0 != x.1 })
  |> list.map(fn(x) { x.0 })
  |> list.map(get_middle)
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day5.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

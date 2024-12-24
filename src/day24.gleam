import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import lib
import simplifile

fn parse_con(con) {
  let assert [a, op, b, _, c] = con |> string.split(" ")
  #(a, op, b, c)
}

fn ready(con: #(String, String, String, String), values) {
  dict.has_key(values, con.0) && dict.has_key(values, con.2)
}

fn go(con: #(String, String, String, String), vals) {
  let v1 = dict.get(vals, con.0) |> lib.unwrap
  let v2 = dict.get(vals, con.2) |> lib.unwrap
  let res = case con.1 {
    "AND" -> int.bitwise_and(v1, v2)
    "OR" -> int.bitwise_or(v1, v2)
    "XOR" -> int.bitwise_exclusive_or(v1, v2)
    _ -> panic
  }
  #(con.3, res)
}

fn iter(cons, vals) {
  use <- bool.guard(list.is_empty(cons), vals)
  let #(r, w) = list.partition(cons, ready(_, vals))

  let r = list.map(r, go(_, vals)) |> dict.from_list
  let vals = dict.merge(vals, r)

  iter(w, vals)
}

pub fn solve(input: String) {
  let assert Ok(#(init, connections)) = input |> string.split_once("\n\n")
  let values =
    init
    |> string.split("\n")
    |> list.map(string.split_once(_, ": "))
    |> result.values
    |> dict.from_list
    |> dict.map_values(fn(_, v) { v |> int.parse |> lib.unwrap })

  let connections = connections |> string.split("\n") |> list.map(parse_con)

  iter(connections, values)
  |> dict.filter(fn(k, _) { string.starts_with(k, "z") })
  |> dict.to_list
  |> list.sort(fn(a, b) { string.compare(b.0, a.0) })
  |> list.map(fn(x) { int.to_string(x.1) })
  |> string.join("")
  |> int.base_parse(2)
  |> lib.unwrap
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day24.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

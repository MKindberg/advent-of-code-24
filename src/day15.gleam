import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

fn can_move(map: dict.Dict(#(Int, Int), String), robot: #(Int, Int), dir) {
  let r2 = lib.tuple_add(robot, dir)
  let assert Ok(c) = dict.get(map, r2)
  use <- bool.guard(c != "O", #(r2, c))
  can_move(map, r2, dir)
}

fn double_map(map: dict.Dict(#(Int, Int), String)) {
  dict.to_list(map)
  |> list.fold(dict.new(), fn(m, x) {
    case x {
      #(c, ".") -> {
        m
        |> dict.insert(#(c.0 * 2, c.1), ".")
        |> dict.insert(#(c.0 * 2 + 1, c.1), ".")
      }
      #(c, "#") -> {
        m
        |> dict.insert(#(c.0 * 2, c.1), "#")
        |> dict.insert(#(c.0 * 2 + 1, c.1), "#")
      }
      #(c, "O") -> {
        m
        |> dict.insert(#(c.0 * 2, c.1), "[")
        |> dict.insert(#(c.0 * 2 + 1, c.1), "]")
      }
      #(c, "@") -> {
        m
        |> dict.insert(#(c.0 * 2, c.1), "@")
        |> dict.insert(#(c.0 * 2 + 1, c.1), ".")
      }
      _ -> panic
    }
  })
}

fn step(
  map: dict.Dict(#(Int, Int), String),
  robot: #(Int, Int),
  dir: String,
) -> #(dict.Dict(#(Int, Int), String), #(Int, Int)) {
  let dir = case dir {
    "<" -> #(-1, 0)
    "^" -> #(0, -1)
    ">" -> #(1, 0)
    "v" -> #(0, 1)
    _ -> panic
  }
  let r2 = lib.tuple_add(robot, dir)
  case can_move(map, robot, dir) {
    #(_, "#") -> #(map, robot)
    #(c, ".") -> {
      let map =
        map
        |> dict.insert(c, "O")
        |> dict.insert(robot, ".")
        |> dict.insert(lib.tuple_add(robot, dir), "@")
      #(map, r2)
    }
    _ -> panic
  }
}

fn step2(
  map: dict.Dict(#(Int, Int), String),
  robot: #(Int, Int),
  dir: String,
) -> #(dict.Dict(#(Int, Int), String), #(Int, Int)) {
  let dir = case dir {
    "<" -> #(-1, 0)
    "^" -> #(0, -1)
    ">" -> #(1, 0)
    "v" -> #(0, 1)
    _ -> panic
  }
  let r2 = lib.tuple_add(robot, dir)
  todo
}

pub fn solve(input: String) {
  let assert Ok(#(map, steps)) = input |> string.split_once("\n\n")
  let map = map |> lib.string_to_coordinates |> dict.from_list
  let steps = steps |> string.replace("\n", "") |> string.to_graphemes
  let #(robot, _) =
    dict.filter(map, fn(_, v) { v == "@" })
    |> dict.to_list
    |> list.first
    |> lib.unwrap

  let p1 =
    list.fold(steps, #(map, robot), fn(acc, x) { step(acc.0, acc.1, x) }).0
    |> dict.filter(fn(_, v) { v == "O" })
    |> dict.keys
    |> list.map(fn(x) { { x.1 - 1 } * 100 + x.0 - 1 })
    |> int.sum

  let map = double_map(map)
  let p2 =
    list.fold(steps, #(map, robot), fn(acc, x) { step2(acc.0, acc.1, x) }).0
    |> dict.filter(fn(_, v) { v == "[" })
    |> dict.keys
    |> list.map(fn(x) { { x.1 - 1 } * 100 + x.0 - 1 })
    |> int.sum

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day15.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

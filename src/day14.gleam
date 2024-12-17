import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

const width = 101

const height = 103

type Pos {
  Pos(x: Int, y: Int)
}

type Robot {
  Robot(p: Pos, v: Pos)
}

fn parse_pair(p) {
  p
  |> string.drop_start(2)
  |> string.split_once(",")
  |> lib.unwrap
  |> lib.tuple_map(int.parse)
  |> lib.tuple_map(lib.unwrap)
  |> fn(x) { Pos(x.0, x.1) }
}

fn parse_robot(robot: String) {
  robot
  |> string.split_once(" ")
  |> lib.unwrap
  |> lib.tuple_map(parse_pair)
  |> fn(x) { Robot(x.0, x.1) }
}

fn parse(input: String) {
  input |> string.split("\n") |> list.map(parse_robot)
}

fn step(r: Robot) {
  Robot(
    Pos(
      int.modulo(r.p.x + r.v.x, width) |> lib.unwrap,
      int.modulo(r.p.y + r.v.y, height) |> lib.unwrap,
    ),
    r.v,
  )
}

pub fn solve(input: String) {
  let robots = input |> parse

  list.range(1, 100)
  |> list.fold(robots, fn(acc, _) { list.map(acc, step) })
  |> list.fold(#(0, 0, 0, 0), fn(a, r) {
    case r.p.x, r.p.y {
      x, y if x < width / 2 && y < height / 2 -> #(a.0 + 1, a.1, a.2, a.3)
      x, y if x < width / 2 && y > height / 2 -> #(a.0, a.1 + 1, a.2, a.3)
      x, y if x > width / 2 && y < height / 2 -> #(a.0, a.1, a.2 + 1, a.3)
      x, y if x > width / 2 && y > height / 2 -> #(a.0, a.1, a.2, a.3 + 1)
      _, _ -> #(a.0, a.1, a.2, a.3)
    }
  })
  |> fn(x) { x.0 * x.1 * x.2 * x.3 }
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day14.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

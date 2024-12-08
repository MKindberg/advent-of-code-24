import gleam/bool
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import simplifile

type Dir {
  Up
  Right
  Down
  Left
}

fn step(guard: #(Dir, #(Int, Int))) -> #(Dir, #(Int, Int)) {
  case guard {
    #(Up, c) -> #(Up, #(c.0, c.1 - 1))
    #(Right, c) -> #(Right, #(c.0 + 1, c.1))
    #(Down, c) -> #(Down, #(c.0, c.1 + 1))
    #(Left, c) -> #(Left, #(c.0 - 1, c.1))
  }
}

fn turn(guard: #(Dir, #(Int, Int))) -> #(Dir, #(Int, Int)) {
  case guard {
    #(Up, c) -> #(Right, c)
    #(Right, c) -> #(Down, c)
    #(Down, c) -> #(Left, c)
    #(Left, c) -> #(Up, c)
  }
}

fn walk(guard: #(Dir, #(Int, Int)), obstacles, width, height, visited) {
  use <- bool.guard(
    guard.1.0 > width || guard.1.0 < 1 || guard.1.1 > height || guard.1.1 < 1,
    visited,
  )

  let g2 = step(guard)
  case set.contains(obstacles, g2.1) {
    True -> walk(turn(guard), obstacles, width, height, visited)
    False -> walk(g2, obstacles, width, height, set.insert(visited, guard.1))
  }
}

fn walk2(
  guard: #(Dir, #(Int, Int)),
  obstacles,
  width: Int,
  height: Int,
  visited: Int,
) -> Bool {
  use <- bool.guard(visited > width * height - set.size(obstacles), False)
  use <- bool.guard(
    guard.1.0 > width || guard.1.0 < 1 || guard.1.1 > height || guard.1.1 < 1,
    True,
  )

  let g2 = step(guard)
  case set.contains(obstacles, g2.1) {
    True -> walk2(turn(guard), obstacles, width, height, visited)
    False -> walk2(g2, obstacles, width, height, visited + 1)
  }
}

fn grid_to_coordinates(grid: List(List(String))) -> List(#(String, #(Int, Int))) {
  grid
  |> list.zip(list.range(1, list.length(grid)))
  |> list.map(fn(x) {
    let coordinates =
      list.zip(
        list.range(1, list.length(x.0)),
        list.repeat(x.1, list.length(x.0)),
      )
    list.zip(x.0, coordinates)
  })
  |> list.flatten
  |> list.filter(fn(x) { x.0 != "." })
}

pub fn solve(input: String) {
  #(part1(input), part2(input))
}

pub fn part1(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width = list.first(grid) |> result.unwrap([]) |> list.length

  let assert #([guard], obstacles) =
    grid
    |> grid_to_coordinates
    |> list.partition(fn(x) { x.0 == "^" })

  let obstacles =
    obstacles
    |> list.map(fn(x) { x.1 })
    |> set.from_list
  let guard = #(Up, guard.1)

  walk(guard, obstacles, width, height, set.new())
  |> set.size
}

pub fn part2(input: String) {
  let grid =
    input
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  let height = list.length(grid)
  let width = list.first(grid) |> result.unwrap([]) |> list.length

  let assert #([guard], obstacles) =
    grid
    |> grid_to_coordinates
    |> list.partition(fn(x) { x.0 == "^" })

  let obstacles =
    obstacles
    |> list.map(fn(x) { x.1 })
    |> set.from_list
  let guard = #(Up, guard.1)

  walk(guard, obstacles, width, height, set.new())
  |> set.filter(fn(x) { x != guard.1 })
  |> set.filter(fn(x) {
    !walk2(guard, set.insert(obstacles, x), width, height, 0)
  })
  |> set.size
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day6.txt")
  io.debug(part1(input))
  io.debug(part2(input))
}

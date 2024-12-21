import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

fn row2(key) {
  case key {
    "^" | "A" -> 1
    "<" | "v" | ">" -> 2
    _ -> panic
  }
}

fn col2(key) {
  case key {
    "<" -> 1
    "^" | "v" -> 2
    "A" | ">" -> 3
    _ -> panic
  }
}

fn move_iter2(from, to, pattern) {
  use <- bool.lazy_guard(from == #(1, 1), fn() { panic })
  use <- bool.guard(from == to, pattern <> "A")
  case from, to {
    #(_, f), #(_, t) if f < t ->
      move_iter2(lib.tuple_add(from, #(0, 1)), to, pattern <> ">")
    #(f, _), #(t, _) if f < t ->
      move_iter2(lib.tuple_add(from, #(1, 0)), to, pattern <> "v")
    #(_, f), #(_, t) if f > t ->
      move_iter2(lib.tuple_add(from, #(0, -1)), to, pattern <> "<")
    #(f, _), #(t, _) if f > t ->
      move_iter2(lib.tuple_add(from, #(-1, 0)), to, pattern <> "^")

    _, _ -> panic
  }
}

fn move2(from, to) {
  let from = #(row2(from), col2(from))
  let to = #(row2(to), col2(to))
  let l = move_iter2(from, to, "")
  l
}

fn row(key) {
  case key {
    "7" | "8" | "9" -> 1
    "4" | "5" | "6" -> 2
    "1" | "2" | "3" -> 3
    "0" | "A" -> 4
    _ -> panic
  }
}

fn col(key) {
  case key {
    "7" | "4" | "1" -> 1
    "8" | "5" | "2" | "0" -> 2
    "9" | "6" | "3" | "A" -> 3
    _ -> panic
  }
}

fn move_iter(from, to, pattern) {
  use <- bool.lazy_guard(from == #(4, 1), fn() { panic })
  use <- bool.guard(from == to, pattern <> "")
  case from, to {
    #(_, f), #(_, t) if f < t ->
      move_iter(lib.tuple_add(from, #(0, 1)), to, pattern <> ">")
    #(f, _), #(t, _) if f > t ->
      move_iter(lib.tuple_add(from, #(-1, 0)), to, pattern <> "^")
    #(f, _), #(t, _) if f < t ->
      move_iter(lib.tuple_add(from, #(1, 0)), to, pattern <> "v")
    #(_, f), #(_, t) if f > t ->
      move_iter(lib.tuple_add(from, #(0, -1)), to, pattern <> "<")

    _, _ -> panic
  }
}

fn is_valid(from, steps) {
  use <- bool.guard(from == #(4, 1), False)
  case steps {
    "" -> True
    "<" <> rest -> is_valid(lib.tuple_add(from, #(0, -1)), rest)
    "^" <> rest -> is_valid(lib.tuple_add(from, #(-1, 0)), rest)
    ">" <> rest -> is_valid(lib.tuple_add(from, #(0, 1)), rest)
    "v" <> rest -> is_valid(lib.tuple_add(from, #(1, 0)), rest)
    _ -> panic
  }
}

fn move(from, to) {
  let from = #(row(from), col(from))
  let to = #(row(to), col(to))
  move_iter(from, to, "")
}

fn list_min(l: List(#(Int, String))) {
  list.fold(l, #(100, ""), fn(min, x) {
    use <- bool.guard(min.0 < x.0, min)
    x
  })
}

fn press(from, to) {
  let from2 = #(row(from), col(from))
  let possible =
    move(from, to)
    |> string.to_graphemes
    |> list.permutations
    |> list.map(string.join(_, ""))
    |> list.unique
    |> list.filter(is_valid(from2, _))
    |> list.map(fn(x) { x <> "A" })
  possible
  |> list.map(string.to_graphemes)
  |> list.map(list.prepend(_, "A"))
  |> list.map(list_to_dir2)
  |> list.map(list.prepend(_, "A"))
  |> list.map(list_to_dir2)
  |> list.sort(fn(a, b) { int.compare(list.length(a), list.length(b)) })
  |> list.first
  |> lib.unwrap
  |> string.join("")
}

fn list_to_dir(l: List(String)) {
  l
  |> list.window_by_2
  |> list.map(fn(x) { press(x.0, x.1) })
  |> string.join("")
  |> string.to_graphemes
}

fn list_to_dir2(l: List(String)) {
  l
  |> list.window_by_2
  |> list.map(fn(x) { move2(x.0, x.1) })
  |> string.join("")
  |> string.to_graphemes
}

pub fn solve(input: String) {
  let n = input |> string.split("\n")
  let numbers = n |> list.map(string.to_graphemes)
  list.map(numbers, list.prepend(_, "A"))
  |> list.map(list_to_dir)
  |> list.map(list.length)
  |> list.zip(
    list.map(n, fn(x) { string.drop_end(x, 1) |> int.parse |> lib.unwrap }),
  )
  |> list.map(fn(x) { x.0 * x.1 })
  |> int.sum
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day21.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

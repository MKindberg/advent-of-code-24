import gleam/bool
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/string
import lib
import simplifile

fn tuple_map6(t: #(a, a, a, a, a, a), f: fn(a) -> b) {
  #(f(t.0), f(t.1), f(t.2), f(t.3), f(t.4), f(t.5))
}

fn press(params) -> #(Int, Int) {
  let #(ax, bx, ay, by, x, y) = params |> tuple_map6(int.to_float)
  let b = { y -. x *. ay /. ax } /. { by -. bx *. ay /. ax }
  let a = { x -. b *. bx } /. ax

  let #(ax, bx, ay, by, x, y) = params

  let a = float.round(a)
  let b = float.round(b)

  use <- bool.guard(a < 0 || b < 0, #(0, 0))
  use <- bool.guard(a * ax + b * bx != x, #(0, 0))
  use <- bool.guard(a * ay + b * by != y, #(0, 0))

  #(a, b)
}

fn parse(in: String) {
  let assert [la, lb, lp] = string.split(in, "\n")

  let assert Ok(#(ax, ay)) = string.split_once(la, ", Y+")
  let assert Ok(#(bx, by)) = string.split_once(lb, ", Y+")
  let assert Ok(#(x, y)) = string.split_once(lp, ", Y=")
  let ax = ax |> string.drop_start(12)
  let bx = bx |> string.drop_start(12)
  let x = x |> string.drop_start(9)

  let ax = ax |> int.parse |> lib.unwrap
  let bx = bx |> int.parse |> lib.unwrap
  let ay = ay |> int.parse |> lib.unwrap
  let by = by |> int.parse |> lib.unwrap
  let x = x |> int.parse |> lib.unwrap
  let y = y |> int.parse |> lib.unwrap

  #(ax, bx, ay, by, x, y)
}

fn inc_x_y(p: #(Int, Int, Int, Int, Int, Int)) {
  #(p.0, p.1, p.2, p.3, p.4 + 10_000_000_000_000, p.5 + 10_000_000_000_000)
}

pub fn solve(input: String) {
  let params =
    input
    |> string.split("\n\n")
    |> list.map(parse)

  let p1 =
    params
    |> list.map(press)
    |> list.filter(fn(x) { x.0 <= 100 && x.1 <= 100 })
    |> list.map(fn(x) { x.0 * 3 + x.1 })
    |> int.sum

  let params = list.map(params, inc_x_y)

  let p2 =
    params
    |> list.map(press)
    |> list.map(fn(x) { x.0 * 3 + x.1 })
    |> int.sum

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day13.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/string
import lib
import simplifile

fn mix(a, b) {
  int.bitwise_exclusive_or(a, b)
}

fn prune(a) {
  int.modulo(a, 16_777_216) |> lib.unwrap
}

fn next(n) {
  let n =
    n
    |> mix(n * 64)
    |> prune
  let n =
    n
    |> mix(n / 32)
  n
  |> mix(n * 2048)
  |> prune
}

fn loop(n, f, arg) {
  use <- bool.lazy_guard(n <= 1, fn() { f(arg) })
  loop(n - 1, f, f(arg))
}

fn gen_2000(start) {
  loop(2000, next, start)
}

fn first_2k_prices(start) {
  list.repeat(0, 2000)
  |> list.fold([start], fn(l, _) {
    let assert [first, ..] = l
    l |> list.prepend(next(first))
  })
  |> list.reverse
  |> list.map(fn(x) { int.modulo(x, 10) |> lib.unwrap })
}

fn diffs(l) {
  l
  |> list.drop(1)
  |> list.map2(l, int.subtract)
}

fn spawn_task(i) {
  task.async(fn() { initial_to_dict(i) })
}

fn initial_to_dict(i) {
  let prices = i |> first_2k_prices
  let price_diffs = diffs(prices)
  let seqs = price_diffs |> list.window(4)
  let stops =
    prices
    |> list.drop(4)
    |> list.zip(seqs, _)
    |> list.reverse
  stops |> dict.from_list
}

pub fn solve(input: String) {
  let initials =
    input |> string.split("\n") |> list.map(int.parse) |> result.values
  let p1 = initials |> list.map(gen_2000) |> int.sum
  let p2 =
    initials
    |> list.map(spawn_task)
    |> list.map(task.await_forever)
    |> list.fold(dict.new(), fn(acc, x) {
      dict.combine(acc, x, fn(a, b) { a + b })
    })
    |> dict.fold(0, fn(acc, _, v) { int.max(acc, v) })
  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day22.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

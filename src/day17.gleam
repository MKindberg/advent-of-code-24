import gleam/bool
import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import lib
import simplifile

fn combo(i, registers: #(Int, Int, Int)) {
  case i {
    0 | 1 | 2 | 3 -> i
    4 -> registers.0
    5 -> registers.1
    6 -> registers.2
    _ -> panic
  }
}

fn pow(a, b) {
  list.repeat(a, b) |> int.product
}

fn run(program, registers, ip, out, cache) {
  let key = #(registers, ip)
  use <- bool.lazy_guard(dict.has_key(cache, key), fn() {
    #(
      list.append(out |> list.reverse, dict.get(cache, key) |> lib.unwrap),
      cache,
    )
  })
  let i = dict.get(program, ip)
  use <- bool.lazy_guard(result.is_error(i), fn() {
    #(out |> list.reverse, cache)
  })
  let #(a, b, c) = registers
  let i = lib.unwrap(i)
  let op = dict.get(program, ip + 1) |> result.unwrap(0)
  let #(registers, next, out) = case i {
    0 -> {
      let a = a / pow(2, combo(op, registers))
      #(#(a, b, c), ip + 2, out)
    }
    1 -> {
      let b = int.bitwise_exclusive_or(b, op)
      #(#(a, b, c), ip + 2, out)
    }
    2 -> {
      let b = int.modulo(combo(op, registers), 8) |> lib.unwrap
      #(#(a, b, c), ip + 2, out)
    }
    3 -> {
      let next = bool.guard(a == 0, ip + 2, fn() { op })
      #(#(a, b, c), next, out)
    }
    4 -> {
      let b = int.bitwise_exclusive_or(b, c)
      #(#(a, b, c), ip + 2, out)
    }
    5 -> {
      let o = int.modulo(combo(op, registers), 8) |> lib.unwrap
      let out = [o, ..out]
      #(#(a, b, c), ip + 2, out)
    }
    6 -> {
      let b = a / pow(2, combo(op, registers))
      #(#(a, b, c), ip + 2, out)
    }
    7 -> {
      let c = a / pow(2, combo(op, registers))
      #(#(a, b, c), ip + 2, out)
    }

    _ -> panic
  }
  let #(out, cache) = run(program, registers, next, out, cache)
  let cache = dict.insert(cache, #(registers, next), out)
  #(out, cache)
}

fn copy(program, prog, i, cache) {
  let #(p, cache) = run(program, #(i, 0, 0), 0, [], cache)
  let cache = dict.insert(cache, #(#(i, 0, 0), 0), p)
  use <- bool.guard(p == prog, i)
  copy(program, prog, i + 1, cache)
}

pub fn solve(input: String) {
  let assert Ok(#(registers, program)) = string.split_once(input, "\n\n")
  let assert [a, b, c] =
    registers
    |> string.split("\n")
    |> list.map(string.drop_start(_, string.length("Register _: ")))
    |> list.map(int.parse)
    |> result.values

  let prog =
    program
    |> string.drop_start(string.length("Program: "))
    |> string.split(",")
    |> list.map(int.parse)
    |> list.map(lib.unwrap)
  let program =
    list.range(0, list.length(prog) - 1)
    |> list.zip(prog)
    |> dict.from_list

  let p1 =
    run(program, #(a, b, c), 0, [], dict.new())
    |> fn(x) { x.0 }
    |> list.map(int.to_string)
    |> string.join(",")

  let p2 = 0
  let p2 = copy(program, prog, 10000, dict.new())

  #(p1, p2)
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day17.txt")
  let input = string.trim(input)
  let input =
    "Register A: 2024
Register B: 0
Register C: 0

Program: 0,3,5,4,3,0
  "
    |> string.trim()
  io.debug(solve(input))
}

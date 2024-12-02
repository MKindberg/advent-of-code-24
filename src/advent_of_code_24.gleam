import gleam/io
import gleam/string

import simplifile

import day1
import day2

fn run_day(n: String, part1, part2) {
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    io.println("Day " <> n <> ":")
    io.debug(part1(input |> string.trim))
    io.debug(part2(input |> string.trim))
}

pub fn main() {
    run_day("1", day1.part1, day1.part2)
    run_day("2", day2.part1, day2.part2)
}

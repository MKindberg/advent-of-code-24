import gleam/io
import gleam/string

import simplifile

import day1
import day2
import day3
import day4
import day5
import day6
import day7

fn run_day(n: String, part1, part2) {
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    io.println("Day " <> n <> ":")
    io.debug(part1(input |> string.trim))
    io.debug(part2(input |> string.trim))
}

pub fn main() {
    run_day("1", day1.part1, day1.part2)
    run_day("2", day2.part1, day2.part2)
    run_day("3", day3.part1, day3.part2)
    run_day("4", day4.part1, day4.part2)
    run_day("5", day5.part1, day5.part2)
    run_day("6", day6.part1, day6.part2)
    run_day("7", day7.part1, day7.part2)
}

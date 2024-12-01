import gleam/io

import simplifile

import day1

fn run_day(n: String, part1, part2) {
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    io.println("Day " <> n <> ":")
    io.debug(part1(input))
    io.debug(part2(input))
}

pub fn main() {
    run_day("1", day1.part1, day1.part2)
}

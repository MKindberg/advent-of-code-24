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
import day8
import day9
import day10
import day11
import day12
import day13
import day14

fn run_day(n: String, solve) {
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    let input = string.trim(input)
    io.println("Day " <> n <> ":")
    io.debug(solve(input))
}

pub fn main() {
    run_day("1", day1.solve)
    run_day("2", day2.solve)
    run_day("3", day3.solve)
    run_day("4", day4.solve)
    run_day("5", day5.solve)
    run_day("6", day6.solve)
    run_day("7", day7.solve)
    run_day("8", day8.solve)
    run_day("9", day9.solve)
    run_day("10", day10.solve)
    run_day("11", day11.solve)
    run_day("12", day12.solve)
    run_day("13", day13.solve)
    run_day("14", day14.solve)
}

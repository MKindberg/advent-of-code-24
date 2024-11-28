import gleam/io

import simplifile

fn run_day(n: String, part1, part2) {
  let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
  io.println("Day " <> n <> ":")
  io.print(n <> ":")
  io.debug(part1(input))
  io.print(n <> ":")
  io.debug(part2(input))
}

pub fn main() {
    io.print("")
}

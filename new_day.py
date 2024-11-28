#!/usr/bin/python3

import os
import subprocess

template = """\
import gleam/io
import simplifile

pub fn part1(input: String) {{

}}

pub fn part2(input: String) {{

}}

pub fn main() {{
    let assert Ok(input) = simplifile.read("input/day{day}.txt")
    io.debug(part1(input))
    // io.debug(part2(input))
}}
"""

test_template = """\
import gleeunit
import day{d}

pub fn main() {{
  gleeunit.main()
}}

// pub fn day{d}_test() {{
//   day{d}.part1("")
// }}\
"""

os.makedirs("src", exist_ok=True)
os.makedirs("test", exist_ok=True)

days = [0] + [int(f.split('.')[0][3:]) for f in os.listdir('src') if f[0:3] == "day" and f[-6:] == ".gleam"]
new_day = max(days) + 1

subprocess.run(["./download", str(new_day)])

with open("src/day{}.gleam".format(new_day), "w") as f:
    f.write(template.format(day = new_day))

with open("test/day{}_test.gleam".format(new_day), "w") as f:
    f.write(test_template.format(d = new_day))

print("Created src/day{}.gleam".format(new_day))

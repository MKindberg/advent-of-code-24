#!/usr/bin/python3

import os
import subprocess

template = """\
import gleam/io
import gleam/string
import simplifile

pub fn solve(input: String) {{

}}

pub fn main() {{
    let assert Ok(input) = simplifile.read("input/day{day}.txt")
    let input = string.trim(input)
    io.debug(solve(input))
}}
"""

os.makedirs("src", exist_ok=True)

days = [0] + [int(f.split('.')[0][3:]) for f in os.listdir('src') if f[0:3] == "day" and f[-6:] == ".gleam"]
new_day = max(days) + 1

subprocess.run(["./download", str(new_day)])

with open("src/day{}.gleam".format(new_day), "w") as f:
    f.write(template.format(day = new_day))

print("Created src/day{}.gleam".format(new_day))

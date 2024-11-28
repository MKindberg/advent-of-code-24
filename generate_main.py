#!/usr/bin/python3

import os

template = """\
import gleam/io

import simplifile

{imports}

fn run_day(n: String, part1, part2) {{
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    io.println("Day " <> n <> ":")
    io.print(n <> ":")
    io.debug(part1(input))
    io.print(n <> ":")
    io.debug(part2(input))
}}

pub fn main() {{
{code}
}}
"""
days = [int(f.split('.')[0][3:]) for f in os.listdir('src') if f[0:3] == "day" and f[-6:] == ".gleam"]
days = sorted(days)
imports = [f"import day{str(d)}" for d in days]

code = [f'    run_day("{str(d)}", day{str(d)}.part1, day{str(d)}.part2)' for d in days]

f = open("src/advent_of_code_24.gleam", "w")
f.write(template.format(imports = '\n'.join(imports), code = '\n'.join(code)))
f.close()

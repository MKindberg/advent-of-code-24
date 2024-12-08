#!/usr/bin/python3

import os

template = """\
import gleam/io
import gleam/string

import simplifile

{imports}

fn run_day(n: String, solve) {{
    let assert Ok(input) = simplifile.read("input/day" <> n <> ".txt")
    let input = string.trim(input)
    io.println("Day " <> n <> ":")
    io.debug(solve(input))
}}

pub fn main() {{
{code}
}}
"""
days = [int(f.split('.')[0][3:]) for f in os.listdir('src') if f[0:3] == "day" and f[-6:] == ".gleam"]
days = sorted(days)
imports = [f"import day{str(d)}" for d in days]

code = [f'    run_day("{str(d)}", day{str(d)}.solve)' for d in days]

f = open("src/advent_of_code_24.gleam", "w")
f.write(template.format(imports = '\n'.join(imports), code = '\n'.join(code)))
f.close()

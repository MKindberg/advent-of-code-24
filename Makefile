DAYS := $(notdir $(basename $(wildcard src/day*.gleam)))

.PHONY: new run all
run: src/advent_of_code_24.gleam
	gleam run

all: $(DAYS)
	echo $(DAYS)

day% : src/day%.gleam
	gleam run -m $@

%:
	gleam run -m day$@

src/advent_of_code_24.gleam: generate_main.py
	./generate_main.py

new:
	./new_day.py

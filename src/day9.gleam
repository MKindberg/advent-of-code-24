import gleam/bool
import gleam/deque
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import simplifile

type Space {
  File(name: Int, size: Int)
  Free(size: Int)
}

fn checksum(files, disk) {
  let movable = files |> deque.from_list
  checksum_iter(disk, movable, 0, 0)
}

fn calc(idx, size, name) {
  list.range(idx, idx + size - 1)
  |> list.map(fn(x) { x * name })
  |> int.sum
}

fn checksum_iter(disk, movable, idx, sum) {
  use <- bool.guard(deque.is_empty(movable), sum)
  case disk {
    [] -> sum
    [File(_, _), ..rest] -> {
      let assert Ok(#(File(name, size), m)) = deque.pop_front(movable)
      checksum_iter(rest, m, idx + size, sum + calc(idx, size, name))
    }
    [Free(0), ..rest] -> checksum_iter(rest, movable, idx, sum)
    [Free(f), ..rest] -> {
      let assert Ok(#(File(name, size), m)) = deque.pop_back(movable)
      case int.compare(f, size) {
        order.Gt ->
          checksum_iter(
            [Free(f - size), ..rest],
            m,
            idx + size,
            sum + calc(idx, size, name),
          )
        order.Lt ->
          checksum_iter(
            rest,
            deque.push_back(m, File(name, size - f)),
            idx + f,
            sum + calc(idx, f, name),
          )
        order.Eq ->
          checksum_iter(rest, m, idx + size, sum + calc(idx, size, name))
      }
    }
  }
}

fn insert(disk: List(Space), file: Space) -> List(Space) {
  let assert File(name, size) = file
  case disk {
    [Free(a), Free(b), ..rest] -> insert([Free(a + b), ..rest], file)
    [File(n, s), ..rest] if n == name && s == size -> [file, ..rest]
    [Free(s), ..rest] if s < size -> [Free(s), ..insert(rest, file)]
    [Free(s), ..rest] if s == size -> [
      file,
      ..list.map(rest, fn(x) {
        case x == file {
          True -> Free(size)
          False -> x
        }
      })
    ]
    [Free(s), ..rest] -> [
      file,
      Free(s - size),
      ..list.map(rest, fn(x) {
        case x == file {
          True -> Free(size)
          False -> x
        }
      })
    ]
    [f, ..rest] -> [f, ..insert(rest, file)]
    [] -> []
  }
}

fn part2(files, disk) {
  {
    files
    |> list.fold_right(disk, fn(acc, f) { insert(acc, f) })
    |> list.fold(#(0, 0), fn(acc, x) {
      case x {
        Free(s) -> #(acc.0 + s, acc.1)
        File(n, s) -> #(acc.0 + s, acc.1 + calc(acc.0, s, n))
      }
    })
  }.1
}

pub fn solve(input: String) {
  let #(files, free) =
    input
    |> string.to_graphemes
    |> list.map(int.parse)
    |> result.values
    |> list.append([0])
    |> list.sized_chunk(2)
    |> list.index_map(fn(f, name) {
      list.length(f)
      let assert [size, free] = f
      #(#(name, size), free)
    })
    |> list.unzip

  let free = list.map(free, Free)
  let files = list.map(files, fn(f) { File(f.0, f.1) })
  let disk = list.interleave([files, free])

  #(checksum(files, disk), part2(files, disk))
}

pub fn main() {
  let assert Ok(input) = simplifile.read("input/day9.txt")
  let input = string.trim(input)
  io.debug(solve(input))
}

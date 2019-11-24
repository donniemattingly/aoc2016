defmodule Day18 do
  def real_input do
    '.^^^^^.^^^..^^^^^...^.^..^^^.^^....^.^...^^^...^^^^..^...^...^^.^.^.......^..^^...^.^.^^..^^^^^...^.'
  end

  def sample_input do
    '.^^.^.^^^^'
  end

  def sample_input2 do
    """
    """
  end

  def sample do
    sample_input
    |> parse_input1
    |> solve(10)
  end

  def part1 do
    real_input1
    |> parse_input1
    |> solve(40)
  end


  def sample2 do
    sample_input2
    |> parse_input2
    |> solve2
  end

  def part2 do
    real_input2
    |> parse_input2
    |> solve2
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input), do: solve(input, 40)
  def solve2(input), do: solve(input, 400000)

  def parse_input(input) do
    input
  end

  def solve(input, size) do
    input
    |> get_room(size)
    |> count_safe
  end

  def render_room(room) do
    room
    |> Enum.reverse
    |> Enum.join("\n")
    |> IO.puts
  end

  def count_safe(room) do
    room
    |> List.flatten
    |> Enum.count(fn tile -> tile == ?. end)
  end

  def get_room(start_line, num_rows) do
    do_get_room([start_line], num_rows)
  end

  defp do_get_room(rows, 1), do: rows

  defp do_get_room([cur_row | rest] = rows, count) do
    do_get_room([next_line(cur_row) | rows], count - 1)
  end

  def next_line(line) do
    '.'++line++'.'
    |> Enum.chunk_every(3, 1)
    |> Enum.filter(fn x -> length(x) == 3 end)
    |> Enum.map(&get_next_tile_from_chunk/1)
  end

  def get_next_tile_from_chunk(chunk) do
    case chunk |> chunk_to_tiles |> is_trap? do
      true -> ?^
      false -> ?.
    end
  end

  def chunk_to_tiles(chunk) do
    chunk
    |> Enum.map(fn x ->
      case x do
        ?. -> false
        ?^ -> true
      end
    end)
    |> List.to_tuple
  end

  def is_trap?(tiles) do
    case tiles do
      {true, true, false} -> true
      {false, true, true} -> true
      {true, false, false} -> true
      {false, false, true} -> true
      _ -> false
    end
  end

end

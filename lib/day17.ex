defmodule Day17 do
  def real_input do
    "vkjiggvb"
  end

  def sample_input do
    "ihgpwlah"
  end

  def sample_input2 do
    "ihgpwlah"
  end

  def sample do
    sample_input
    |> parse_input1
    |> solve1
  end

  def part1 do
    real_input1
    |> parse_input1
    |> solve1
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

  def solve1(input), do: solve(input) |> hd
  def solve2(input), do: solve(input) |> Enum.take(-1)

  def parse_input(input) do
    input
  end


  @doc """
  This one is interesting from my BFS perspective, because adding the path element causes the
  algorithm to explore every valid path to that space, then I need to filter from there. This
  was convenient for part 2 when
  """
  def solve(input) do
    passcode = input
    {q, m} = GraphUtils.bfs({{0, 0}, ''}, fn x -> neighbors_for_search(x, passcode, {3, 3}) end)
    get_path_length_to_end_states(m)
  end

  def get_path_length_to_end_states(m) do
    Map.keys(m)
    |> Enum.filter(fn {x, _} -> x == {3, 3} end)
    |> Enum.map(fn x -> {x, GraphUtils.get_path(m, x)} end)
    |> Enum.map(fn {x, path} -> {x, length(path)} end)
    |> Enum.sort(fn({_, a}, {_, b}) -> a <= b end)
  end

  def neighbors_for_search({coords, path} = node, passcode, goal) do
    cond do
      coords == goal -> []
      true -> neighbors(node, passcode)
    end
  end

  @doc """
  Here the node is a tuple of the current coord + the path to get there,
  since that path is used to determine the other paths.
  """
  def neighbors({{x, y} = coords, path}, passcode) do
    if coords == {3, 3} do
      IO.inspect({coords, path})
    end
    {u, d, l, r} = hash(passcode, path) |> get_doors_from_hash
    [
      {u, up(coords), path ++ 'U'},
      {d, down(coords), path ++ 'D'},
      {l, left(coords), path ++ 'L'},
      {r, right(coords), path ++ 'R'}
    ]
    |> Enum.filter(fn({x, coords, _ }) -> x and is_valid_coord?(coords) end)
    |> Enum.map(fn({_, a, b}) -> {a, b} end)
  end

  def hash(passcode, path) do
    Utils.md5("#{passcode}#{path}")
  end

  def up({x, y}), do: {x, y - 1}
  def down({x, y}), do: {x, y + 1}
  def left({x, y}), do: {x - 1, y}
  def right({x, y}), do: {x + 1, y}

  def is_valid_coord?({x, y}) do
    (x >= 0 and y >=0) and (x < 4 and y < 4)
  end

  def get_doors_from_hash(hash) do
    hash |> String.to_charlist |> Enum.take(4) |> Enum.map(&is_open?/1) |> List.to_tuple
  end

  def is_open?(char) do
    ?b <= char and char <= ?f
  end

end

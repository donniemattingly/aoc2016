require Integer

defmodule Day13 do
  def real_input do
    {1358, {39, 31}}
  end

  def sample_input do
    {10, {4,7}}
  end

  def sample_input2 do
    """
    """
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

  def solve1(input), do: solve(input)

  def parse_input(input) do
    input
  end

  def solve(input) do
    {num, goal} = input
    {q, m} = GraphUtils.bfs({1, 1}, fn x -> neighbors_for_search(x, num, goal) end)

    GraphUtils.get_path(m, goal)
    |> length

    m
  end

  def solve2(input) do
    {num, goal} = input
    {q, m} = GraphUtils.bfs({1, 1}, fn x -> neighbors_for_search(x, num, goal) end)

    # one extra because the original node is included
    Map.keys(m) |> Enum.filter(fn v -> length(GraphUtils.get_path(m, v)) <= 51 end) |> length
  end

  def neighbors_for_search(node, num, goal) do
    cond do
      node == goal -> []
      true -> get_neighbors(node, num)
    end
  end

  def get_neighbors({x, y}, num) do
    [
      {x-1, y},
      {x+1, y},
      {x, y-1},
      {x, y+1}
    ]
    |> Enum.filter(fn {x, y} -> x >= 0 and y >= 0 end)
    |> Enum.filter(fn x -> is_open?(x, num) end)
  end

  def is_open?({y, x}, num) do
    (x*x + 3*x + 2*x*y + y + y*y) + num
    |> Integer.to_string(2)
    |> String.graphemes
    |> Enum.count(& &1 == "1")
    |> Integer.is_even
  end

  def plot_map({dx, dy}, num) do
    0..dx
    |> Enum.map(fn x ->
    0..dy
    |> Enum.map(fn y ->
      if is_open?({x, y}, num), do: ".", else: "#"
    end)
    end)
  end

  def render_map(map) do
    map
    |> Enum.map(fn x -> Enum.join(x, "") end)
    |> Enum.join("\n")
  end

end

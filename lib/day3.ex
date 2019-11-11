defmodule Day3 do

  def real_input do
    Utils.get_input(3, 1)
  end

  def sample_input do
    """
    5 10 25
    """
  end

  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(fn x -> x != "" end)
    |> Enum.map(fn(x) ->
      x
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
      |> List.to_tuple
    end)
  end

  def get_columns(vals) do
    [
      [Enum.at(vals, 0), Enum.at(vals, 3), Enum.at(vals, 6)],
      [Enum.at(vals, 1), Enum.at(vals, 4), Enum.at(vals, 7)],
      [Enum.at(vals, 2), Enum.at(vals, 5), Enum.at(vals, 8)]
    ]
  end

  def parse_input2(input) do
    input
    |> String.split
    |> Enum.chunk_every(9)
    |> Enum.flat_map(&get_columns/1)
    |> Enum.map(fn(x) ->
      x
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
      |> List.to_tuple
    end)
  end

  def part1 do
    real_input
    |> parse_input
    |> solve
  end

  def part2 do
    real_input
    |> parse_input2
    |> solve
  end

  def solve(parsed_input) do
    parsed_input
    |> Enum.count(fn({a, b, c}) -> a + b > c end)
  end

end
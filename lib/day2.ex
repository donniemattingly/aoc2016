defmodule Day2 do
  @moduledoc

  def real_input do
    Utils.get_input(2, 1)
  end

  def sample_input do
    """
    ULL
    RRDDD
    LURDL
    UUUUD
    """
  end

  def string_to_direction(str) do
    str
    |> String.downcase
    |> String.to_atom
  end

  def parse_line_to_directions(line) do
    line
    |> String.graphemes
    |> Enum.map(&string_to_direction(&1))
  end

  def parse_input(input) do
    input
    |> String.split()
    |> Enum.map(&parse_line_to_directions(&1))
  end

  def sample() do
    sample_input
    |> parse_input
    |> solve_part_one
    |> elem(1)
  end

  def sample2() do
    sample_input
    |> parse_input
    |> solve_part_two
    |> elem(1)
  end

  def part1() do
    real_input
    |> parse_input
    |> solve_part_one
    |> elem(1)
  end

  def part2() do
    real_input
    |> parse_input
    |> solve_part_two
    |> elem(1)
  end

  def get_grid do
    for n <- 0..2, m <- 0..2 do
    {{n, m}, 3*m + n + 1}
    end |> Enum.into(%{})
  end

  def get_part2_grid do
    %{
      {2, 0} => "1",
      {1, 1} => "2",
      {2, 1} => "3",
      {3, 1} => "4",
      {0, 2} => "5",
      {1, 2} => "6",
      {2, 2} => "7",
      {3, 2} => "8",
      {4, 2} => "9",
      {1, 3} => "A",
      {2, 3} => "B",
      {3, 3} => "C",
      {2, 4} => "D"
    }
  end

  def solve_part_one(parsed_input) do
    solve(parsed_input, get_grid(), {1, 1})
  end

  def solve_part_two(parsed_input) do
    solve(parsed_input, get_part2_grid(), {0, 2})
  end

  def solve(parsed_input, grid, initial) do
    Enum.reduce(parsed_input, {initial, ""}, fn(moves, {pos, code})->
      {new_pos, digit} = get_digit(pos, grid, moves)
      {new_pos, "#{code}#{digit}"}
    end)
  end

  def translate({x, y}, :u) do
    {x, y - 1}
  end

  def translate({x, y}, :r) do
    {x + 1, y}
  end

  def translate({x, y}, :d) do
    {x, y + 1}
  end

  def translate({x, y}, :l) do
    {x - 1, y}
  end

  def move(pos, grid, direction) do
    translated = translate(pos, direction)
    case Map.get(grid, translated) do
      nil -> pos
      _ -> translated
    end
  end

  def get_digit(initial_pos, grid, moves) do
    last = moves |> Enum.reduce(initial_pos, fn(x, acc) ->
      move(acc, grid, x)
    end)
    {last, Map.get(grid, last)}
  end


end
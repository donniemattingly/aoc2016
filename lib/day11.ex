defmodule Day11 do
  def real_input do
    Utils.get_input(11, 1)
  end

  def sample_input do
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
    """
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
  def solve2(input), do: solve(input)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> Enum.with_index
    |> Enum.flat_map(fn {x, i} ->
      Enum.map(x, &({i, elem(&1, 0), elem(&1, 1)}))
    end)

  end

  def parse_line(line) do
    List.flatten([get_microchips(line), get_generators(line)])
  end

  def get_component(line, regex, label) do
    Regex.scan(regex, line, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(&String.slice(&1, 0..2))
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(& {label, &1})
  end

  def get_microchips(line) do
    get_component(line, ~r/([a-z]+)\-compatible microchip/, :m)
  end

  def get_generators(line) do
    get_component(line, ~r/([a-z]+) generator/, :g)
  end

  def valid_state?(state) do

  end

  def solve(input) do
    input
  end

end

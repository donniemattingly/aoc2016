defmodule Day16 do
  require Integer

  def real_input do
    "10001001100000001"
  end

  def sample_input do
    """
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

  def solve1(input), do: solve(input, 272)
  def solve2(input), do: solve(input, 35651584)

  def parse_input(input) do
    input
  end

  def solve(input, size) do
    input
    |> String.to_charlist
    |> fill_disk(size)
    |> checksum
  end

  def fill_disk(input, size) do
    case length(input) >= size do
      true -> Enum.take(input, size)
      false -> input |> stretch |> fill_disk(size)
    end
  end

  def invert(?0), do: ?1
  def invert(?1), do: ?0

  def stretch(input) do
    input ++ '0' ++ do_stretch(input)
  end

  defp do_stretch(input) do
    input
    |> Enum.reverse
    |> Enum.map(&invert/1)
  end

  def pair_same?([a, b]) do
    a == b
  end

  def collapse_pair(pair) do
    case pair_same?(pair) do
      true -> '1'
      false -> '0'
    end
  end

  def checksum(input) when Integer.is_even(length(input)) do
    input
    |> Enum.chunk_every(2)
    |> Enum.flat_map(&collapse_pair/1)
    |> checksum
  end

  def checksum(input) when Integer.is_odd(length(input)) do
    input
  end

end

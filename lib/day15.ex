defmodule Day15 do
  def real_input do
    Utils.get_input(15, 1)
  end

  def sample_input do
    """
    Disc #1 has 5 positions; at time=0, it is at position 4.
    Disc #2 has 2 positions; at time=0, it is at position 1.
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
  def parse_input2(input) do
    parsed = parse_input(input)
    {num, _, _} = Enum.take(parsed, -1) |> hd
    parsed ++ [{num + 1, 11, 0}]
  end

  def solve1(input), do: solve(input)
  def solve2(input), do: solve(input)

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_position/1)
  end

  def parse_position(line) do
    Regex.scan(~r/(?<!=)([0-9]+)/, line)
    |> Enum.map(&hd/1)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  @doc"""
  This function calculates the effective position of a disc if the
  ball fell instantaneously through the sculpture. If a disc is at
  position n when the ball falls at time zero, it will have moved
  m positions (where m is the disc's number)
  """
  def position_at_time({disc, num_positions, initial}, time) do
    rem(time + disc + initial, num_positions)
  end

  def find_time_to_drop(discs) do
    Stream.iterate(0, & &1 + 1)
    |> Stream.filter(fn x ->
      discs
      |> Enum.map(&position_at_time(&1, x))
      |> Enum.all?(& &1 == 0)
    end)
    |> Stream.take(1)
    |> Enum.to_list
  end

  def solve(input) do
    input
    |> find_time_to_drop
  end

end

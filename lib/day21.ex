defmodule Day21 do
  def real_input do
    Utils.get_input(21, 1)
  end

  def sample_input do
    """
    swap position 4 with position 0
    swap letter d with letter b
    reverse positions 0 through 4
    rotate left 1 step
    move position 1 to position 4
    move position 3 to position 0
    rotate based on position of letter b
    rotate based on position of letter d
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
  end

  def parse_line(line), do: do_parse_line(line) |> IO.inspect

  def do_parse_line("swap position " <> rest) do
    {x, y} = extract(rest, ~r/(\d+) with position (\d+)/)
    |> flat_map_to_numbers

    {:swap_pos, x, y}
  end

  def do_parse_line("swap letter " <> rest) do
    {x, y} = extract(rest, ~r/([a-z]) with letter ([a-z])/)
    |> flat_map_to_chars

    {:swap_letters, x, y}
  end

  def do_parse_line("rotate left " <> rest) do
  {x} = extract(rest, ~r/(\d+) step[s]*/)
  |> flat_map_to_numbers

  {:rotate_left, x}
  end

  def do_parse_line("rotate right " <> rest) do
    {x} = extract(rest, ~r/(\d+) step[s]*/)
    |> flat_map_to_numbers

    {:rotate_right, x}
  end

  def do_parse_line("rotate based on position of letter " <> rest) do
    {x} = extract(rest, ~r/([a-z])/)
    |> flat_map_to_chars

    {:rotate_based_on_pos, x}
  end

  def do_parse_line("reverse positions " <> rest) do
    {x, y} = extract(rest, ~r/(\d+) through (\d+)/)
    |> flat_map_to_numbers

    {:reverse_pos, x, y}
  end

  def do_parse_line("move position " <> rest) do
    {x, y} = extract(rest, ~r/(\d+) to position (\d+)/)
    |> flat_map_to_numbers

    {:move_pos, x, y}
  end

  def extract(line, regex) do
    Regex.scan(regex, line, capture: :all_but_first)
  end

  def flat_map_to_numbers(input) do
    input |> List.flatten |> Enum.map(&String.to_integer/1) |> List.to_tuple
  end

  def flat_map_to_chars(input) do
    input |> List.flatten |> Enum.map(&String.to_charlist/1) |> Enum.map(&hd/1)|> List.to_tuple
  end

  def solve(input) do
    input
  end

end

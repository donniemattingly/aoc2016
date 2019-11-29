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
    |> solve1('abcde')
  end

  def part1 do
    real_input1
    |> parse_input1
    |> solve1('abcdefgh')
  end


  def sample2 do
    sample_input2
    |> parse_input2
    |> solve2('abcde')
  end

  def part2 do
    real_input2
    |> parse_input2
    |> solve2('fbgdceah')
  end

  def real_input1, do: real_input()
  def real_input2, do: real_input()

  def parse_input1(input), do: parse_input(input)
  def parse_input2(input), do: parse_input(input)

  def solve1(input, starting_string), do: solve(input, starting_string)

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

  @doc"""
  swap position X with position Y means that the letters at
  indexes X and Y (counting from 0) should be swapped.
  """
  def do_op({:swap_pos, x, y}, str) do
    Utils.swap(str, x, y)
  end

  @doc"""
  swap letter X with letter Y means that the letters X and Y should be swapped
  (regardless of where they appear in the string).
  """
  def do_op({:swap_letters, x, y}, str) do
    index_x = Enum.find_index(str, & &1 == x)
    index_y = Enum.find_index(str, & &1 == y)
    Utils.swap(str, index_x, index_y)
  end


  @doc"""
  rotate left/right X steps means that the whole string should be rotated;
  for example, one right rotation would turn abcd into dabc.
  """
  def do_op({:rotate_left, x}, str) do
    {a, b} = Enum.split(str, rem(x, length(str)))
    b ++ a
  end

  @doc"""
   see :rotate_left
  """
  def do_op({:rotate_right, x}, str) do
    {a, b} = Enum.split(str, -1 * rem(x, length(str)))
    b ++ a
  end

  @doc"""
  rotate based on position of letter X means that the whole string should be rotated
  to the right based on the index of letter X (counting from 0) as determined before
  this instruction does any rotations. Once the index is determined, rotate the string
  to the right one time, plus a number of times equal to that index, plus one
  additional time if the index was at least 4.
  """
  def do_op({:rotate_based_on_pos, x}, str) do
    letter_index = Enum.find_index(str, & &1 == x)
    case letter_index do
      x when x >= 4 -> do_op({:rotate_right, x + 2}, str)
      x -> do_op({:rotate_right, x + 1}, str)
    end
  end

  @doc"""
  reverse positions X through Y means that the span of letters at indexes X
  through Y (including the letters at X and Y) should be reversed in order.
  """
  def do_op({:reverse_pos, x, y}, str) do
    {a, b} = Enum.split(str, x)
    {b, c} = Enum.split(b, (y-x) + 1)
    a ++ Enum.reverse(b) ++ c
  end

  @doc"""
  move position X to position Y means that the letter which is at index X
  should be removed from the string, then inserted such that it ends up at index Y.
  """
  def do_op({:move_pos, x, y}, str) do
    {val, list} = List.pop_at(str, x)
    List.insert_at(list, y, val)
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


  def solve(input, starting_string) do
    input |> Enum.reduce(starting_string, fn x, acc -> do_op(x, acc) |> IO.inspect end)
  end

  def solve2(input, starting_string) do
    Utils.permutations(starting_string)
    |> Stream.map(fn x -> {solve(input, x), x} end)
    |> Stream.filter(fn {solved, x} -> solved == starting_string end)
    |> Enum.take(1)
  end

end

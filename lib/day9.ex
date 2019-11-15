defmodule Day9 do
  def real_input do
    Utils.get_input(9, 1)
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

  def solve1(input), do: solve(input)
  def solve2(input), do: solve(input)

  def parse_input(input) do
    input
    |> to_charlist
  end

  def solve(input) do
    input
    |> Enum.filter(fn x -> x > 32 end) # whitespace
    |> decompress
    |> length
  end

  def get_int_from_codepoint(codepoint) do
    [codepoint] |> to_string |> String.to_integer
  end

  def repeat_charlist(charlist, times) do
    List.flatten(for _ <- 1..times, do: charlist)
  end

  def decompress(file) do
    do_decompress(file, '')
  end

  defp do_decompress([?( | rest], processed) do
    do_decompress(:parsing_x, rest, '', processed)
  end

  defp do_decompress(:parsing_x, [?x | rest ], cur_x, processed) do
    do_decompress(:parsing_y, rest, cur_x, '', processed)
  end

  defp do_decompress(:parsing_x, [x | rest], cur_x, processed) do
    do_decompress(:parsing_x, rest, cur_x ++ [x], processed)
  end

  defp do_decompress(:parsing_y, [?) | rest], x, cur_y, processed) do
    do_decompress(:complete, x, cur_y, rest, processed)
  end

  defp do_decompress(:parsing_y, [y | rest], x, cur_y, processed) do
    do_decompress(:parsing_y, rest, x, cur_y ++ [y], processed)
  end

  defp do_decompress(:complete, x, y, rest, processed) do
    num_chars = get_int_from_codepoint(x)
    repeat = get_int_from_codepoint(y)
    {to_repeat, remaining} = Enum.split(rest, num_chars)
    do_decompress(remaining, processed ++ repeat_charlist(to_repeat, repeat))
  end

  defp do_decompress([], processed), do: processed

  defp do_decompress([h | t], processed), do: do_decompress(t, processed ++ [h])

end

defmodule Day14 do
  def real_input do
    Utils.get_input(14, 1)
  end

  def sample_input do
    """
    abc
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
    |> String.trim
  end

  def solve(input) do
    salt = input
    get_next_key(salt, 0, [], MapSet.new)
  end

  def get_next_key(salt, index, keys, ignoring) when length(keys) >= 64 do
    {keys, ignoring}
  end

  def get_next_key(salt, index, keys, ignoring) do
    case is_key?(salt, index, ignoring) do
      false -> get_next_key(salt, index + 1, keys, ignoring)
      {false, _} -> get_next_key(salt, index + 1, keys, ignoring)
      {true, val} -> get_next_key(salt, index + 1, [index | keys], ignoring)
    end
  end

  def md5(value) do
    :crypto.hash(:md5, value)
    |> Base.encode16()
    |> String.downcase
  end

  def hash(salt, index) do
    md5("#{salt}#{index}")
  end

  def is_key?(salt, index, used_chars) do
    case contains_n_length_run(hash(salt, index), 3, ignoring: used_chars) do
      {:ok, found} ->
        {
          index + 1..index + 1000
          |> Enum.map(fn x -> match?({:ok, _}, contains_n_length_run(hash(salt, x), 6, only: found)) end)
          |> Enum.any?(& &1),
          found
        }
      :error ->
        false
    end
  end

  def contains_n_length_run(string, n, options \\ []) do
    ignoring = Keyword.get(options, :ignoring, MapSet.new)
    only = Keyword.get(options, :only, nil)

    res = string
          |> String.to_charlist
          |> Enum.reduce_while(
               {1, nil},
               fn x, {count, last} ->
                 new_count = cond do
                   only != nil and not Enum.member?(only, x) -> 1
                   only != nil and Enum.member?(only, x) -> count + 1
                   MapSet.member?(ignoring, x) -> 1
                   x == last -> count + 1
                   true -> 1
                 end

                 case new_count do
                   ^n -> {:halt, {:ok, [x]}}
                   _ -> {:cont, {new_count, x}}
                 end
               end
             )

    case res do
      {:ok, value} -> {:ok, value}
      _ -> :error
    end
  end

end

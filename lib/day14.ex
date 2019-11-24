defmodule Day14 do
  use Memoize

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

  def parse_input(input) do
    input
    |> String.trim
  end

  def solve(input) do
    salt = input
    get_next_key(salt, 0, [])
  end

  def solve2(input) do
    salt = input
    Stream.iterate(0, &(&1 + 1))
    |> Flow.from_enumerable
    |> Flow.map(fn x -> {x, is_key?(salt, x, &hash2/2)} end)
    |> Flow.filter(fn {x, is_key} -> is_key end)
    |> Stream.take(64)
    |> Enum.to_list
    |> Enum.take(-1)
  end

  def get_next_key(salt, index, keys) when length(keys) >= 64 do
    keys
  end

  def get_next_key(salt, index, keys) do
    case is_key?(salt, index, &hash/2) do
      false -> get_next_key(salt, index + 1, keys)
      {false, _} -> get_next_key(salt, index + 1, keys)
      true -> get_next_key(salt, index + 1, [index | keys])
    end
  end

  def md5(value) do
    :crypto.hash(:md5, value)
    |> Base.encode16()
    |> String.downcase
  end

  defmemo hash(salt, index) do
    md5("#{salt}#{index}")
  end

  defmemo hash2(salt, index) do
    do_hash2(hash(salt, index), 1)
  end

  defp do_hash2(hash, 2016), do: md5(hash)
  defp do_hash2(hash, count) do
    md5(do_hash2(hash, count + 1))
  end

  def is_key?(salt, index, hash_fun) do
    case contains_n_length_run(hash_fun.(salt, index), 3) do
      {:ok, found} ->
        index + 1..index + 1000
        |> Enum.map(fn x -> match?({:ok, _}, contains_n_length_run(hash_fun.(salt, x), 6, only: found)) end)
        |> Enum.any?(& &1)
      :error ->
        false
    end
  end

  def contains_n_length_run(string, n, options \\ []) do
    only = Keyword.get(options, :only, nil)

    res = string
          |> String.to_charlist
          |> Enum.reduce_while(
               {1, nil},
               fn x, {count, last} ->
                 new_count = cond do
                   only != nil and not Enum.member?(only, x) -> 1
                   only != nil and Enum.member?(only, x) -> count + 1
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

defmodule Day20 do
  def real_input do
    Utils.get_input(20, 1)
  end

  def sample_input do
    """
    5-8
    0-2
    4-7
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
    |> String.split("\n", trim: true)
    |> Enum.map(
         fn x ->
           String.split(x, "-")
           |> Enum.map(&String.to_integer/1)
           |> List.to_tuple
         end
       )
  end

  def solve(input) do
    Stream.iterate(0, & &1 + 1)
    |> Stream.take_while(fn x -> x <= 4294967295 end)
    |> Flow.from_enumerable()
    |> Flow.filter(
         fn x ->
           !Enum.any?(input, fn range -> in_range(x, range) end)
         end
       )
    |> Stream.map(&IO.inspect/1)
    |> Enum.to_list
  end

  def in_range(x, {a, b}) do
    x >= a and x <= b
  end

  def solve_stupid(input) do
    Stream.iterate(0, & &1 + 1)
    |> Flow.from_enumerable()
    |> Flow.filter(
         fn x ->
           !Enum.any?(input, fn range -> in_range(x, range) end)
         end
       )
    |> Stream.take(1)
    |> Enum.to_list
  end

  def collapse_ranges(ranges) do
    {[current | list] = all, last} = ranges
                                     |> Enum.sort
                                     |> Enum.reduce(
                                          {[], nil},
                                          &reduction/2
                                        )

    case merge_range(current, last) do
      :disjoint -> [last | all]
      {:ok, merged} -> [merged | all]
    end
  end

  def reduction({next_start, next_end} = next, {list, current}) do
    case merge_range(current, next) do
      :error -> {list, next}
      :disjoint -> {[current | list], next}
      {:ok, merged} -> {list, merged}
    end
  end

  def merge_range(nil, next), do: :error

  def merge_range({current_start, current_end} = current, {next_start, next_end} = next) do
    cond do
      next_start <= current_end and next_end >= current_end ->
        {:ok, {current_start, next_end + 1}}
      next_start <= current_end ->
        {:ok, current}
      true ->
        :disjoint
    end
  end

  def solve2(input) do
    max = 4294967295

    blocked_count = input
                    |> collapse_ranges
                    |> Enum.reduce(
                         0,
                         fn {a, b}, acc ->
                           acc + (b - a)
                         end
                       )

    max - blocked_count
  end

end

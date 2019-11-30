defmodule Day22 do
  def real_input do
    Utils.get_input(22, 1)
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
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  @doc """
  Parses lines like:

  Filesystem              Size  Used  Avail  Use%
  /dev/grid/node-x0-y0     92T   72T    20T   78%

  into {0, 0, 92, 72, 20, 0.78}
  """
  def parse_line(line) do
    ~r"dev/grid/node-x(\d+)-y(\d+)\s*(\d+)T\s*(\d+)T\s*(\d+)T\s*(\d+)"
    |> Regex.scan(line, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  def x({x, _, _, _, _, _}), do: x
  def y({_, x, _, _, _, _}), do: x
  def size({_, _, x, _, _, _}), do: x
  def used({_, _, _, x, _, _}), do: x
  def available({_, _, _, _, x, _}), do: x
  def percent_used({_, _, _, _, _, x}), do: x

  def node_is_empty?(node) do
    used(node) == 0
  end

  def data_would_fit?(a, b) do
    used(a) <= available(b)
  end

  def solve(input) do
  (for a <- input, b <- input, do: [a, b])
                                    |> Stream.filter(fn [a, b] -> a != b end)
                                    |> Stream.reject(fn [a, b] -> node_is_empty?(a) end)
                                    |> Stream.filter(fn [a, b] -> data_would_fit?(a, b) end)
                                    |> Enum.count()
  end

end

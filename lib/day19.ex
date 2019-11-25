defmodule Day19 do
  def real_input do
    3012210
  end

  def sample_input do
    5
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
  end


  @doc"""
  We'll keep a map of
  """
  def solve(count) do
    count
    |> white_elephant
  end

  @doc """
  All the info we need is the number of participants

  the state will be a map of position to number of presents

  when any player's present count is equal to the number of players, we exit
  """
  def white_elephant(count) do
    state = 1..count
    |> Enum.map(fn x -> {x, 1} end)
    |> Enum.into(%{})

    do_white_elephant(state, 1, count)
  end

  defp do_white_elephant(state, current, total) do
    case Map.get(state, current) do
      nil ->
        do_white_elephant(state, cyclic_next(current, total), total)
      0 ->
        do_white_elephant(state |> Map.delete(current), cyclic_next(current, total), total)
      ^total ->
        current
      x ->
        {elf, count} = get_next(state, current, total)
        state
        |> Map.put(current, x + count)
        |> Map.delete(elf)
        |> do_white_elephant(cyclic_next(current, total), total)
    end
  end

  def render_state(state) do
    Map.to_list(state)
    |> Enum.sort
    |> Enum.map(fn {a, b} -> "#{a} : #{b}" end)
    |> Enum.join("\n")
    |> IO.puts
  end

  @doc """
  get next in line skipping nils
  """
  def get_next(state, count, total) do
    next = cyclic_next(count, total)
    case Map.get(state, next) do
      nil -> get_next(state, next, total)
      val -> {next, val}
    end
  end

  @doc """
  Shenanigans to index to 1
  """
  def cyclic_next(val, count) do
    case rem(val + 1, count) do
      0 -> count
      x -> x
    end
  end

end

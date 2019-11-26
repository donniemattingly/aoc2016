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

  def parse_input(input) do
    input
  end


  @doc"""
  """
  def solve(count) do
    count
    |> white_elephant
  end

  def solve2(input) do
    with_math(input)
  end

  @doc """
  All the info we need is the number of participants

  the state will be a map of position to number of presents

  when any player's present count is equal to the number of players, we exit
  """
  def white_elephant(count, next_fun \\ &get_next/3) do
    state = 1..count
    |> Enum.map(fn x -> {x, 1} end)
    |> Enum.into(%{})

    do_white_elephant(state, 1, count, next_fun)
  end

  defp do_white_elephant(state, current, total, next_fun) do
    IO.inspect({current, Map.get(state, current)})
    case Map.get(state, current) do
      nil ->
        do_white_elephant(state, cyclic_next(current, total), total, next_fun)
      0 ->
        do_white_elephant(state |> Map.delete(current), cyclic_next(current, total), total, next_fun)
      ^total ->
        current
      x ->
        {elf, count} = next_fun.(state, current, total)
        state
        |> Map.put(current, x + count)
        |> Map.delete(elf)
        |> do_white_elephant(cyclic_next(current, total), total, next_fun)
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

  def across_circle(state, count, total) do
    elves = state |> Map.keys |> Enum.sort
    index = Enum.find_index(elves, fn x -> x == count end)
    size = length(elves)
    across = Enum.at(elves, rem(index + Integer.floor_div(size, 2), size))

    {across, Map.get(state, across)}
  end

  def with_math(count) do
    log = log3(count)
    floor = :math.pow(3, :math.floor(log))
    ceil = :math.pow(3, :math.ceil(log))

    excess = count - floor

    case excess do
      x when x <= floor -> x
      x when x > floor -> floor + (excess - floor) * 2
    end
  end

  def log3(n) do
    :math.log(n) / :math.log(3)
  end

  def by_two(count) do
    count
    |> log3
    |> :math.floor
    |> :math.pow
  end

end

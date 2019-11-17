defmodule Day10 do
  def real_input do
    Utils.get_input(10, 1)
  end

  def sample_input do
    """
    value 5 goes to bot 2
    bot 2 gives low to bot 1 and high to bot 0
    value 3 goes to bot 1
    bot 1 gives low to output 1 and high to bot 0
    bot 0 gives low to output 2 and high to output 0
    value 2 goes to bot 2
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
  def solve2(input) do
    s = solve(input)
    [s.o0, s.o1, s.o2]
    |> Enum.map(&hd/1)
    |> Enum.reduce(1, &*/2)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction/1)
  end

  def parse_instruction("bot " <> instruction) do
    pattern = ~r/([0-9]+) gives low to (bot|output) ([0-9]+) and high to (bot|output) ([0-9]+)/
    [bot, low_type, low, high_type, high | _] = Regex.run(pattern, instruction, capture: :all_but_first)
    {:move, "b" <> bot |> String.to_atom , parse_destination(high, high_type), parse_destination(low, low_type)}
  end

  def parse_destination(dest, type) do
    case type do
      "bot" -> "b" <> dest |> String.to_atom
      "output" -> "o" <> dest |> String.to_atom
    end
  end

  def parse_instruction("value " <> instruction) do
    pattern = ~r/([0-9]+) goes to bot ([0-9]+)/
    [value, bot | _ ] = Regex.run(pattern, instruction, capture: :all_but_first)
    {:init, "b" <> bot |> String.to_atom, value |> String.to_integer}
  end

  def instruction_to_edges({:move, bot, high, low}) do
    [
      Graph.Edge.new(bot, high, label: :high),
      Graph.Edge.new(bot, low, label: :low)
    ]
  end

  def moves_to_graph(moves) do
    moves
    |> Enum.flat_map(&instruction_to_edges/1)
    |> Enum.reduce(Graph.new, fn x, acc -> Graph.add_edge(acc, x) end)
  end

  def init_state(init) do
    Enum.reduce(init, %{}, fn {:init, bot, value}, acc ->
      update_state(acc, bot, value)
    end)
  end

  def update_state(state, bot, value) do
    Map.update(state, bot, [value], &([value | &1]))
  end

  def pass_chips(g, v, state) do
    {min, max} = state |> Map.get(v) |> Enum.min_max
    edges = Graph.out_edges(g, v)
    low = edges |> Enum.find(fn e -> e.label == :low end)
    high = edges |> Enum.find(fn e -> e.label == :high end)
    log_pass(v, {min, max})
    state
    |> update_state(low.v2, min)
    |> update_state(high.v2, max)
    |> Map.delete(v)
  end

  def log_pass(v, {17, 61}) do
    IO.inspect(v)
  end

  def log_pass(v, _), do: nil

  def can_pass(state) do
    state |> Map.values |> Enum.any?(fn l -> length(l) > 1 end)
  end

  def run(g, state) do
    new_state = Graph.Reducers.Bfs.reduce(g, state, fn v, acc ->
      case Map.get(acc, v) do
        [v1, v2] -> {:next, pass_chips(g, v, acc)}
        _ -> {:next, acc}
      end
    end)

    case can_pass(new_state) do
      false -> new_state
      true -> run(g, new_state)
    end
  end

  def solve(input) do
    %{init: init, move: moves} = Enum.group_by(input, &elem(&1, 0))
    g = moves_to_graph(moves)
    state = init_state(init)
    run(g, state)
  end

end

defmodule Day11 do
  def real_input do
    Utils.get_input(11, 1)
  end

  def sample_input do
    """
    The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
    The second floor contains a hydrogen generator.
    The third floor contains a lithium generator.
    The fourth floor contains nothing relevant.
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
    |> Enum.with_index
    |> Enum.flat_map(fn {x, i} ->
      Enum.map(x, &({i, elem(&1, 1), elem(&1, 0)}))
    end)

  end

  def parse_line(line) do
    List.flatten([get_microchips(line), get_generators(line)])
  end

  def get_component(line, regex, label) do
    Regex.scan(regex, line, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(&String.slice(&1, 0..2))
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(& {label, &1})
  end

  def get_microchips(line) do
    get_component(line, ~r/([a-z]+)\-compatible microchip/, :m)
  end

  def get_generators(line) do
    get_component(line, ~r/([a-z]+) generator/, :g)
  end

  @doc"""
  Returns a Stream of possible (but not necessarily valid) states

  Assumes 4 floors, elevator can hold two items, etc

  States are composed of:
    - floor of each component
    - position of elevator


  First 2 bit chunk is the elevator position
  Remaining 2 bit chunks are in component sorted order
  """
  def get_states(input) do
    components = input |> Enum.map(&just_component/1) |> Enum.sort
    num_components = length(components)
    states_count = num_states(num_components) |> IO.inspect

    0..states_count-1
    |> Stream.map(&number_to_state(components, &1))
    |> Stream.filter(&valid_state?/1)
  end

  @doc"""
  assuming we get components in the order they're supposed to be (sorted)
  """
  def number_to_state(components, num) do
    <<num::32>>
    |> BitUtils.chunks(2)
    |> Enum.reverse
    |> Enum.map(fn <<x::2>> -> x end)
    |> Enum.zip([:elevator | components])
  end

  @doc"""
  State changes all rely on the elevator. Up to two components on the floor the elevator is on
  can move up or down one level. We'll filter these new states w/ the same filter as the vertex
  generator
  """
  def neighbor_states(state) do
    {elevator_floor, _ } = Enum.find(state, fn x -> elem(x, 1) == :elevator end)
    can_move = state
               |> Enum.filter(fn {floor, c} -> floor == elevator_floor and c != :elevator end)
               |> Enum.map(&elem(&1, 1))

    elevator_combinations = 1..2
    |> Enum.flat_map(&Comb.combinations(can_move, &1))

    possible_floors = [elevator_floor + 1, elevator_floor - 1 ] |> Enum.filter(& &1 >= 0)

    Comb.cartesian_product(possible_floors, elevator_combinations)
    # at this point I have a list of the potential new states via a list of new floor and comp
    # to move to that floor. Just need to map back to actual state, confirm it's valid, and return
    # once I do that I can use orig / new to add an edge to the graph.
  end

  def just_component({floor, type, element}) do
    {type, element}
  end

  def num_states(num_components) do
    :math.pow(2, 2 * (num_components + 1)) |> round
  end

  def valid_state?(state) do
    state
    |> Enum.group_by(&elem(&1, 0))
    |> Map.values
    |> Enum.all?(&valid_floor?/1)
  end

  def valid_floor?(floor) do
    cleaned_floor = floor
    |> Enum.map(&elem(&1, 1))   # don't care what floor
    |> Enum.filter(&is_tuple/1) # ignore the elevator

    # accumulating a boolean, if any chip would be fried it's always false
    Enum.reduce(just_microchips(cleaned_floor), true, fn x, acc ->
      acc and would_fry_microchip?(x, cleaned_floor)
    end)
  end

  @doc"""
  A microchip is fried if it's on a floor w/ another RTG w/ out it's own
  """
  def would_fry_microchip?(chip, floor) do
    has_generators?(floor) and not has_own_rtg?(chip, floor)
  end

  def has_own_rtg?({type, :m}, floor) do
    Enum.member?(floor, {type, :g})
  end

  def has_generators?(floor) do
    Enum.any?(floor, &(elem(&1, 1) == :g))
  end

  def just_microchips(floor) do
    Enum.filter(floor, fn {type, component} -> component == :m end)
  end

  def solve(input) do
    input
  end

end

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
    |> Enum.flat_map(
         fn {x, i} ->
           Enum.map(x, &({i, elem(&1, 1), elem(&1, 0)}))
         end
       )

  end

  def parse_line(line) do
    List.flatten([get_microchips(line), get_generators(line)])
  end

  def get_component(line, regex, label) do
    Regex.scan(regex, line, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(&String.slice(&1, 0..2))
    |> Enum.map(&String.to_atom/1)
    |> Enum.map(&{label, &1})
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
    components = input
                 |> get_components_from_parsed_input
    num_components = length(components)
    states_count = num_states(num_components)

    states = 0..states_count - 1
             |> Stream.map(&number_to_state(&1, components))
             |> Stream.filter(&valid_state?/1)
             |> Stream.flat_map(
                  fn state ->
                    neighbor_states(state)
                    |> Enum.map(fn x -> {state, x} end)
                  end
                )
             |> Stream.uniq

    {states, states_count - 1}
  end

  def get_components_from_parsed_input(input) do
    input
    |> Enum.map(&just_component/1)
    |> Enum.sort
  end

  @doc"""
  assuming we get components in the order they're supposed to be (sorted)
  """
  def number_to_state(num, components) do
    <<num :: 32>>
    |> BitUtils.chunks(2)
    |> Enum.reverse
    |> Enum.map(fn <<x :: 2>> -> x end)
    |> Enum.zip([:elevator | components])
  end

  def state_to_number(state) do
    {num, rest} = state
                  |> Enum.reverse
                  |> Enum.map(&elem(&1, 0))
                  |> Enum.map(&Integer.to_string(&1, 2))
                  |> Enum.map(&String.pad_leading(&1, 2, "0"))
                  |> Enum.join("")
                  |> Integer.parse(2)
    num

    if num == 1328494 do
      IO.inspect({state, num})
    end

    num
  end

  @doc"""
  State changes all rely on the elevator. Up to two components on the floor the elevator is on
  can move up or down one level. We'll filter these new states w/ the same filter as the vertex
  generator
  """
  def neighbor_states(state) do
    # get the current floor
    {elevator_floor, _} = Enum.find(state, fn x -> elem(x, 1) == :elevator end)

    # get components that can move
    can_move = state
               |> Enum.filter(fn {floor, c} -> floor == elevator_floor and c != :elevator end)
               |> Enum.map(&elem(&1, 1))

    # get a list components that can go in the elevator
    elevator_combinations = 1..2
                            |> Enum.flat_map(&Comb.combinations(can_move, &1))

    # get a list of the floors that the elevator can go to
    possible_floors = [elevator_floor + 1, elevator_floor - 1]
                      |> Enum.filter(&(&1 >= 0 and &1 < 4))

    # the product of these lists are all possible transitions from this state
    res = Comb.cartesian_product(possible_floors, elevator_combinations)
          |> Enum.map(&List.to_tuple/1)
          |> Enum.map(&advance_state(&1, state))
          |> Enum.filter(&valid_transition?(&1, state))
          |> Enum.filter(&valid_state?/1)

    if state_to_number(state) == 1328494 do
      IO.inspect(res)
    end

    res
  end


  @doc"""
  the move is a 2 element list [a, b] with a being the new floor for the elevator and
  b being the list of components to move
  """
  def advance_state({new_floor, components}, state) do
    state
    |> Enum.map(
         fn {cur_floor, component} ->
           cond do
             component == :elevator ->
               {new_floor, :elevator}
             Enum.member?(components, component) ->
               {new_floor, component}
             true ->
               {cur_floor, component}
           end
         end
       )
  end

  def just_component({floor, type, element}) do
    {type, element}
  end

  def num_states(num_components) do
    :math.pow(2, 2 * (num_components + 1))
    |> round
  end

  def valid_transition?(state, prev_state) do
    [h1 | t1] = state
    [h2 | t2] = prev_state
    h1 != h2 and t2 != t1
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
    Enum.reduce(
      just_microchips(cleaned_floor),
      true,
      fn x, acc ->
        acc and not would_fry_microchip?(x, cleaned_floor)
      end
    )
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

  def lazy_count(stream) do
    Stream.scan(stream, 0, fn x, acc -> acc + 1 end)
  end

  def state_transitions_to_graph(states, store_as_int \\ false) do
    new_states = case store_as_int do
      false ->
        states
      true ->
        states
        |> Enum.map(
             fn {v1, v2} ->
               {
                 state_to_number(v1)
                 |> to_string,
                 state_to_number(v2)
                 |> to_string
               } end
           )
    end
    Graph.add_edges(Graph.new(type: :directed), new_states)
  end

  def input_to_initial_state(input) do
    mapped = input
             |> Enum.map(fn {floor, type, component} -> {floor, {type, component}} end)
             |> Enum.sort(fn a, b -> elem(a, 1) < elem(b, 1) end)

    [{0, :elevator} | mapped]
  end

  def input_to_start_and_end_states(input) do
    mapped = input
             |> Enum.map(fn {floor, type, component} -> {floor, {type, component}} end)
             |> Enum.sort(fn a, b -> elem(a, 1) < elem(b, 1) end)

    initial = [{0, :elevator} | mapped]
    final = initial |> Enum.map(fn {floor, component} -> {3, component} end)
    {initial, final}
  end

  def print_state(state) do
    state
    |> render_state
    |> IO.puts
  end

  def render_state(state) do
    [elevator | components] = state
                              |> Enum.map(&elem(&1, 1))
    ordering = [
                 elevator | components
                            |> Enum.sort
               ]
               |> Enum.with_index
               |> Map.new
               |> Map.put(:total, length(state))
    lines = 0..3
            |> Enum.reduce(
                 Enum.group_by(state, &elem(&1, 0)),
                 fn x, acc ->
                   Map.update(acc, x, [], & &1)
                 end
               )
            |> Map.to_list
            |> Enum.map(&render_floor(&1, ordering))
            |> Enum.reverse

    Enum.join([state_to_number(state) | lines], "\n")
  end

  def render_floor({floor_num, rest}, ordering) do
    comps = rest
            |> Enum.map(&elem(&1, 1))
            |> Enum.map(fn x -> {Map.get(ordering, x), x} end)
            |> Map.new
    rendered = 0..ordering.total
               |> Enum.map(
                    fn num ->
                      case Map.get(comps, num) do
                        nil -> ". "
                        x -> render_component(x)
                      end
                    end
                  )

    ["F#{floor_num + 1}" | rendered]
    |> Enum.join(" ")
  end

  def render_component(:elevator), do: "E "
  def render_component(component) do
    component
    |> Tuple.to_list
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.slice(&1, 0..0))
    |> Enum.map(&String.upcase/1)
    |> Enum.join("")
  end

  def old_solve(input) do
    components = get_components_from_parsed_input(input)
    init = input_to_initial_state(input)
           |> state_to_number
           |> to_string
    {states, final_num} = get_states(input)
    g = states
        |> state_transitions_to_graph(true)

    #    final = number_to_state(final_num, components)
    final = final_num
            |> to_string
    {g, init, final}
    Graph.dijkstra(g, init, final)
    #        |> Enum.map(&number_to_state(&1, components))
    #        |> Enum.map(&render_state/1)
  end

  def alt_get_states(input) do
    initial = input_to_initial_state(input)
  end

  def get_edges(node) do
    neighbors = neighbor_states(node)
  end

  def solve(input) do
    {initial, final} = input_to_start_and_end_states(input)
    { _, discovered_map } = GraphUtils.bfs(initial, fn x -> neighbors_for_search(x, final) end)
    get_path(discovered_map, final)
  end

  def neighbors_for_search(node, final) do
    cond do
      node == final -> []
      true -> neighbor_states(node)
    end
  end

  def get_path(map, goal) do
    get_path(map, goal, [])
  end

  defp get_path(map, current_node, path) do
    case Map.get(map, current_node) do
      nil -> path
      x -> get_path(map, x, [ current_node | path ])
    end
  end

end
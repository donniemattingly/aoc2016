defmodule Day1 do

  def main do
    part2()
  end

  def get_processed_input do
    Utils.get_input(1, 1)
    |> String.split(",")
    |> Enum.map(&String.trim(&1))
    |> Enum.map(fn(str) ->
      case String.split_at(str, 1) do
        {"L", amt} -> {:l, amt}
        {"R", amt} -> {:r, amt}
        _ -> nil
      end
    end)
    |> Enum.map(fn({dir, amt}) ->
      {val, ""} = Integer.parse(amt)
      {dir, val}
    end)
  end

  def part2 do
    move(get_processed_input(), :n, {0, 0}, %{})
    |> get_distance
  end

  def get_distance({x, y}) do
    abs(x) + abs(y)
  end

  @doc """
  Here we take the map of positions we've visited, and do two updates

    1. we increment the count of places we've visited twice
    2. we insert a record of key count w/ this pos

    so at the end we can sort by the lowest count
  """
  def insert_already_visited(visits, pos, count) do
    new_count = count + 1
    visits
    |> Map.put(:count, new_count)
    |> Map.update(pos, 1, &(&1 + 1))
    |> Map.put(new_count, pos)
  end


  @doc """
  Take the map of visits (which also holds values around what has been reached twice first when)
  and update it for every position in this move.f
  """
  def update_visits(visits, all_pos) do
    all_pos |> Enum.reduce(visits, fn(pos, acc) ->
      cur_count = Map.get(acc, :count, 0)
      case Map.get(acc, pos) do
        nil -> Map.put(acc, pos, 1)
        x -> insert_already_visited(acc, pos, cur_count)
      end
    end)
  end

  def move([], _, pos, visits) do
    visits
    |> Map.get(1)
  end

  def move([{:r, amount} | rest], :n, {x, y}, visits) do
    pos = {x + amount, y}
    all_pos = 1..amount |> Enum.map(&({x + &1, y}))
    move(rest, :e, pos, visits |> update_visits(all_pos))
  end

  def move([{:r, amount} | rest], :e, {x, y}, visits) do
    pos = {x, y - amount}
    all_pos = 1..amount |> Enum.map(&({x, y - &1}))
    move(rest, :s, pos, visits |> update_visits(all_pos))
  end

  def move([{:r, amount} | rest], :s, {x, y}, visits) do
    pos = {x - amount, y}
    all_pos = 1..amount |> Enum.map(&({x - &1, y}))
    move(rest, :w, pos, visits |> update_visits(all_pos))
  end

  def move([{:r, amount} | rest], :w, {x, y}, visits) do
    pos = {x, y + amount}
    all_pos = 1..amount |> Enum.map(&({x, y + &1}))
    move(rest, :n, pos, visits |> update_visits(all_pos))
  end

  def move([{:l, amount} | rest], :n, {x, y}, visits) do
    pos = {x - amount, y}
    all_pos = 1..amount |> Enum.map(&({x - &1, y}))
    move(rest, :w, pos, visits |> update_visits(all_pos))
  end

  def move([{:l, amount} | rest], :e, {x, y}, visits) do
    pos = {x, y + amount}
    all_pos = 1..amount |> Enum.map(&({x, y + &1}))
    move(rest, :n, pos, visits |> update_visits(all_pos))
  end

  def move([{:l, amount} | rest], :s, {x, y}, visits) do
    pos = {x + amount, y}
    all_pos = 1..amount |> Enum.map(&({x + &1, y}))
    move(rest, :e, pos, visits |> update_visits(all_pos))
  end

  def move([{:l, amount} | rest], :w, {x, y}, visits) do
    pos = {x, y - amount}
    all_pos = 1..amount |> Enum.map(&({x , y - &1}))
    move(rest, :s, pos, visits |> update_visits(all_pos))
  end
end
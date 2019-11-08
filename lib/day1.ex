defmodule Day1 do

  def main do
    part1()
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
  end

  def update_visits(visits, all_pos) do
    all_pos |> Enum.reduce(visits, fn(pos, acc) ->
      acc
      |> Map.update(pos, 1, fn(val) ->
        IO.puts("visited twice: #{elem(pos, 0)}, #{elem(pos, 1)}")
        val + 1
      end)
    end)
  end

  def move([], _, pos, visits) do
    visits
    |> Enum.filter(fn({k, v}) -> v > 1 end)
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
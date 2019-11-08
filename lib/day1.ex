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

  def part1 do
    move(get_processed_input(), :n, {0, 0}, %{})
  end

  def update_visits(visits, pos) do
    visits
    |> Map.update(pos, 0, fn(val) ->
      IO.puts("visited twice: #{elem(pos, 0)}, #{elem(pos, 1)}")
      val + 1
    end)
  end

  def move([], _, pos, visits) do
    visits
  end

  def move([{:r, amount} | rest], :n, {x, y}, visits) do
    pos = {x + amount, y}
    move(rest, :e, pos, visits |> update_visits(pos))
  end

  def move([{:r, amount} | rest], :e, {x, y}, visits) do
    pos = {x, y - amount}
    move(rest, :s, pos, visits |> update_visits(pos))
  end

  def move([{:r, amount} | rest], :s, {x, y}, visits) do
    pos = {x - amount, y}
    move(rest, :w, pos, visits |> update_visits(pos))
  end

  def move([{:r, amount} | rest], :w, {x, y}, visits) do
    pos = {x, y + amount}
    move(rest, :n, pos, visits |> update_visits(pos))
  end

  def move([{:l, amount} | rest], :n, {x, y}, visits) do
    pos = {x - amount, y}
    move(rest, :w, pos, visits |> update_visits(pos))
  end

  def move([{:l, amount} | rest], :e, {x, y}, visits) do
    pos = {x, y + amount}
    move(rest, :n, pos, visits |> update_visits(pos))
  end

  def move([{:l, amount} | rest], :s, {x, y}, visits) do
    pos = {x + amount, y}
    move(rest, :e, pos, visits |> update_visits(pos))
  end

  def move([{:l, amount} | rest], :w, {x, y}, visits) do
    pos = {x, y - amount}
    move(rest, :s, pos, visits |> update_visits(pos))
  end
end
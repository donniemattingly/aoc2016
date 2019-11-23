defmodule Utils do
  @moduledoc """
  Documentation for Aoc2016.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Aoc2016.hello()
      :world

  """
  def get_input(day, part) do
    "inputs/input-#{day}-#{part}.txt"
    |> File.read!
  end


  def time(fun) do
    {elapsed, _ } = :timer.tc(fun)

    elapsed / 1_000_000
  end
end

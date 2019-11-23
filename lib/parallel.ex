defmodule Parallel do
  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def spmap(stream, func) do
    stream
    |> Stream.map(&(Task.async(fn -> func.(&1) end)))
    |> Stream.map(&Task.await/1)
  end
end
defmodule Day6 do

  def get_hash(pass, index) do
    :crypto.hash(:md5 , "#{pass}#{index}") |> Base.encode16()
  end

  def is_interesting("00000" <> _ ) do
    true
  end

  def is_interesting(_) do
    false
  end

  def get_password_char(pass, index) do
    case get_hash(pass, index) do
      "00000" <> rest -> {String.at(rest, 0), index}
      _ -> nil
    end
  end

  def sample() do
    pass = "abc"
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn i -> get_password_char(pass, i) end)
    |> Stream.filter(&(&1 != nil))
    |> Stream.take(8)
    |> Enum.to_list
  end


  def part1() do
    pass = "abbhdwsy"
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(fn i -> get_password_char(pass, i) end)
    |> Stream.filter(&(&1 != nil))
    |> Stream.take(8)
    |> Enum.to_list
  end

end
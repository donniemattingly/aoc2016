defmodule Day5 do

  def get_hash(pass, index) do
    :crypto.hash(:md5 , "#{pass}#{index}") |> Base.encode16()
  end

  def stupid_parse_int(str) do
    case str do
      "0" -> 0
      "1" -> 1
      "2" -> 2
      "3" -> 3
      "4" -> 4
      "5" -> 5
      "6" -> 6
      "7" -> 7
      "8" -> 8
      "9" -> 9
      _ -> -1
    end
  end

  def get_password_char(pass, index) do
    case get_hash(pass, index) do
      "00000" <> rest -> {String.at(rest, 0), index}
      _ -> nil
    end
  end

  def get_password_char2(pass, index) do
    case get_hash(pass, index) do
      "00000" <> rest -> {rest |> String.at(0) |> stupid_parse_int, String.at(rest, 1), index}
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

  def state_complete(state) do
    0..7
    |> Enum.map(&Map.has_key?(state, &1))
    |> Enum.all?(&(&1))
  end

  def decrypt_passcode(pass, index, state \\ %{}) do
    [{pos, val, new_index} | _ ] = Stream.iterate(index + 1, &(&1 + 1))
    |> Stream.map(fn i -> get_password_char2(pass, i) end)
    |> Stream.filter(&(&1 != nil))
    |> Stream.take(1)
    |> Enum.to_list

    new_state = if pos < 0 or pos > 7 or Map.has_key?(state, pos) do
      state
    else
      Map.put(state, pos, val)
    end

    if state_complete(new_state) do
      new_state
    else
      decrypt_passcode(pass, new_index, new_state)
    end
  end

  def part2() do
    pass = "abbhdwsy"
    decrypt_passcode(pass, 0)
    |> Map.to_list
    |> Enum.sort
    |> Enum.map(&elem(&1, 1))
    |> Enum.join("")
  end

end
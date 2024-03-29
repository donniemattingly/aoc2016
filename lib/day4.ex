defmodule Day4 do
  def real_input do
    Utils.get_input(4, 1)
  end

  def sample_input do
    """
    aaaaa-bbb-z-y-x-123[abxyz]
    a-b-c-d-e-f-g-h-987[abcde]
    not-a-real-room-404[oarel]
    totally-real-room-200[decoy]
    """
  end

  def parse_code(code) do
    [name, id, checksum | _ ] = Regex.run(~r"([a-z\-]+)([0-9]+)\[([a-z]+)\]", code, capture: :all_but_first)
    {name, id, checksum}
  end

  def get_checksum(name) do
    name
    |> String.split("")
    |> Enum.filter(fn x -> x != "" &&  x != "-" end)
    |> Enum.group_by(&(&1))
    |> Map.to_list
    |> Enum.map(fn({char, occurs}) -> {length(occurs) * -1, char} end)
    |> Enum.sort
    |> Enum.map(&elem(&1, 1))
    |> Enum.take(5)
    |> Enum.join
  end

  def is_real_room({name, id, checksum}) do
    get_checksum(name) == checksum
  end

  def decode_name(name, id) do
    name
    |> String.split("-")
    |> Enum.map(&rotate_word(&1, String.to_integer(id)))
    |> Enum.join(" ")
  end

  def rotate_word(word, amount) do
    word
    |> String.to_charlist
    |> Enum.map(&rotate_character(&1, amount))
    |> to_string
  end

  def rotate_character(char, amount) do
    rem(char - ?a + amount, 26) + ?a
  end

  def parse_input(input) do
    input
    |> String.split
    |> Enum.map(&parse_code/1)
  end

  def part1() do
    real_input
    |> parse_input
    |> solve
  end

  def part2() do
    real_input
    |> parse_input
    |> Enum.filter(&is_real_room/1)
    |> Enum.map(fn({name, id, _}) ->
      {id, decode_name(name, id)}
    end)
  end

  def sample() do
    sample_input
    |> parse_input
    |> solve
  end

  def solve(parsed_input) do
    parsed_input
    |> Enum.filter(&is_real_room/1)
    |> Enum.map(&elem(&1, 1))
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end
end
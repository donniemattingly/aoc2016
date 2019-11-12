defmodule Aoc2016Test do
  use ExUnit.Case

  test "day1 part 2 works" do
    assert Day1.part2() == 182
  end

  test "day 2 sample input works" do
    assert Day2.sample() == "1985"
  end

  test "day 2 sample2 input works" do
    assert Day2.sample2() == "5DB3"
  end

  test "day 2 part 1 works" do
    assert Day2.part1() == "69642"
  end

  test "day 2 part 2 works" do
    assert Day2.part2() == "8CB23"
  end

  test "day 3 part 1 works" do
    assert Day3.part1() == 1050
  end

  test "day 3 part 2 works" do
    assert Day3.part2() == 1921
  end

  test "day 4 part 2 works" do
    [{id, _} | _ ] = Day4.part2()
    |> Enum.filter(fn({_ , name}) ->
      name == "northpole object storage "
    end)

    assert id == "324"
  end

  test "day 6 part 1 works" do
    assert Day6.part1() == "wkbvmikb"
  end

  test "day 6 part 2 works" do
    assert Day6.part2() == "evakwaga"
  end

  test "day 7 part 1 works" do
    assert Day7.part1() == 115
  end

end

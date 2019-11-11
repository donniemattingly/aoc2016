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
end

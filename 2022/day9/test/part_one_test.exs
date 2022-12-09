defmodule PartOneTest do
  use ExUnit.Case
  doctest PartOne

  test "adjancency" do
    assert PartOne.is_adjacent({0, 0}, {0, 0})
    assert not PartOne.is_adjacent({42, 42}, {69, 420})
    assert PartOne.is_adjacent({0, 1}, {0, 2})
    assert PartOne.is_adjacent({0, 3}, {1, 4})
    assert PartOne.is_adjacent({4, 4}, {5, 4})
    assert PartOne.is_adjacent({4, 3}, {3, 3})
  end

  test "next tail" do
    assert PartOne.next_tail({1, 1}, {1, 3}) == {1, 2}
    assert PartOne.next_tail({3, 1}, {1, 1}) == {2, 1}
    assert PartOne.next_tail({1, 1}, {3, 2}) == {2, 2}
    assert PartOne.next_tail({1, 1}, {2, 3}) == {2, 2}
    assert PartOne.next_tail({0, 0}, {1, 0}) == {0, 0}
  end
end

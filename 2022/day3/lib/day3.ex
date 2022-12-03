defmodule Day3 do
  def convert_to_priority(ch) do
    cond do
      ch in ?A..?Z -> ch - ?A + 27
      ch in ?a..?z -> ch - ?a + 1
    end
  end

  def solve_problem1(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line ->
      priorities = line |> String.trim() |> to_charlist |> Enum.map(&convert_to_priority/1)
      {left, right} = Enum.split(priorities, div(length(priorities), 2))
      left = MapSet.new(left)
      right = MapSet.new(right)
      MapSet.intersection(left, right) |> Enum.at(0)
    end)
    |> Enum.sum()
  end

  def solve_problem2(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line -> String.trim(line) end)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [first, second, third] ->
      first = MapSet.new(first |> to_charlist |> Enum.map(&convert_to_priority/1))
      second = MapSet.new(second |> to_charlist |> Enum.map(&convert_to_priority/1))
      third = MapSet.new(third |> to_charlist |> Enum.map(&convert_to_priority/1))

      MapSet.intersection(first, second) |> MapSet.intersection(third) |> Enum.at(0)
    end)
    |> Enum.sum()
  end
end

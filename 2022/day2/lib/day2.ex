defmodule Day2 do
  def solve_problem1(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line -> {String.at(line, 0), String.at(line, 2)} end)
    |> Enum.map(fn {them, us} ->
      case them do
        "A" ->
          case us do
            "X" -> 1 + 3
            "Y" -> 2 + 6
            "Z" -> 3 + 0
          end

        "B" ->
          case us do
            "X" -> 1 + 0
            "Y" -> 2 + 3
            "Z" -> 3 + 6
          end

        "C" ->
          case us do
            "X" -> 1 + 6
            "Y" -> 2 + 0
            "Z" -> 3 + 3
          end
      end
    end)
    |> Enum.sum()
  end

  def solve_problem2(path) do
    File.stream!(path, [:utf8])
    |> Enum.map(fn line -> {String.at(line, 0), String.at(line, 2)} end)
    |> Enum.map(fn {them, us} ->
      case them do
        "A" ->
          case us do
            "X" -> 0 + 3
            "Y" -> 3 + 1
            "Z" -> 6 + 2
          end

        "B" ->
          case us do
            "X" -> 0 + 1
            "Y" -> 3 + 2
            "Z" -> 6 + 3
          end

        "C" ->
          case us do
            "X" -> 0 + 2
            "Y" -> 3 + 3
            "Z" -> 6 + 1
          end
      end
    end)
    |> Enum.sum()
  end
end

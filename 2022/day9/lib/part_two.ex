defmodule PartTwo do
  defp update_rope(visited, rope, dir, step_by, destination) do
    visited = MapSet.put(visited, List.last(rope))

    if hd(rope) == destination do
      {visited, rope}
    else
      rope =
        List.update_at(rope, 0, fn {hx, hy} ->
          case dir do
            :horiz -> {hx + step_by, hy}
            :vert -> {hx, hy + step_by}
          end
        end)

      {_, rope} =
        tl(rope)
        |> Enum.reduce({hd(rope), [hd(rope)]}, fn seg, {prev, rope} ->
          new_seg = Utils.update_segment(seg, prev)
          {new_seg, rope ++ [new_seg]}
        end)

      update_rope(visited, rope, dir, step_by, destination)
    end
  end

  def solve(path) do
    rope = List.duplicate({0, 0}, 10)

    {set, _} =
      File.stream!(path, [:utf8])
      |> Enum.reduce({MapSet.new(), rope}, fn line, {visited, rope} ->
        {dir, delta} = Utils.offset_from_line(line)

        {hx, hy} = hd(rope)

        destination =
          case dir do
            :horiz -> {hx + delta, hy}
            :vert -> {hx, hy + delta}
          end

        step_by =
          if delta > 0 do
            1
          else
            -1
          end

        update_rope(visited, rope, dir, step_by, destination)
      end)

    MapSet.size(set)
  end
end

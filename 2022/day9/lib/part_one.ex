defmodule PartOne do
  def next_tail(tail, head) do
    Utils.update_segment(tail, head)
  end

  defp steps({hx, hy}, dir, delta) do
    final =
      case dir do
        :horiz -> {hx + delta, hy}
        :vert -> {hx, hy + delta}
      end

    start =
      if delta > 0 do
        1
      else
        -1
      end

    steps =
      start..delta
      |> Enum.map(fn d ->
        case(dir) do
          :horiz -> {hx + d, hy}
          :vert -> {hx, hy + d}
        end
      end)

    {final, steps}
  end

  def solve(path) do
    {set, _, _} =
      File.stream!(path, [:utf8])
      |> Enum.reduce({MapSet.new(), {0, 0}, {0, 0}}, fn line, {visited, tail, head} ->
        {dir, delta} = Utils.offset_from_line(line)

        {new_head, steps} = steps(head, dir, delta)

        {tail, visited} =
          steps
          |> Enum.reduce({tail, visited}, fn step, {tail, visited} ->
            new_tail = next_tail(tail, step)

            {new_tail, MapSet.put(visited, new_tail)}
          end)

        {visited, tail, new_head}
      end)

    MapSet.size(set)
  end
end

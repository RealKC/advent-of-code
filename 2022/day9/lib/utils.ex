defmodule Utils do
  def offset_from_line(line) do
    case String.split(line) do
      ["R", offset] -> {:horiz, String.to_integer(offset)}
      ["U", offset] -> {:vert, String.to_integer(offset)}
      ["D", offset] -> {:vert, -String.to_integer(offset)}
      ["L", offset] -> {:horiz, -String.to_integer(offset)}
    end
  end

  def is_adjacent({tx, ty}, {hx, hy}) do
    dx = abs(tx - hx)
    dy = abs(ty - hy)
    (dx == 0 or dx == 1) and (dy == 0 or dy == 1)
  end

  def update_segment({tx, ty}, {hx, hy}) do
    if is_adjacent({tx, ty}, {hx, hy}) do
      {tx, ty}
    else
      dy =
        cond do
          ty > hy -> -1
          ty == hy -> 0
          ty < hy -> 1
        end

      dx =
        cond do
          tx > hx -> -1
          tx == hx -> 0
          tx < hx -> 1
        end

      {tx + dx, ty + dy}
    end
  end
end

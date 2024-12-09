#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

defmodule Day6_Part1 do
  def walk(map, {x, y}, max_x, max_y, _) when x > max_x or x < 0 or y > max_y or y < 0 do
    visited_tiles = map |> Map.values |> Enum.count(&(&1 == "X"))
    {map, visited_tiles}
  end

  def walk(map, {x, y}, max_x, max_y, dir) when x <= max_x and x >= 0 and y <= max_y and y >= 0 do
    if Map.get(map, {x, y}) == "#" do
      turn_xy = case dir do
        0 -> {x - 1, y + 1}
        1 -> {x - 1, y - 1}
        2 -> {x + 1, y - 1}
        3 -> {x + 1, y + 1}
      end
      walk(map, turn_xy, max_x, max_y, rem(dir + 1, 4))
    else
      next_xy = case dir do
        0 -> {x + 1, y}
        1 -> {x, y + 1}
        2 -> {x - 1, y}
        3 -> {x, y - 1}
      end
      map |> Map.replace({x, y}, "X") |> walk(next_xy, max_x, max_y, dir)
    end
  end

  def walk(map, x, y, max_x, max_y, dir) when dir == 1 do
    new_dir = if(Map.get(map, {x, y+1}) == "#", do: 2, else: 1)
    map |> Map.replace({x, y}, "X")
      |> walk(x, y+1, max_x, max_y, new_dir)
  end

  def walk(map, x, y, max_x, max_y, dir) when dir == 2 do
    new_dir = if(Map.get(map, {x-1, y}) == "#", do: 3, else: 2)
    map |> Map.replace({x, y}, "X")
      |> walk(x-1, y, max_x, max_y, new_dir)
  end

  def walk(map, x, y, max_x, max_y, dir) when dir == 3 do
    new_dir = if(Map.get(map, {x, y-1}) == "#", do: 0, else: 3)
    map |> Map.replace({x, y}, "X")
      |> walk(x, y-1, max_x, max_y, new_dir)
  end
end

raw_map = text
  |> String.split("\n") |> Enum.map(&String.graphemes(&1))


[{[start_x],  start_y}] = raw_map |> Enum.map(fn row -> row
    |> Enum.with_index
    |> Enum.filter(&(elem(&1, 0) == "^"))
    |> Enum.map(&elem(&1, 1))
  end)
  |> Enum.with_index
  |> Enum.filter(&(length(elem(&1, 0)) > 0))

max_y = (raw_map |> length) - 1
max_x = (raw_map |> hd |> length) - 1

map = for x <- 0..max_x, y <- 0..max_y, reduce: %{} do acc ->
  value = raw_map |> Enum.at(y) |> Enum.at(x)
  acc |> Map.put({x, y}, value)
end

{traced_map, visited_tiles} = Day6_Part1.walk(map, {start_x, start_y}, max_x, max_y, 3)

for y <- 0..max_y do
  for x <- 0..max_x, reduce: [] do acc -> [Map.get(traced_map, {x, y}) | acc] end
    |> Enum.reverse
    |> List.to_charlist
    |> IO.puts
end

"visited #{visited_tiles} tiles" |> IO.puts

#!/bin/elixir

defmodule Day15Part1 do
  def next_pos({x, y}, dir) do
    case(dir) do
      ">" -> {x + 1, y}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
      "^" -> {x, y - 1}
    end
  end

  def is_pushable(map, pos, dir) do
    case(Map.get(map, pos)) do
      "#" -> false
      "." -> true
      "O" -> is_pushable(map, next_pos(pos, dir), dir)
    end
  end

  defp push(map, pos, dir) do
    case Map.get(map, pos) do
      "." -> Map.put(map, pos, "O")
      _ -> push(map, next_pos(pos, dir), dir)
    end
  end

  def do_push(map, init_pos, dir) do
    push_pos = next_pos(init_pos, dir)

    map
    |> Map.put(init_pos, ".")
    |> Map.put(push_pos, "@")
    |> push(push_pos, dir)
  end

  def try_push(map, cur_pos, dir) do
    push_pos = next_pos(cur_pos, dir)

    if Day15Part1.is_pushable(map, push_pos, dir) do
      {Day15Part1.do_push(map, cur_pos, dir), push_pos}
    else
      {map, cur_pos}
    end
  end

  def inspect_map(map) do
    IO.write("\n")

    map
    |> Map.keys()
    |> Enum.sort(&(elem(&1, 1) < elem(&2, 1)))
    |> Enum.chunk_by(&elem(&1, 1))
    |> Enum.map_join("\n", fn row ->
      row
      |> Enum.sort(&(elem(&1, 0) < elem(&2, 0)))
      |> Enum.map_join("", &Map.get(map, &1))
    end)
    |> IO.puts()

    map
  end
end

# {:ok, text} = File.read("test1.txt")
# {:ok, text} = File.read("test2.txt")
{:ok, text} = File.read("input.txt")

[raw_map, raw_moves] = String.split(text, "\n\n")

{start_pos, map} =
  raw_map
  |> String.split("\n")
  |> Enum.with_index()
  |> Enum.reduce(%{}, fn {line, y}, map ->
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(map, fn {tile, x}, map ->
      new_map = Map.put(map, {x, y}, tile)

      if(tile === "@", do: Map.put(new_map, "@", {x, y}), else: new_map)
    end)
  end)
  |> Map.pop("@")

raw_moves
|> String.replace("\n", "")
|> String.graphemes()
|> Enum.reduce({map, start_pos}, fn move, {map, cur_pos} ->
  push_pos = Day15Part1.next_pos(cur_pos, move)

  case Day15Part1.inspect_map(map) |> Map.get(push_pos) do
    "#" -> {map, cur_pos}
    "." -> {Map.put(map, cur_pos, ".") |> Map.put(push_pos, "@"), push_pos}
    "O" -> Day15Part1.try_push(map, cur_pos, move)
  end
end)
|> elem(0)
|> Day15Part1.inspect_map()
|> Map.filter(fn {k, v} -> v === "O" end)
|> Map.keys()
|> Enum.map(fn {x, y} -> 100 * y + x end)
|> Enum.sum()
|> (&IO.puts("sum of GPS values is #{&1}")).()

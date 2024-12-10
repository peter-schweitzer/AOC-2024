#!/bin/elixir

defmodule Day08 do
  def p2vec({x_a, y_a}, {x_b, y_b}), do: {x_b - x_a, y_b - y_a}

  def calc({x1, y1}, {x2, y2}, op) do
    case op do
      :+ -> {x1 + x2, y1 + y2}
      :- -> {x1 - x2, y1 - y2}
    end
  end

  def pos_within_square?({x_p, y_p}, {x1, y1} \\ {0, 0}, {x2, y2}),
    do: x_p >= x1 and x_p <= x2 and y_p >= y1 and y_p <= y2

  def print_map_with_antinodes(map, nodes) do
    for {row, y} <- map |> Enum.with_index() do
      for {char, x} <- row |> Enum.with_index(), reduce: [] do
        acc ->
          c =
            cond do
              char != "." -> char
              {x, y} in nodes -> "#"
              true -> "."
            end

          [c | acc]
      end
      |> Enum.reverse()
      |> List.to_string()
      |> IO.puts()
    end
  end
end

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

raw_map = text |> String.split("\n") |> Enum.map(&String.graphemes/1)

max_y = (raw_map |> length) - 1
max_x = (raw_map |> hd |> length) - 1

antenna_map =
  for {row, y} <- raw_map |> Enum.with_index(),
      {tile, x} <- row |> Enum.with_index(),
      reduce: %{} do
    map ->
      case tile do
        "." -> map
        _ -> Map.update(map, tile, [{x, y}], &[{x, y} | &1])
      end
  end

anti_nodes =
  for f <- Map.keys(antenna_map), reduce: [] do
    anti_nodes ->
      f_locations = Map.get(antenna_map, f)
      last_locs_idx = (f_locations |> length) - 1

      location_map =
        f_locations
        |> Enum.with_index()
        |> Enum.reduce(%{}, &Map.put(&2, elem(&1, 1), elem(&1, 0)))

      for idx1 <- 0..(last_locs_idx - 1), reduce: anti_nodes do
        anti_nodes ->
          for idx2 <- (idx1 + 1)..last_locs_idx, reduce: anti_nodes do
            anti_nodes ->
              p1 = Map.get(location_map, idx1)
              p2 = Map.get(location_map, idx2)
              vec = Day08.p2vec(p1, p2)

              node_pos1 = Day08.calc(p2, vec, :+)
              node_pos2 = Day08.calc(p1, vec, :-)

              append_if_within_square =
                &if(Day08.pos_within_square?(&2, {max_x, max_y}),
                  do: [&2 | &1],
                  else: &1
                )

              anti_nodes
              |> append_if_within_square.(node_pos1)
              |> append_if_within_square.(node_pos2)
          end
      end
  end
  |> Enum.uniq()

raw_map |> Day08.print_map_with_antinodes(anti_nodes)
node_count = anti_nodes |> length()
IO.puts("\nfound #{node_count} tiles with antinodes on map")

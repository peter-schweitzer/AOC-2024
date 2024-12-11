#!/bin/elixir

defmodule Day09Part1 do
  def parse_disk_map(disk_map), do: parse_disk_map([], [0 | disk_map], 0)

  def parse_disk_map(parsed, [], id) do
    IO.puts("parsed #{id} files into #{length(parsed)} blocks")
    parsed
  end

  def parse_disk_map(parsed, [free_blk_cnt | [file_blk_cnt | map_rest]], id) do
    IO.puts("parsing file #{id}")

    (parsed ++
       List.duplicate({:free, nil}, free_blk_cnt) ++
       List.duplicate({:allocated, id}, file_blk_cnt))
    |> parse_disk_map(map_rest, id + 1)
  end

  def swap(list, idx1, idx2) do
    a = Enum.at(list, idx1)
    b = Enum.at(list, idx2)
    List.replace_at(list, idx1, b) |> List.replace_at(idx2, a)
  end

  def compress(map), do: compress(map, 0, length(map) - 1)

  def compress(map, start_ptr, end_ptr) when start_ptr >= end_ptr, do: map

  def compress(map, start_ptr, end_ptr) do
    case Enum.at(map, start_ptr) do
      {:allocated, _} ->
        compress(map, start_ptr + 1, end_ptr)

      {:free, nil} ->
        case Enum.at(map, end_ptr) do
          {:free, nil} ->
            compress(map, start_ptr, end_ptr - 1)

          {:allocated, id} ->
            IO.puts("moving allocated block #{end_ptr} (file #{id}) to free block #{start_ptr}")

            List.replace_at(map, start_ptr, {:allocated, id})
            |> List.replace_at(end_ptr, {:free, nil})
            |> compress(start_ptr + 1, end_ptr - 1)
        end
    end
  end

  def calc_check_sum(disk_map) do
    disk_map
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn {{state, id}, idx}, acc ->
      if(state === :allocated, do: {:cont, acc + id * idx}, else: {:halt, acc})
    end)
  end
end

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

text
|> String.graphemes()
|> Enum.map(&String.to_integer/1)
|> Day09Part1.parse_disk_map()
|> Day09Part1.compress()
|> Day09Part1.calc_check_sum()
|> (&IO.puts("checksum of compressed disk is #{&1}")).()

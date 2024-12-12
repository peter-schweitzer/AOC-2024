#!/bin/elixir

defmodule Day09Part2 do
  def parse_disk_map(disk_map), do: parse_disk_map([], [0 | disk_map], 0)

  def parse_disk_map(parsed, [], id) do
    IO.puts("parsed #{id} files into #{length(parsed)} blocks")
    parsed |> Enum.reverse()
  end

  def parse_disk_map(parsed, [free_blk_cnt | [file_blk_cnt | map_rest]], id) do
    IO.puts("parsing file #{id}")

    [{:allocated, file_blk_cnt, id} | [{:free, free_blk_cnt, nil} | parsed]]
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
  end

  def calc_check_sum(disk_map) do
    disk_map
    |> Enum.with_index()
    |> Enum.reduce(0, fn {{state, len, id}, idx}, sum ->
      case state do
        :allocated -> Enum.reduce(0..(len - 1), sum, &(&2 + id * (idx + &1)))
        :free -> sum
      end
    end)
  end
end

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

text
|> String.graphemes()
|> Enum.map(&String.to_integer/1)
|> Day09Part2.parse_disk_map()
|> Day09Part2.compress()
|> Day09Part2.calc_check_sum()
|> (&IO.puts("checksum of compressed disk is #{&1}")).()

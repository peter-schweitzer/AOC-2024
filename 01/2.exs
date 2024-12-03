#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

{l1, l2} = for line <- text |> String.split("\n"), reduce: {[], []} do {list1, list2} ->
  [entry1 | [entry2]] = line |> String.split("   ") |> Enum.map(&String.to_integer(&1))
  {[entry1 | list1], [entry2 | list2]}
end

freq = l2 |> Enum.frequencies

for entry <- l1, reduce: 0 do acc ->
  acc + entry * Map.get(freq, entry, 0)
end |> IO.inspect

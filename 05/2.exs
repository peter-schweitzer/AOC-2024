#!/bin/elixir

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

[raw_rules|[raw_updates]] = text |> String.split("\n\n")

rules = raw_rules
  |> String.split("\n")
  |> Enum.map(fn r -> r
    |> String.split("|")
    |> Enum.map(&String.to_integer(&1))
  end)

updates = raw_updates
  |> String.split("\n")
  |> Enum.map(&(String.split(&1, ",")))
  |> Enum.map(fn update -> update
    |> Enum.map(&(String.to_integer(&1)))
  end)

page_idx_maps = updates
  |> Enum.map(fn update -> update
    |> Enum.with_index
    |> Enum.reduce(%{}, &(Map.put(&2, elem(&1, 0), elem(&1, 1))))
  end)

invalid_updates = page_idx_maps
  |> Enum.with_index
  |> Enum.filter(fn {page_idx_map, _} -> rules
    |> Enum.reduce(false, fn [a|[b]], t -> t or Map.get(page_idx_map, a, -1) > Map.get(page_idx_map, b, 100) end)
  end)
  |> Enum.map(&Enum.at(updates, elem(&1, 1)))

rule_sort_map = rules
  |> Enum.reduce(%{}, fn [a|[b]], map -> Map.put(map, a, [b | Map.get(map, a, [])]) end)

fixed_updates = invalid_updates |> Enum.map(fn update -> update
  |> Enum.sort(&(&1 in Map.get(rule_sort_map, &2, [])))
end)


fixed_updates
  |> Enum.map(fn update -> update
    |> Enum.at(update |> length |> div(2))
  end)
  |> Enum.sum
  |> IO.inspect

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
  |> IO.inspect

valid_updates = for {page_idx_map, pages_idx} <- page_idx_maps |> Enum.with_index, reduce: [] do valid_updates ->
  update_satisfies_rules = for [a|[b]] <- rules, reduce: true do t ->
    a_idx = Map.get(page_idx_map, a, nil)
    b_idx = Map.get(page_idx_map, b, nil)

    t and ((a_idx == nil or b_idx == nil) or a_idx < b_idx)
  end

  if(update_satisfies_rules, do: [pages_idx | valid_updates], else: valid_updates)
end
  |> Enum.map(&(Enum.at(updates, &1)))
  |> Enum.map(fn update -> update
    |> Enum.at(update |> length |> div(2))
  end)
  |> Enum.sum
  |> IO.inspect

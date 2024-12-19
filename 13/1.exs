#!/bin/elixir

defmodule Day13Part1 do
  defp add(a, b), do: %{:x => a.x + b.x, :y => a.y + b.y}
  defp sub(a, b), do: %{:x => a.x - b.x, :y => a.y - b.y}
  defp mul(a, λ), do: %{:x => a.x * λ, :y => a.y * λ}
  defp eq(a, b), do: a.x === b.x and a.y === b.y
  defp calc_point(a, b, λ, μ), do: add(mul(a, λ), mul(b, μ))

  def calc_tokens(λ, μ) do
    tokens = 3 * λ + μ
    IO.puts("λ: #{λ}, µ: #{μ} (#{tokens} tokens)")

    tokens
  end

  defp calc_coefficient(p, v), do: min(div(p.x, v.x), div(p.y, v.y))

  def find_optimal_buttons({a, b, p}) do
    find_optimal_buttons(a, b, p, calc_coefficient(p, b))
  end

  def find_optimal_buttons(_, _, _, μ) when μ < 0, do: 0

  def find_optimal_buttons(a, b, p, μ) when μ >= 0 do
    λ = calc_coefficient(sub(p, mul(b, μ)), a)

    if(eq(calc_point(a, b, λ, μ), p)) do
      calc_tokens(λ, μ)
    else
      find_optimal_buttons(a, b, p, μ - 1)
    end
  end
end

# {:ok, text} = File.read("test.txt")
{:ok, text} = File.read("input.txt")

text
|> String.split("\n\n")
|> Enum.map(fn text ->
  text
  |> String.split("\n")
  |> Enum.map(fn line ->
    [x, y] =
      line
      |> String.split(": ")
      |> Enum.at(1)
      |> String.split(", ")
      |> Enum.map(&(String.split_at(&1, 2) |> elem(1) |> String.to_integer()))

    %{:x => x, :y => y}
  end)
  |> List.to_tuple()
end)
|> Enum.map(&Day13Part1.find_optimal_buttons/1)
|> IO.inspect()
|> Enum.sum()
|> IO.inspect()

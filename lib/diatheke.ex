defmodule Diatheke do

  @moduledoc """
  This library is a wrapper of the diatheke command-line client of the sword project.
  """

  @doc "Returns a list of installed sword modules."
  def mods do
    call("system", "modulelistnames") |> String.split(~r/\n/) |> Enum.reject(&(&1 == ""))
  end

  @doc """
  Returns a list of maps for the verses of the given key.
  ## Examples
      iex> Diatheke.passage("KJV", "Jh 1:1-3")
      [%{key: "John 1:1",
         text: "In the beginning was the Word, and the Word was with God, and the Word was God."},
       %{key: "John 1:2", text: "The same was in the beginning with God."},
       %{key: "John 1:3",
         text: "All things were made by him; and without him was not any thing made that was made."}]
  """
  def passage(mod, key) do
    call(mod, key) |> parse_passage
  end

  defp call(mod, key) do
    System.cmd("diatheke", ["-b", mod, "-k", key], []) |> parse_res
  end

  defp parse_res({res, 0}) do
    res
  end

  defp parse_res(_) do
    raise "Error"
  end

  defp parse_passage(str) do
    l = String.split(str, ~r/\n\n+/) |> Enum.drop(-1)
    Enum.map(l, &(gen_verse(&1)))
  end

  defp gen_verse(line) do
    [k, t] = String.split(line, ": ", parts: 2)
    %{key: k, text: t}
  end

end

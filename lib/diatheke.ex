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

  @doc """
  Returns a list of keys (as binary) of the search hits.
  ## Examples
  Search phrase:
      iex> Diatheke.search("KJV", "with God", range: "Joh 1")
      ["John 1:1", "John 1:2"]
  Search multiword:
      iex> Diatheke.search("KJV", ~w(God Jesus), range:  "Joh 1")
      ["John 1:29", "John 1:36"]
  """
  def search(mod, key, opts\\%{}) do
    new_opts = case key do
      phrase when is_binary(phrase) -> Dict.merge(opts, search: "phrase")
      words when is_list(words) -> Dict.merge(opts, search: "multiword")
      regex -> if Regex.regex?(regex) do
        Dict.merge(opts, search: "regex")
      else
        raise "Error"
      end

    end
    _search(mod, format_key(key), new_opts)
  end

  defp _search(mod, key, opts) do
    call(mod, key, gen_args(opts))
    |> parse_search
  end

  defp call(mod, key, args\\[]) when is_binary(key) do
    System.cmd("diatheke", List.flatten(["-b", mod, args, "-k", key]), []) |> parse_res
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

  defp parse_search(str) do
    a = String.split(str, ~r/\s*--\s*/)
    if Enum.count(a) == 3 do
      a |> Enum.drop(1) |> List.first |> String.split(~r/\s*;\s*/)
    else
      []
    end
  end

  defp gen_args(opts) do
    args = []
    if r = opts[:range] do
      args = ["-r", r | args]
    end
    if s = opts[:search] do
      args = ["-s", s | args]
    end
    args
  end

  defp format_key(key) when is_binary(key) do
    key
  end

  defp format_key(key) when is_list(key) do
    Enum.join(key, " ")
  end

  defp format_key(key) do
    if Regex.regex?(key) do
      Regex.source(key)
    else
      raise "Error"
    end
  end

end

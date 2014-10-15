defmodule DiathekeTest do
  use ExUnit.Case

  test "mods" do
    assert Enum.member?(Diatheke.mods, "KJV")
    assert ! Enum.member?(Diatheke.mods, "")
  end

  test "passage" do
    res = Diatheke.passage("KJV", "Joh 1:1-3")
    assert ["John 1:1", "John 1:2", "John 1:3"] = (Enum.map(res, &(Dict.get(&1, :key))) |> Enum.sort)
    [%{text: text} | _] = res
    assert text =~ ~r/^In the beginning was the Word/
  end

  test "search phrase" do
    res = Diatheke.search("KJV", "with God", range: "Joh 1")
    assert ["John 1:1", "John 1:2"] = res
  end

  test "search multiword" do
    res = Diatheke.search("KJV", ~w(God Jesus), range:  "Joh 1")
    assert ["John 1:29", "John 1:36"] = res
  end

  test "search regex" do
    res = Diatheke.search("KJV", ~r/Jesus.+Jesus/, range: "Joh 1")
    assert ["John 1:42"] = res
  end

  test "correct split with colon in text" do
    [res | _]  = Diatheke.passage("KJV", "Joh 1:39")
    assert "John 1:39" = res[:key]
    text = "He saith unto them, Come and see. They came and saw where he dwelt, and abode with him that day: for it was about the tenth hour."
    assert text == res[:text]
  end

  test "correct split on line break in text" do
    res = Diatheke.passage("KJV", "Joh 1:15")
    assert ["John 1:15"] = Enum.map(res, &(&1[:key]))
  end

end

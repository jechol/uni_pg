defmodule UniPgTest do
  use ExUnit.Case
  doctest UniPg

  test "greets the world" do
    assert UniPg.hello() == :world
  end
end

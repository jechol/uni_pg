defmodule UniPgTest do
  use ExUnit.Case
  doctest UniPg

  setup do
    other = spawn_link(Process, :sleep, [:infinity])
    other2 = spawn_link(Process, :sleep, [:infinity])
    {:ok, %{other: other, other2: other2}}
  end

  test "join/leave/get_members", %{other: other, other2: other2} do
    this = self()
    :ok = UniPg.join(:scope1, :group1, [this, other])
    :ok = UniPg.join(:scope1, :group2, [other2])
    :ok = UniPg.join(:scope2, :group2, [other2])

    [^this, ^other] = UniPg.get_members(:scope1, :group1)
    [^this, ^other] = UniPg.get_local_members(:scope1, :group1)

    :ok = UniPg.leave(:scope1, :group1, [other])
    [^this] = UniPg.get_members(:scope1, :group1)
    [^this] = UniPg.get_local_members(:scope1, :group1)

    [:group1, :group2] = UniPg.which_groups(:scope1)
  end
end

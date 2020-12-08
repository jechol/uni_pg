defmodule UniPg.Pg2.Test do
  use ExUnit.Case
  doctest UniPg

  setup do
    other = spawn_link(Process, :sleep, [:infinity])
    other2 = spawn_link(Process, :sleep, [:infinity])
    {:ok, %{other: other, other2: other2}}
  end

  if Code.ensure_loaded?(:pg2) do
    test "join/leave/get_members", %{other: other, other2: other2} do
      this = self()
      :ok = UniPg.Pg2.join(:scope1, :group1, [this, other])
      :ok = UniPg.Pg2.join(:scope1, :group2, [other2])
      :ok = UniPg.Pg2.join(:scope2, :group2, [other2])

      [^this, ^other] = UniPg.Pg2.get_members(:scope1, :group1)
      [^this, ^other] = UniPg.Pg2.get_local_members(:scope1, :group1)

      :ok = UniPg.Pg2.leave(:scope1, :group1, [other])
      [^this] = UniPg.Pg2.get_members(:scope1, :group1)
      [^this] = UniPg.Pg2.get_local_members(:scope1, :group1)

      [:group1, :group2] = UniPg.Pg2.which_groups(:scope1)
    end
  end
end

defmodule UniPg do
  @type scope :: atom()
  @type group :: any()

  @callback start_link(scope) :: {:ok, pid()}
  @callback join(scope, group, list(pid())) :: :ok
  @callback leave(scope, group, list(pid())) :: :ok
  @callback get_local_members(scope, group) :: list(pid())
  @callback get_members(scope, group) :: list(pid())
  @callback which_groups(scope) :: list(group())

  impl = if Code.ensure_loaded?(:pg), do: UniPg.Pg, else: UniPg.Pg2

  defdelegate start_link(scope), to: impl
  defdelegate join(scope, group, pids), to: impl
  defdelegate leave(scope, group, pids), to: impl
  defdelegate get_local_members(scope, group), to: impl
  defdelegate get_members(scope, group), to: impl
  defdelegate which_groups(scope), to: impl
end

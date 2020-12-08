defmodule UniPg.Pg do
  def join(scope, group, pids) when is_list(pids) do
    {:ok, _} = ensure_started(scope)
    :pg.join(scope, group, pids)
  end

  def leave(scope, group, pids) when is_list(pids) do
    {:ok, _} = ensure_started(scope)
    :pg.leave(scope, group, pids)
  end

  def get_local_members(scope, group) do
    {:ok, _} = ensure_started(scope)
    :pg.get_local_members(scope, group)
  end

  def get_members(scope, group) do
    {:ok, _} = ensure_started(scope)
    :pg.get_members(scope, group)
  end

  def which_groups(scope) do
    {:ok, _} = ensure_started(scope)
    :pg.which_groups(scope)
  end

  # Util

  defp ensure_started(scope) do
    # Duplicated :pg.start_link() has no effect and takes only 1ns.
    :pg.start_link(scope)
  end
end

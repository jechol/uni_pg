defmodule UniPg do
  if Code.ensure_loaded?(:pg) do
    defp pg_members(adapter_name) do
      :pg.get_members(Phoenix.PubSub, adapter_name)
    end

    defp pg_join(adapter_name) do
      :ok = :pg.join(Phoenix.PubSub, adapter_name, self())
    end
  else
    defp pg_members(adapter_name) do
      :pg2.get_members(pg2_namespace(adapter_name))
    end

    defp pg_join(adapter_name) do
      namespace = pg2_namespace(adapter_name)
      :ok = :pg2.create(namespace)
      :ok = :pg2.join(namespace, self())
      :ok
    end

    defp pg2_namespace(adapter_name), do: {:phx, adapter_name}
  end

  # pg2

  def create(group)
  def delete(group)

  def get_local_members(group)
  def get_members(group)

  def join(group, pid)
  def leave(group, pid)

  def start()
  def which_groups()

  # pg

  # unified

  if Code.ensure_loaded?(:pg) do
    # Use pg
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
  else
    # Fallback to :pg2

    def join(scope, group, pids) when is_list(pids) do
      ensure_group_created(scope, group)

      pids
      |> Enum.each(fn pid ->
        :pg2.join({scope, group}, pid)
      end)

      :ok
    end

    def leave(scope, group, pids) when is_list(pids) do
      ensure_group_created(scope, group)

      pids
      |> Enum.each(fn pid ->
        :pg2.leave({scope, group}, pid)
      end)

      :ok
    end

    def get_local_members(scope, group) do
      ensure_group_created(scope, group)
      :pg2.get_local_members(namespace(scope, group))
    end

    def get_members(scope, group) do
      ensure_group_created(scope, group)
      :pg2.get_members(namespace(scope, group))
    end

    def which_groups(scope) do
      ensure_started()

      for [group] <- :ets.match(:pg2_table, {{:group, {scope, :"$1"}}}) do
        group
      end
    end

    # Utils

    defp ensure_group_created(scope, group) do
      ensure_started()
      # Duplicated :pg2.create() has no effect and takes only 1ns.
      :pg2.create(namespace(scope, group))
    end

    defp ensure_started() do
      # Duplicated :pg2.start_link() has no effect and takes only 1ns.
      :pg2.start_link()
    end

    defp namespace(scope, group), do: {scope, group}
  end
end

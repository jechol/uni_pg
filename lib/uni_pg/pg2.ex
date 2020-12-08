defmodule UniPg.Pg2 do
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

  defp ensure_started() do
    # Duplicated :pg2.start_link() has no effect and takes only 5us.
    :pg2.start()
  end

  defp ensure_group_created(scope, group) do
    ensure_started()
    # Duplicated :pg2.create() has no effect and takes only 5us.
    :pg2.create(namespace(scope, group))
  end

  defp namespace(scope, group), do: {scope, group}
end

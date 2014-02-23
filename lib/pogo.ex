defmodule Pogo do
  def alive?(node) do
    :net_adm.ping(node) == :pong
  end

  def alive!(node) do
    unless alive?(node), do: exit(1)
    exit(0)
  end

  def stop(node, timeout \\ 5000) do
    rpc(node, :init, :stop, timeout)
  end

  def restart(node, timeout \\ 10000) do
    rpc(node, :init, :restart, timeout)
  end

  def reboot(node, timeout \\ 10000) do
    rpc(node, :init, :reboot, timeout)
  end

  defp rpc(node, mod, fun, args \\ [], timeout) do
    case :rpc.call(node, mod, fun, args, timeout) do
      :ok ->
        wait_for_node(node, timeout)
        halt(0)
      { :badrpc, :nodedown } ->
        halt(1)
    end
  end

  defp wait_for_node(node, timeout) do
    wait_for_node(node, 1, 0, timeout)
  end

  defp wait_for_node(_, _, acc_wait, timeout) when acc_wait >= timeout do
    halt(1)
  end

  defp wait_for_node(node, interval, acc_wait, timeout) do
    if alive?(node) do
      pid = self
      ref = make_ref
      :erlang.send_after(interval, pid, { pid, ref })
      receive do
        { ^pid, ^ref } ->
          acc_wait = acc_wait + interval
          wait_for_node(node, interval, acc_wait, timeout)
      end
    end
  end

  defp halt(status), do: System.halt(status)
end

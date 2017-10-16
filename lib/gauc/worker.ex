defmodule Gauc.Worker do
  @moduledoc """
  Gauc Worker - Poolboy Worker
  """

  use GenServer

  require Logger

  alias Gauc.Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, [])
  end

  def init(state) do
    Process.flag(:trap_exit, true)

    url = state[:url]

    case Client.connect(url) do
      {:ok, handle} -> {:ok, [handle: handle]}
      err -> {:err, err}
    end
  end

  def handle_call({:add, id, doc}, _from, state) do
    {:reply, Client.add(state[:handle], id, doc), state}
  end

  def handle_call({:append, id, doc}, _from, state) do
    {:reply, Client.append(state[:handle], id, doc), state}
  end

  def handle_call({:get, id}, _from, state) do
    {:reply, Client.get(state[:handle], id), state}
  end

  def handle_call({:prepend, id, doc}, _from, state) do
    {:reply, Client.prepend(state[:handle], id, doc), state}
  end

  def handle_call({:remove, id}, _from, state) do
    {:reply, Client.remove(state[:handle], id), state}
  end

  def handle_call({:replace, id, doc}, _from, state) do
    {:reply, Client.replace(state[:handle], id, doc), state}
  end

  def handle_call({:set, id, doc}, _from, state) do
    {:reply, Client.set(state[:handle], id, doc), state}
  end

  def handle_call({:upsert, id, doc}, _from, state) do
    # IO.inspect(doc)
    {:reply, Client.upsert(state[:handle], id, doc), state}
  end

  def handle_call({:stop, reason, new_state}, _from, _state) do
    IO.puts("Stopping")
    {:stop, reason, new_state}
  end

  def handle_info({:EXIT, _pid, _reason}, state) do
    IO.puts "exit"
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    IO.puts "down"
    {:noreply, state}
  end

  def handle_info(msg, _from, state) do
    Logger.debug(msg)

    {:noreply, state}
  end

  def handle_cast(msg, _from, state) do
    Logger.debug(msg)
    {:noreply, state}
  end

  def terminate(reason, state) do
    Logger.debug fn() ->
      "#{__MODULE__} - terminate(), reason: #{inspect(reason)}, state: #{inspect(state)}"
    end

    Client.disconnect(state[:handle])
  end
end

#defmodule PoolboyApp.Test do
#  @timeout 60000
#
#  def start do
#    1..10_000
#    |> Enum.each(fn(i) -> async_call_insert(i) end)
#    # |> Enum.each(fn(task) -> await_and_inspect(task) end)
#
#    :ok
#  end
#
#  defp async_call_insert(i) do
#    Task.async(fn ->
#      :poolboy.transaction(:worker,
#        fn(pid) ->
#          GenServer.call(pid, {:upsert, "#{i - i}", "{}"})
#        end,
#        @timeout
#      )
#    end)
#  end
#
#  defp await_and_inspect(task) do
#    task
#    |> Task.await(@timeout)
#    |> IO.inspect()
#  end
#end

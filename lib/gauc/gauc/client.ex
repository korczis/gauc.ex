defmodule Gauc.Client do
  @moduledoc """
  Couchbase Client
  """

  alias Gauc.Native

  @doc """
  Connects to couchbase server.

  Returns `{:ok, handle}`.

  ## Examples

      iex> Gauc.Client.connect("couchbase://localhost/default")
      {:ok, {2804783613, 1738359100}}

  """
  def connect(connection_string) do
    Native.connect(connection_string)
  end

  @doc """
  Disconnects from couchbase server.

  Returns `{:ok, handle}`.

  ## Examples

      iex(1)> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default")
      {:ok, {2804783613, 1738359100}}
      iex(2)> Gauc.Client.disconnect(handle)
      {:ok, {2804783613, 1738359100}}

  """
  def disconnect(handle) do
    Native.disconnect(handle)
  end

  @doc """
  Returns list of handles (clients).

  Returns `{:ok, clients}`.

  ## Examples

      iex(1)> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default")
      {:ok, {2804783613, 1738359100}}
      iex(2)> Gauc.Client.clients()
      {:ok, [{{167799369, 732711453}, "couchbase://localhost/default"}]}

  """
  def clients do
    Native.clients()
  end

  def add(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.add(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end

  def append(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.append(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end

  def get(handle, id) do
    Native.get(handle, id)
  end

  def prepend(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.prepend(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end

  def replace(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.replace(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end

  def set(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.set(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end

  def upsert(handle, id, payload, opts \\ [cas: 0, exptime: 0]) do
    Native.upsert(
      handle,
      id,
      payload,
      opts[:cas] || 0,
      opts[:exptime] || 0
    )
  end
end

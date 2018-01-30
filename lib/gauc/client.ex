defmodule Gauc.Client do
  @moduledoc """
  Couchbase Client
  """

  alias Gauc.Native

  @default_uri "couchbase://localhost/default"
  @default_opts [cas: 0, exptime: 0]

  def resource_make() do
    Native.resource_make()
  end

  @doc """
  Connects to couchbase server.

  Returns `{:ok, handle}`.

  ## Examples

      iex> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default", "Administrator", "Administrator")
      {:ok, {2804783613, 1738359100}}

  """
  def connect(uri \\ @default_uri, username \\ "Administrator", password \\ "Administrator") do
    {:ok, handle} = Native.connect(uri, username, password)
  end

  @doc """
  Disconnects from couchbase server.

  Returns `{:ok, handle}`.

  ## Examples

      iex(1)> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default", "Administrator", "Administrator")
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

      iex(1)> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default", "Administrator", "Administrator")
      {:ok, {2804783613, 1738359100}}

      iex(2)> Gauc.Client.clients()
      {:ok, [{{167799369, 732711453}, "couchbase://localhost/default"}]}

  """
  def clients do
    Native.clients()
  end

  def add(handle, id, payload, opts \\ default_opts()) do
    store(:add, handle, id, payload, opts)
  end

  def append(handle, id, payload, opts \\ default_opts()) do
    store(:append, handle, id, payload, opts)
  end

  def get(handle, id) do
    Native.get(handle, id)
  end

  def prepend(handle, id, payload, opts \\ default_opts()) do
    store(:prepend, handle, id, payload, opts)
  end

  def remove(handle, id, opts \\ default_opts()) do
    Native.remove(handle, id)
  end

  def replace(handle, id, payload, opts \\ default_opts()) do
    store(:replace, handle, id, payload, opts)
  end

  def set(handle, id, payload, opts \\ default_opts()) do
    store(:set, handle, id, payload, opts)
  end

  def store(op, handle, id, payload, opts \\ default_opts()) do
    f = case op do
      :add -> &Native.add/5
      :append -> &Native.append/5
      :prepend -> &Native.prepend/5
      :replace -> &Native.replace/5
      :set -> &Native.set/5
      :upsert -> &Native.upsert/5
    end

    cas = opts[:cas] || @default_opts[:cas]
    exptime = opts[:exptime] || @default_opts[:exptime]

    f.(handle, id, payload, cas, exptime)
  end

  def upsert(handle, id, payload, opts \\ default_opts()) do
    store(:upsert, handle, id, payload, opts)
  end

  defp default_opts do
    @default_opts
  end

  def query_bucket() do
    Stream.resource(
      # Init
      fn ->
        File.open!("mix.exs")
      end,
      # Next
      fn file ->
        case IO.read(file, :line) do
          data when is_binary(data) -> {[data], file}
          _ -> {:halt, file}
        end
      end,
      # Close
      fn file ->
        File.close(file)
      end
    )
  end

  def query_view(handle, ddoc, name) do
    Native.query_view(handle, ddoc, name)
  end
end

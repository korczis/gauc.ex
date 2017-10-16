defmodule Gauc.Native do
  @moduledoc false

  use Rustler, otp_app: :gauc, crate: :gauc

  @spec connect(String.t()) :: {:atom, any()}
  def connect(_uri), do: throw :nif_not_loaded

  def disconnect(_handle), do: throw :nif_not_loaded

  def clients, do: throw :nif_not_loaded
  def add(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
  def append(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
  def get(_handle, _id), do: throw :nif_not_loaded
  def prepend(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
  def remove(_handle, _id), do: throw :nif_not_loaded
  def replace(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
  def set(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
  def upsert(_handle, _id, _payload, _cas, _exptime), do: throw :nif_not_loaded
end

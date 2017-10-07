defmodule Gauc.Native do
  @moduledoc """
  Native extensions (using rustler)
  """

  use Rustler, otp_app: :gauc, crate: :gauc

  def connect(_connection_string), do: throw :nif_not_loaded
  def disconnect(_handle), do: throw :nif_not_loaded

  def add(_handle, _a, _b), do: throw :nif_not_loaded
  def append(_handle, _a, _b), do: throw :nif_not_loaded
  def get(_handle, _a), do: throw :nif_not_loaded
  def prepend(_handle, _a, _b), do: throw :nif_not_loaded
  def replace(_handle, _a, _b), do: throw :nif_not_loaded
  def set(_handle, _a, _b), do: throw :nif_not_loaded
  def upsert(_handle, _a, _b), do: throw :nif_not_loaded

end

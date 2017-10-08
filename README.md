# Gauc

Elixir Wrapper for Gauc - Rust Wrapper of Couchbase

## Status

[![Build Status](https://travis-ci.org/korczis/gauc.ex.svg?branch=master)](https://travis-ci.org/korczis/gauc.ex)
[![Hex version](https://img.shields.io/hexpm/v/gauc.svg "Hex version")](https://hex.pm/packages/gauc)
[![Hex.pm](https://img.shields.io/hexpm/dt/gauc.svg)](https://hex.pm/packages/gauc)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/korczis/gauc.ex/master/LICENSE)

## Features

- Elixir/Erlang friendly way to access Couchbase
## Prerequisites

- [elixir](https://elixir-lang.org/) - dynamic, functional language designed for building scalable and maintainable applications
- [rust](https://www.rust-lang.org/en-US/) - systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

1. Add `gauc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:gauc, "~> x.x.x"}]
end
```

2. Ensure `gauc` is started:

```elixir
def application do
  [applications: [:gauc]]
end
```

hexdocs: https://hexdocs.pm/gauc

## Configuration

```elixir
config :gauc, Gauc,
  url: "couchbase://localhost/default",
  pool: [
    size: 2,
    max_overflow: 4
  ]
```

## Example

*This section may be outdated, see official examples instead.*

### Worker API

### Client API

```elixir
iex(1)> {:ok, handle} = Gauc.Client.connect("couchbase://localhost/default")
{:ok, {3138101329, 3409854531}}

iex(2)> {:ok, id, cas} = Gauc.Client.upsert(handle, "123", "{}")
{:ok, "123", 1507499098051444736}

iex(3)> {:ok, res} = Gauc.Client.get(handle, "123")
{:ok, "{}"}
```

### Native API

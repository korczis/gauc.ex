# Gauc

Elixir Wrapper for Gauc - Rust Wrapper of Couchbase

## Status

[![Build Status](https://travis-ci.org/korczis/gauc.ex.svg?branch=master)](https://travis-ci.org/korczis/gauc.ex)

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

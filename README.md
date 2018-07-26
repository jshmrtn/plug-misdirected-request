# Misdirected Request Plug

[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/jshmrtn/plug-misdirected-request/master/LICENSE)
[![Hex.pm Version](https://img.shields.io/hexpm/v/plug_misdirected_request.svg?style=flat)](https://hex.pm/packages/plug_misdirected_request)

If multiple HTTP/2 applications with the same TLS certificate are built, the
browser tries to open all of the domains using the same connection. If there is
a TLS Passthrough Load Balancer in Front, this will result in a request that is
sent to the wrong application.

To solve this, a response of `421 Misdirected Request` can be sent and the
browser will retry using a new connection.

## Installation

The package can be installed by adding `plug_misdirected_request` to your list
of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_misdirected_request, "~> 1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). The docs can be found at
[https://hexdocs.pm/plug_misdirected_request](https://hexdocs.pm/plug_misdirected_request).

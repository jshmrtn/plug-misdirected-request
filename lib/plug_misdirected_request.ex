defmodule PlugMisdirectedRequest do
  @moduledoc """
  Add this plug to your pipeline.

  ### Configuration

  The plug can be included with either a given domain or with
  the option `auto` (`phoenix` only).

      plug(PlugMisdirectedRequest, domain: "whitelisted.domain.com")

      plug(PlugMisdirectedRequest, domain: :auto, endpoint: MyApp.Endpoint)

  """

  @behaviour Plug

  import Plug.Conn

  require Logger

  if(Code.ensure_compiled?(Phoenix.Endpoint)) do
    def init(opts) do
      opts
      |> Enum.into(%{})
      |> case do
        %{endpoint: endpoint_module, domain: :auto} when is_atom(endpoint_module) ->
          if Code.ensure_compiled?(endpoint_module) and
               function_exported?(endpoint_module, :config, 2) do
            opts
          else
            raise "The specified `endpoint` is not a phoenix endpoint"
          end

        %{domain: :auto} ->
          raise "For the domain strategy auto, an endpoint has to be specified"

        %{domin: domain} = opts when is_binary(domain) ->
          opts
      end
    end
  else
    def init(opts) do
      opts
      |> Enum.into(%{})
      |> case do
        %{domain: :auto} ->
          raise "For the domain strategy auto, phoenix has to be installed"

        %{domin: domain} = opts when is_binary(domain) ->
          opts
      end
    end
  end

  def call(conn, opts) do
    conn
    |> get_http_protocol
    |> call(conn, opts)
  end

  defp call(:"HTTP/2", conn = %{host: host}, %{domain: :auto, endpoint: endpoint}) do
    :url
    |> endpoint.config([])
    |> Keyword.get(:host, nil)
    |> case do
      ^host ->
        conn

      _ ->
        conn
        |> send_resp(:misdirected_request, "Misdirected Request")
        |> halt
    end
  end

  defp call(:"HTTP/2", conn = %{host: host}, %{domain: domain}) when is_binary(domain) do
    case domain do
      ^host ->
        conn

      _ ->
        conn
        |> send_resp(:misdirected_request, "Misdirected Request")
        |> halt
    end
  end

  defp call(_, conn, _opts) do
    conn
  end
end

defmodule PlugMisdirectedRequestTest do
  @moduledoc false

  use ExUnit.Case, async: false
  use Plug.Test

  import Mock

  doctest PlugMisdirectedRequest

  defmodule Endpoint do
    use Phoenix.Endpoint, otp_app: :plug_misdirected_request
  end

  setup do
    start_supervised!(Endpoint)

    :ok
  end

  describe "init" do
    test "domain auto only works with endpoint" do
      assert_raise RuntimeError, fn ->
        PlugMisdirectedRequest.init(domain: :auto)
      end
    end

    test "domain auto only works with valid endpoint" do
      assert_raise RuntimeError, fn ->
        PlugMisdirectedRequest.init(domain: :auto, endpoint: Foo)
      end

      assert PlugMisdirectedRequest.init(domain: :auto, endpoint: Endpoint)
    end
  end

  describe "call" do
    test_with_mock "skips HTTP/1", Plug.Conn, [:passthrough],
      get_http_protocol: fn _ -> :"HTTP/1.1" end do
      conn = Map.put(conn(:get, "/"), :host, "www.example.com")

      assert conn == PlugMisdirectedRequest.call(conn, %{domain: "foo"})
    end

    test_with_mock "checks with HTTP/2", Plug.Conn, [:passthrough],
      get_http_protocol: fn _ -> :"HTTP/2" end do
      conn = Map.put(conn(:get, "/"), :host, "www.example.com")

      assert %{
               halted: true,
               status: 421
             } = PlugMisdirectedRequest.call(conn, %{domain: "foo"})
    end

    test_with_mock "valid with same domain HTTP/2", Plug.Conn, [:passthrough],
      get_http_protocol: fn _ -> :"HTTP/2" end do
      conn = Map.put(conn(:get, "/"), :host, "www.example.com")

      assert conn == PlugMisdirectedRequest.call(conn, %{domain: "www.example.com"})
    end

    test_with_mock "checks with HTTP/2 auto", Plug.Conn, [:passthrough],
      get_http_protocol: fn _ -> :"HTTP/2" end do
      conn = Map.put(conn(:get, "/"), :host, "foo")

      assert %{
               halted: true,
               status: 421
             } = PlugMisdirectedRequest.call(conn, %{domain: :auto, endpoint: Endpoint})
    end

    test_with_mock "valid with same domain HTTP/2 auto", Plug.Conn, [:passthrough],
      get_http_protocol: fn _ -> :"HTTP/2" end do
      conn = Map.put(conn(:get, "/"), :host, "www.example.com")

      assert conn == PlugMisdirectedRequest.call(conn, %{domain: :auto, endpoint: Endpoint})
    end
  end
end

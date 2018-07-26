use Mix.Config

config :plug_misdirected_request, PlugMisdirectedRequestTest.Endpoint,
  url: [host: "www.example.com"]

config :plug_misdirected_request, PlugMisdirectedRequestTest.EndpointWithoutEndpoint,
  url: [host: "www.example.com"]

config :plug_misdirected_request, PlugMisdirectedRequestTest.EndpointInvalidEndpoint,
  url: [host: "www.example.com"]

config :plug_misdirected_request, PlugMisdirectedRequestTest.EndpointValidEndpoint,
  url: [host: "www.example.com"]

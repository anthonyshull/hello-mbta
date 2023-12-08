import Config

config :dotcom_sdk, DotcomSdk.Cache,
  conn_opts: [
    host: "127.0.0.1",
    port: 6379
  ]

config :tesla, MBTA.Connection,
  middleware: [
    {Tesla.Middleware.BaseUrl, System.get_env("V3_API_URL")},
    {Tesla.Middleware.Headers, [{"x-api-key", System.get_env("V3_API_KEY")}]}
  ]

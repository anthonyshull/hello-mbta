# HelloMbta

This is an example app using the [DotcomSdk](https://github.com/anthonyshull/dotcom-sdk) and [MbtaSdk](https://github.com/anthonyshull/mbta-sdk).

## Dependencies

You'll need to have access to Redis.

```shell
%> docker run -d -p 6379:6379 --name redis redis
```

## Configuration

You'll need to set two environment variables as defined in `./config`:

```shell
V3_API_KEY=
V3_API_URL=
```

## Usage

You can run this application in `iex`.

```shell
%> iex -S mix
```

Use the function defined in `./lib/hello_mbta/hello_mbta.ex` to get information on an MBTA stop.

```elixir
iex> HelloMbta.get_stop("place-sstat")
```

Go a level deeper to ask the DotcomSdk for the same information.
It will check the cache you configured before looking for the information upstream.

```elixir
iex> client = MBTA.Connection.new()
iex> DotcomSdk.Cache.Stop.api_web_stop_controller_show(client, "place-sstat").data.attributes
```

If you want to avoid the cache entirely you can go deeper into the MbtaSdk.

```elixir
iex> MBTA.Api.Stop.api_web_stop_controller_show(client, "place-sstat") |> Kernel.elem(1) |> Map.from_struct() |> Map.get(:data) |> Map.from_struct() |> Map.get(:attributes)
```

Notice that the `MBTA.Api.Stop` and `DotcomSdk.Cache.Stop` methods are are exactly alike.
There is a one to one mapping between the two libraries.
The only difference is the caching layer.

Because the cache is shared, the first call to `DotcomSdk.Cache.Stop...` will prime the cache for *all* callers...even in separate processes.
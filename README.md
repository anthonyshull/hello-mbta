# HELLO MBTA

This is an example app using the [DOTCOM SDK](https://github.com/anthonyshull/dotcom-sdk) and [MBTA SDK](https://github.com/anthonyshull/mbta-sdk).

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

Go a level deeper to ask the DOTCOM SDK for the same information.
It will check the cache you configured before looking for the information upstream.

```elixir
iex> client = MBTA.Connection.new()
iex> DOTCOM.Api.Stop.api_web_stop_controller_show(client, "place-sstat").data.attributes
```

If you want to avoid the cache entirely you can go deeper into the MBTA SDK.

```elixir
iex> MBTA.Api.Stop.api_web_stop_controller_show(client, "place-sstat")
  |> Kernel.elem(1)
  |> Map.from_struct()
  |> Map.get(:data)
  |> Map.from_struct()
  |> Map.get(:attributes)
```

## Discussion

Notice that the `MBTA.Api.Stop` and `DOTCOM.Api.Stop` have exactly the same functions down to the arity.
That's because there is a bijective (one-to-one) mapping between the two libraries.
The only difference is the caching layer.

Having a single, external, shared entrypoint into the cache has several benefits:

1. Data is consistent no matter which process requests it (think round robin.)
2. The cache stays primed through an application restart.
3. The work of one process (getting upstream data from the source of record) benefits all processes.
4. It is easy to update or even flush the cache.
5. Application memory load is dramatically decreased. Basically, it is punted to the cache...which is optimized for precisely that workload.
6. Application complexity is dramatically decreased. You get to delete a lot of code.

Having a single entrypoint doesn't mean having single point of failure any more than using a relational database base does.
You can run Redis however you see fit...cluster mode, sentinel mode, etc.

Now, the drawback.
In-memory caches are incredibly fast.
Instead of making a bus hop, using an external cache means having to make a network hop (within the same data center, most likely.)
But, unless your application does rebalancing, sharding, etc. (basically turn it into Redis) the extra few milliseconds of latency incured is worth the benefits outlined above.
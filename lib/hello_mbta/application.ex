defmodule HelloMbta.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DOTCOM.Api.Stop
    ]

    opts = [strategy: :one_for_one, name: HelloMbta.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

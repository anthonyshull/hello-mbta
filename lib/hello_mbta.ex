defmodule HelloMbta do
  @moduledoc false

  alias DOTCOM.Api.Stop

  @client MBTA.Connection.new()

  def get_stop(id) do
    Stop.api_web_stop_controller_show(@client, id).data.attributes
  end
end

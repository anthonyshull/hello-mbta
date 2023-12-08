defmodule HelloMbtaTest do
  use ExUnit.Case
  doctest HelloMbta

  test "greets the world" do
    assert HelloMbta.hello() == :world
  end
end

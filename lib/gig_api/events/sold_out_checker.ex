defmodule GigApi.Events.SoldOutChecker do
  use GenServer
  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_init_arg) do
    Phoenix.PubSub.subscribe(GigApi.PubSub, "events")
    {:ok, %{}}
  end

  def handle_info({:ticket_purchased, event}, state) do
    if event.status == "sold_out" do
      Logger.info("Event #{event.name} is sold out!!")
    end

    {:noreply, state}
  end
end

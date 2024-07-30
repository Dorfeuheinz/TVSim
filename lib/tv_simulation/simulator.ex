defmodule TvSimulation.Simulator do
  use GenServer

  @channels [:zdf, :rtl, :prosieben, :vox, :das_erste, :none]

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def get_stats do
    GenServer.call(__MODULE__, :get)
  end

  def update_tuple(acc, channel, index, duration) do
    current_tuple = Map.get(acc, channel)
    original_duration = elem(current_tuple, index)
    updated_tuple = put_elem(current_tuple, index, original_duration + duration)
    Map.put(acc, channel, updated_tuple)
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    initial_state = for i <- 1..100, do: %{user_id: i, channel: Enum.random(@channels), duration: Enum.random(1..120)}
    stats =  Map.new(@channels, fn x -> {x, List.to_tuple(for _ <- 1..100, do: 0)} end)
    schedule_updates()
    {:ok, {initial_state, stats, 0}}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {_, stats, counter} = state
    # Logger.info(stats)
    data = Enum.reduce(stats, "", fn {key, val}, acc ->
      val = val
            |> Tuple.to_list()
            |> Enum.join(" ")
      acc <> "#{key}: #{val}, "
    end)
    {:reply, data, state}
  end

  @impl true
  def handle_info(:update, state) do
    {initial_state, stats, counter} = state

    views = Enum.filter(initial_state, fn x -> x[:duration] -1 == rem(counter, 120) end)

    stats = Enum.reduce(views, stats, fn %{duration: duration, user_id: user_id, channel: channel}, acc ->
      update_tuple(acc, channel, user_id - 1, duration)
    end)


    initial_state = Enum.map(initial_state, fn map ->
      if map[:duration] -1 == rem(counter, 120) do
        map
        |> Map.replace(:duration, Enum.random(1..120) )
        |> Map.replace(:channel, Enum.random([:zdf, :rtl, :prosieben, :vox, :das_erste, :none]) )
      else
        map
      end
    end)

    # keep updating values every minute
    schedule_updates()
    {:noreply, {initial_state, stats, counter + 1}}
  end

  defp schedule_updates do
    Process.send_after(self(), :update, 1000)
  end
end

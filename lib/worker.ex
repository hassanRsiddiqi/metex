defmodule Metex.Worker do
  use GenServer
  @name MW
  # Client API
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: MW])
  end

  def get_temp(location) do
    GenServer.call(@name, {:location, location})
  end

  def get_stats() do
    GenServer.call(@name, :get_stats)
  end

  def reset_stats() do
    GenServer.cast(@name, :reset_stats)
  end

  def stop() do
    GenServer.cast(@name, :stop)
  end
  def terminate(reason, stats) do
    IO.puts "server terminated beaause of reason #{inspect reason}"
    inspect stats
    :ok
  end
  # Server API
  def init(:ok) do
    {:ok, %{}}
  end
  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}°C", new_stats}
      _ ->
        {:reply, :errors, stats}
    end
  end
  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end
  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end
  def handle_cast(:stop, stats) do
    {:stop, :normal, :ok, stats}
  end
  def handle_info(msg, stats) do
    IO.puts "received #{inspect msg}"
    {:noreply, stats}
  end
  ## Helper Functions.
  @spec temperature_of(any) :: <<_::64, _::_*8>>
  def temperature_of(location) do
    url_for(location)
    |> HTTPoison.get
    |> parse
  end

  defp url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey()}"
  end
  defp apikey() do
    "1859b4fbf0af1712a060a40a6f244e3b"
  end
  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body
    |> JSON.decode!
    |> compute_temp
  end
  defp parse(_) do
    :error
  end
  def compute_temp(data) do
    try do
      temp = (data["main"]["temp"] - 273.15)
      |>Float.round(1)
    {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 + 1))
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end
 end

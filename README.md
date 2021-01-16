# Weather API

**METEX**
is my first concurrent Application in elixir, which uses Actor, Worker & Coordinator.

### How to use

Clone the Project `git clone "https://github.com/hassanRsiddiqi/metex"`

goto branch `genServer`
goto project directory & run `iex -S mix`

#### Start Server

```
Metex.Worker.start_link
# {:ok, #PID<0.635.0>}
```

#### Get Temp

```
Metex.Worker.get_temp "Multan"
# "16.0°C"

Metex.Worker.get_temp "Multan"
# "16.0°C"
```

#### Get & Reset Stats

```
Metex.Worker.get_stats
# %{"Multan" => 2}
Metex.Worker.reset_stats
# :ok

Metex.Worker.get_stats
# %{}
```

#### Terminate Server

```
Metex.Worker.stop
# server terminated because of reason :normal
:ok
```

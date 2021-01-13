# Weather API

**METEX**
is my first concurrent Application in elixir, which uses Actor, Worker & Coordinator.

### How to use

Clone the Project `git clone "https://github.com/hassanRsiddiqi/metex"`

goto project directory & run `iex -S mix`

```
cities = ["Multan","Singapore", "Monaco", "Vatican City", "Hong Kong", "Macau"]
Metex.temp cities
```

Response

```
:ok
Hong Kong 12.74, Macau 12.42, Monaco 10.72, Multan 13.0, Singapore 24.33, Vatican City 11.25
```

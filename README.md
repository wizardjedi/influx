InfluxDB client
---------------

InfluxDB client to drop data to InfluxDB using UDP protocol. The line encoder is shamelessly
ripped from https://github.com/palkan/influx_udp.

It has no external dependencies, and is dead simple.

To use you need to include the application into rebar dependencies as follows:
```
...
{deps, [
...
    {influx, ".*", {git, "https://github.com/jamhed/influx.git", "master"}}
]}.
...
```

There are two application parameters, influx_host and influx_port, with default set to
"127.0.0.1" and 4444, respectively.

API
---

```
influx:send(cpu, [{value,80}]).
influx:send(cpu, [{value,80},{another,123}]).
```
will become an influx "measurement" string "cpu value=80" and "cpu value=80,another=123".

-module(influx).
-export([send/2]).

send(Measurement, Fields) ->
	influx_udp:send( influx_line:encode_simple(Measurement, Fields) ).
-module(influx).
-export([send/2, send/3, send/4]).

send(Measurement, Fields) ->
	influx_udp:send( influx_line:encode_simple(Measurement, Fields) ).

send(Measurement, Fields, Tags) ->
	influx_udp:send(influx_line:encode(Measurement, Fields, Tags)).

send(Measurement, Fields, Tags, Timestamp) ->
	influx_udp:send(influx_line:encode(Measurement, Fields, Tags, Timestamp)).

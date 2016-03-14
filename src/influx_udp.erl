-module(influx_udp).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0, start_link/2, send/2, send/1]).
-include_lib("kernel/include/inet.hrl").
 
-record(state, {
	socket,
	target_host,
	target_port
}).

% interface

start_link() ->
	Host = application:get_env(influx, influx_host, "127.0.0.1"),
	Port = application:get_env(influx, influx_port, 4444),
	start_link(Host, Port).
start_link(TargetHost, TargetPort) -> gen_server:start_link({local, influx}, ?MODULE, [TargetHost, TargetPort], []).

send(Data) -> send(influx, Data).

send(Self, Data) ->
	gen_server:cast(Self, {send, Data}).

% implementation

resolve_host(Name) ->
   {ok, #hostent{h_addr_list=[Host|_]}} = inet:gethostbyname(Name),
   Host.

init([TargetHostStr, TargetPort]) ->
	{ok, Socket} = gen_udp:open(0, [binary, {active,true}]),
	TargetHost = resolve_host(TargetHostStr),
	{ok, #state{
			socket = Socket,
			target_host = TargetHost,
			target_port = TargetPort
		}
	}.

handle_cast({send, Data}, S=#state{ socket=Socket, target_host=Host, target_port=Port}) ->
	gen_udp:send(Socket, Host, Port, Data),
	{noreply, S};

handle_cast(_Msg, S=#state{}) -> {noreply, S}.
handle_info(_Info, S=#state{}) -> {noreply, S}.
handle_call(_Request, _From, S=#state{}) -> {reply, ok, S}.
terminate(_Reason, _S) -> ok.
code_change(_OldVsn, S=#state{}, _Extra) -> {ok, S}.

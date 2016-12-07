-module(ap).
-behaviour(application).
-export([start/0, start/2, stop/0, stop/1]).

start() ->
	try
		application:start(ap)
	after
		timer:sleep(100)
	end.

start(_, _) ->
	{ok, SupPid} = ap_sup:start_link([]),
	{ok, SupPid}.


stop() ->
	try
		application:stop(ap)
	after
		timer:sleep(100)
	end.

stop(_) ->
	ok.
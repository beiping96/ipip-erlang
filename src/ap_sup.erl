-module(ap_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(Args) ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
	{ok, {{one_for_one, 50, 1}, []}}.
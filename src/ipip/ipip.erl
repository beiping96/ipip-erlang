%%%----------------------------------------------------------------------
%%% @Module 	: ipip.erl
%%% @Author 	: duxingrui <beiping96@gmail.com>
%%% @Created 	: 2016.12.12
%%% @doc
%%%  	ipip.net ip解析
%%%
%%%		ipip数据 '/priv/17monipdb.dat'
%%% 	
%%% @end
%%%----------------------------------------------------------------------
-module(ipip).

-export([init/0]).

-define(DAT, '../priv/17monipdb.dat').

init() ->
	init(?DAT).

init(FileDAT) ->
	{ok, IoDevice} = file:open(FileDAT, [read ,{encoding, utf8}]),
	init(IoDevice, 0),
	complie()
		file:read_line(IoDevice)

get(S) ->
	S.

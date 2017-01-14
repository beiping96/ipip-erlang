%%%----------------------------------------------------------------------
%%% @Module 	: ipip.erl
%%% @Author 	: duxingrui <beiping96@gmail.com>
%%% @Created 	: 2016.12.12
%%% @doc
%%%  	ipip.net ip解析
%%%
%%%		ipip数据 './priv/17monipdb.dat'
%%% 	
%%% @end
%%%----------------------------------------------------------------------
-module(ipip).

-include_lib("kernel/include/inet.hrl").
-include_lib("kernel/include/file.hrl").

-export([init/0]).
-export([get/1, get/4]).

-define(DAT, "./priv/17monipdb.dat").

%%----------------------------------------------------------------------
%% @doc 	通过17monipdb.dat生成data_ip.erl
%% @spec 	init() -> ok
%% @end
%%----------------------------------------------------------------------
init() ->
	init(?DAT).
init(FileDAT) ->
	{ok, IoDevice} = file:open("./src/data_ipip.erl", [write, {encoding, utf8}]),
	{ok, FileBin} = file:read_file(FileDAT),
	{ok, #file_info{atime = Atime, mtime = Mtime, ctime = Ctime}} = file:read_file_info(FileDAT),
	io:put_chars(IoDevice, "%%%----------------------------------------------------------------------\n"),
	io:put_chars(IoDevice, "%%% @Module 		: data_ipip.erl\n"),
	io:put_chars(IoDevice, "%%% @Author 		: AutoCreate <beiping96@gmail.com>\n"),
	io:put_chars(IoDevice, io_lib:format("%%% @Created 		: ~p-~p-~p ~p:~p:~p~n", tuple_to_list(date()) ++ tuple_to_list(time()))),
	io:put_chars(IoDevice, "%%% @doc\n"),
	io:put_chars(IoDevice, "%%%     ipip.net 解析 \n"),
	io:put_chars(IoDevice, "%%%		17monipdb.dat Generate To data_ipip.erl\n"),
	io:put_chars(IoDevice, "%%%\n"),
	io:put_chars(IoDevice, "%%% 	17monipdb.dat INFO\n"),
	io:put_chars(IoDevice, io_lib:format("%%% 		atime:~p ~n", [Atime])),
	io:put_chars(IoDevice, io_lib:format("%%% 		mtime:~p ~n", [Mtime])),
	io:put_chars(IoDevice, io_lib:format("%%% 		ctime:~p ~n", [Ctime])),
	io:put_chars(IoDevice, "%%% @end\n"),
	io:put_chars(IoDevice, "%%%----------------------------------------------------------------------\n"),
	file:write(IoDevice, "-module(data_ipip).\n\n"),
	file:write(IoDevice, "-export([get/4]).\n\n"),
	init(IoDevice, FileBin),
	file:write(IoDevice, "get(_A, _B, _C, _D) -> \" \".\n\n"),
	file:close(IoDevice).
init(IoDevice, FileBin) ->
	<<MaxCommentLen:32, DataBin/binary>> = FileBin,
	{_NoUseIndexBin, IpIndexAndCommentBin} = erlang:split_binary(DataBin, 256 * 4),
	init(IoDevice, IpIndexAndCommentBin, MaxCommentLen, FileBin, byte_size(FileBin)).
init(IoDevice, <<A:8, B:8, C:8, D:8, CommentStart:3/little-unsigned-unit:8, CommentLen:8, CommentIndexBin/binary>>, MaxCommentLen, FileBin, FileSize) ->
	CommentStartTrue = MaxCommentLen + CommentStart - 1024,
	case FileSize >= CommentStartTrue of
		true ->
			{_NoUseBin, StartBin} = erlang:split_binary(FileBin, CommentStartTrue),
			{Bin, _LeftNoUseBin} = erlang:split_binary(StartBin, CommentLen),
			io:put_chars(IoDevice, io_lib:format("get(~p,~p,~p,~p) -> \"", [A, B, C, D]) ++ [Bin] ++ "\";\n"),
			init(IoDevice, CommentIndexBin, MaxCommentLen, FileBin, FileSize);
		false ->
			is_end
	end.

%%----------------------------------------------------------------------
%% @doc 	查找IP地址
%% @spec 	get("A.B.C.D") -> String
%% 			get(A, B, C, D) -> String
%% @end
%%----------------------------------------------------------------------
get(IpStr) ->
    {ok,#hostent{h_addr_list = [IpTemp |_]}} = inet:gethostbyname(IpStr),
    IpTempTemp = inet:ntoa(IpTemp),
    [AStr, BStr, CStr, DStr | _] = string:tokens(IpTempTemp, "."),
    get(erlang:list_to_integer(AStr), erlang:list_to_integer(BStr), erlang:list_to_integer(CStr), erlang:list_to_integer(DStr)).

get(A, B, C, D) ->
	data_ipip:get(A, B, C, D).

%%%----------------------------------------------------------------------
%%% @doc
%%% 		Private Functions
%%% @end
%%%----------------------------------------------------------------------

	
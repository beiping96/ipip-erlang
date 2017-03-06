%%% @author duxingrui <beiping96@gmail.com>
%%% @version 20170306.01
%%% @doc
%%% 	ipip.net ip解析
%%% 
%%% 	ipip数据 '../priv/17monipdb.dat'
-module(ipip).

-include_lib("kernel/include/inet.hrl").
-include_lib("kernel/include/file.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([init/0]).
-export([get/1, get/4]).

-export_type([ipv4/0]).

-define(DAT, "../priv/17monipdb.dat").

-type ipv4() :: 0..255.

%% @doc 通过17monipdb.dat生成data_ip.erl
-spec init() -> any().
init() ->
	init(?DAT).

-spec init(string()) -> any().
init(FileDAT) ->
	{ok, IoDevice} = file:open("../src/data_ipip.erl", [write, {encoding, utf8}]),
	{ok, FileBin} = file:read_file(FileDAT),
	{ok, #file_info{atime = Atime, mtime = Mtime, ctime = Ctime}} = file:read_file_info(FileDAT),
	io:put_chars(IoDevice, "%%% @author AutoCreate <beiping96@gmail.com>\n"),
	io:put_chars(IoDevice, io_lib:format("%%% @version ~p-~p-~p ~p:~p:~p~n", tuple_to_list(date()) ++ tuple_to_list(time()))),
	io:put_chars(IoDevice, "%%% @doc\n"),
	io:put_chars(IoDevice, "%%%     ipip.net 解析 \n%%% \n"),
	io:put_chars(IoDevice, "%%%		17monipdb.dat Generate To data_ipip.erl\n%%% \n"),
	io:put_chars(IoDevice, "%%% 	17monipdb.dat INFO\n"),
	FormatTime = fun({{Ye, Mo, Da}, {Ho, Mi, Se}}) -> io_lib:format("~p-~p-~p ~p:~p:~p", [Ye, Mo, Da, Ho, Mi, Se]) end,
	io:put_chars(IoDevice, "%%% <ol>\n"),
	io:put_chars(IoDevice, "%%% 		<li>A time: " ++ FormatTime(Atime) ++ "</li>\n"),
	io:put_chars(IoDevice, "%%% 		<li>C time: " ++ FormatTime(Ctime) ++ "</li>\n"),
	io:put_chars(IoDevice, "%%% 		<li>M time: " ++ FormatTime(Mtime) ++ "</li>\n"),
	io:put_chars(IoDevice, "%%% </ol>\n"),
	io:put_chars(IoDevice, "-module(data_ipip).\n\n"),
	io:put_chars(IoDevice, "-export([get/4]).\n\n"),
	io:put_chars(IoDevice, "%% @doc 查找IP地址\n"),
	io:put_chars(IoDevice, "-spec get(ipip:ipv4(), ipip:ipv4(), ipip:ipv4(), ipip:ipv4()) -> string().\n"),
	init(IoDevice, FileBin),
	io:put_chars(IoDevice, "get(_A, _B, _C, _D) -> \" \".\n"),
	file:close(IoDevice).

-spec init(pid(), binary()) -> any().
init(IoDevice, FileBin) ->
	<<MaxCommentLen:32, DataBin/binary>> = FileBin,
	{_NoUseIndexBin, IpIndexAndCommentBin} = erlang:split_binary(DataBin, 256 * 4),
	init(IoDevice, IpIndexAndCommentBin, MaxCommentLen, FileBin, byte_size(FileBin)).

-spec init(pid(), binary(), pos_integer(), binary(), pos_integer()) -> any().
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

%% @doc 查找IP地址
-spec get(string()) -> string().
get(IpStr) ->
	{ok,#hostent{h_addr_list = [IpTemp |_]}} = inet:gethostbyname(IpStr),
	IpTempTemp = inet:ntoa(IpTemp),
	[AStr, BStr, CStr, DStr | _] = string:tokens(IpTempTemp, "."),
	?MODULE:get(erlang:list_to_integer(AStr), erlang:list_to_integer(BStr), erlang:list_to_integer(CStr), erlang:list_to_integer(DStr)).
%% @doc 查找IP地址
-spec get(ipv4(), ipv4(), ipv4(), ipv4()) -> string().
get(A, B, C, D) ->
	data_ipip:get(A, B, C, D).

%% @hidden EUnit
get_test() ->
	?MODULE:get("255.255.255.255") =:= ?MODULE:get(255, 255, 255, 255).

%%%-------------------------------------------------------------------
%%% @author martin.bucinskas
%%% @copyright (C) 2020, martin.bucinskas
%%% @doc
%%%
%%% @end
%%% Created : 14. Jan 2020 16:40
%%%-------------------------------------------------------------------
-module(timezone_offsets).
-author("martin.bucinskas").

%% API
-export([start/1, get_timezone_offset/1]).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Loads up the timezone offsets data into the ETS table.
%%
%% @end
%%--------------------------------------------------------------------
start(TimezoneOffsetData) ->
  ets:new(timezone_offset_table, [public, set, named_table, {read_concurrency,  true}, {write_concurrency, true}]),
  {ok, File} = file:read_file(TimezoneOffsetData),
  Lines = [binary_to_list(Binary) || Binary <- binary:split(File, <<"\n">>, [global]), Binary =/= << >>],
  ParsedLines = lists:map(
    fun(Str) -> string:tokens(Str, "\t") end, Lines
  ),
  loop_through_each_entry(ParsedLines).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Recursion in Erlang, this loops through the list and executes a
%% function store_row with the HEAD as the argument, recursing with
%% the tail as the new argument.
%%
%% @end
%%--------------------------------------------------------------------
loop_through_each_entry([]) -> finished_parsing_file;
loop_through_each_entry([H|T]) ->
  store_row(H),
  loop_through_each_entry(T).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Stores a row inside ETS.
%%
%% @end
%%--------------------------------------------------------------------
store_row([]) -> empty1;
store_row(Row) ->
  TimezoneId = lists:nth(2, Row),
  Offset = lists:nth(3, Row),
  ets:insert(timezone_offset_table, {TimezoneId, Offset}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Performs a lookup on the ETS table.
%%
%% @end
%%--------------------------------------------------------------------
get_timezone_offset(TimezoneId) ->
  ets:lookup(timezone_offset_table, TimezoneId).

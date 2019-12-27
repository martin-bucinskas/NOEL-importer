%%%-------------------------------------------------------------------
%%% @author martin.bucinskas
%%% @copyright (C) 2019, martin.bucinskas
%%% @doc
%%%
%%% @end
%%% Created : 27. Dec 2019 10:30
%%%-------------------------------------------------------------------
-module(geonames_timezone).
-author("martin.bucinskas").

%% API
-export([get_timezone_from_locid/1, get_full_entry/1]).

start() ->
  ets:new(geonames_table, [geonames_table, protected, set, {keypos, 1}]).

get_timezone_from_locid(LocationId) ->
  Entry = get_full_entry(LocationId),
  LocationId.

get_full_entry(LocationId) ->
  {ok, File} = file:read_file("cities500.txt"),
  Lines = [binary_to_list(Binary) || Binary <- binary:split(File, <<"\n">>, [global]), Binary =/= << >>],
  ParsedLines = lists:map(
    fun(Str) -> string:tokens(Str, "\t") end, Lines
  ),
  lists:foreach(fun([K,V]) -> io:format("K: ~p V: ~p~n", [K, V]) end, ParsedLines).

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
-export([get_timezone_from_locid/1]).

start() ->
  ets:new(geonames_table, [set, named_table]),
  {ok, File} = file:read_file("cities500.dat"),
  Lines = [binary_to_list(Binary) || Binary <- binary:split(File, <<"\n">>, [global]), Binary =/= << >>],
  ParsedLines = lists:map(
    fun(Str) -> string:tokens(Str, "\t") end, Lines
  ),
  loop_through_each_entry(ParsedLines).

loop_through_each_entry([]) -> ok;
loop_through_each_entry([H|T]) ->
  store_row(H),
  loop_through_each_entry(T).

store_row([]) -> ok;
store_row(Row) ->
  LocationID = lists:nth(1, Row),
  CityName = lists:nth(2, Row),
  Timezone = lists:nth(3, Row),
  ets:insert(geonames_table, {LocationID, CityName, Timezone}).

get_timezone_from_locid(LocationId) ->
  start(),
  ets:lookup(geonames_table, LocationId).

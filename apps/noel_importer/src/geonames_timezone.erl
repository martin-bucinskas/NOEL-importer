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
-export([start/1, get_timezone_from_locid/1]).

start(CitiesData) ->
  ets:new(geonames_table, [public, set, named_table]), %% F***ing public flag was not set!
  {ok, File} = file:read_file(CitiesData),
  Lines = [binary_to_list(Binary) || Binary <- binary:split(File, <<"\n">>, [global]), Binary =/= << >>],
  ParsedLines = lists:map(
    fun(Str) -> string:tokens(Str, "\t") end, Lines
  ),
  loop_through_each_entry(ParsedLines).

loop_through_each_entry([]) -> finished_parsing_file;
loop_through_each_entry([H|T]) ->
  store_row(H),
  loop_through_each_entry(T).

store_row([]) -> empty1;
store_row(Row) ->
  LocationID = lists:nth(1, Row),
  CityName = lists:nth(2, Row),
  Timezone = lists:nth(3, Row),
  ets:insert(geonames_table, {LocationID, CityName, Timezone}).

get_timezone_from_locid(LocationId) ->
  ListString = binary:bin_to_list(LocationId),
  ets:lookup(geonames_table, ListString).


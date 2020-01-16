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

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Loads up the cities data into the ETS table.
%%
%% @end
%%--------------------------------------------------------------------
start(CitiesData) ->
  ets:new(geonames_table, [public, set, named_table, {read_concurrency,  true}, {write_concurrency, true}]), %% F***ing public flag was not set!
  {ok, File} = file:read_file(CitiesData),
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
  LocationID = lists:nth(1, Row),
  CityName = lists:nth(2, Row),
  Timezone = lists:nth(3, Row),
  ets:insert(geonames_table, {LocationID, CityName, Timezone}).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Performs a lookup on the ETS table.
%%
%% @end
%%--------------------------------------------------------------------
get_timezone_from_locid(LocationId) ->
  ListString = binary:bin_to_list(LocationId),
  ets:lookup(geonames_table, ListString).


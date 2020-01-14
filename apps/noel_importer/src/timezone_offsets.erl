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
-export([start/0, get_timezone_offset_from_timezone/2]).

start() ->
  application:start(yamerl),
  inets:start().

get_timezone_offset_from_timezone(Timezone, APIKey) ->
  io:format("Timezone: ~p API_KEY: ~p~n", [Timezone, APIKey]),
  {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = httpc:request(get, {"http://api.timezonedb.com/v2.1/convert-time-zone?key=" ++ APIKey ++ "&format=json&from=" ++ Timezone ++ "&to=Europe/Helsinki", []}, [], []),
  Decoded = yamerl_constr:string(Body, [{schema, json}]),
  {_, Offset} = lists:last(lists:last(Decoded)),
  Offset.
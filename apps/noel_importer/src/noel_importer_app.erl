%%%-------------------------------------------------------------------
%% @doc noel_importer public API
%% @end
%%%-------------------------------------------------------------------

-module(noel_importer_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:start(cache),
    {ok, _} = cache:start_link(my_cache, [{n, 10}, {ttl, 60}]),
    noel_importer_sup:start_link().

stop(_State) ->
    ok.

%% internal functions

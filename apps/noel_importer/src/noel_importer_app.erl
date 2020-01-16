%%%-------------------------------------------------------------------
%% @doc noel_importer public API
%% @end
%%%-------------------------------------------------------------------

-module(noel_importer_app).

-behaviour(application).

-export([start/2, stop/1]).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Entry point of the application
%%
%% @end
%%--------------------------------------------------------------------
start(_StartType, _StartArgs) ->
    io:format("Starting Noel Importer Supervisor~n"),
    noel_importer_sup:start_link().

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Exit point of the application (this is your destructor if you're
%% familiar with C++ or similar).
%%
%% @end
%%--------------------------------------------------------------------
stop(_State) ->
    ok.

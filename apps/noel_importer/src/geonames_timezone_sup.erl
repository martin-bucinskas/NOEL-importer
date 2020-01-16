%%%-------------------------------------------------------------------
%% @doc noel_importer top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(geonames_timezone_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% The supervisor of geonames_timezone module.
%% Starts the module and keeps it alive, if it fails 2 in the space
%% 10 seconds, it will fail the program.
%%
%% @end
%%--------------------------------------------------------------------
init([]) ->
  SupFlags = #{strategy => one_for_all,
    intensity => 2,
    period => 10},
  ChildSpecs = [#{id => geonames_timezone, start => { geonames_timezone, start, ["resources/cities500.dat"]}}],
  {ok, {SupFlags, ChildSpecs}}.


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

init([]) ->
  SupFlags = #{strategy => one_for_all,
    intensity => 2,
    period => 10},
  ChildSpecs = [#{id => geonames_timezone, start => { geonames_timezone, start, ["resources/cities500.dat"]}}],
  {ok, {SupFlags, ChildSpecs}}.


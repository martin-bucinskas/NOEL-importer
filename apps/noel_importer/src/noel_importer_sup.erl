%%%-------------------------------------------------------------------
%% @doc noel_importer top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(noel_importer_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  io:format("Starting N.O.E.L. Importer!~n"),
  geonames_timezone:start("cities500.dat"),
  timezone_offsets:start("timezone_offset.dat"),
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 2,
                 period => 30},
    ChildSpecs = [#{id => noel_parser, start => { noel_parser, parse_directory, ["data"]}}],
    {ok, {SupFlags, ChildSpecs}}.

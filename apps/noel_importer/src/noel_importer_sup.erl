%%%-------------------------------------------------------------------
%% @doc noel_importer top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(noel_importer_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initialising the entire application.
%% Then starting the supervisor.
%%
%% @end
%%--------------------------------------------------------------------
start_link() ->
  io:format("Starting N.O.E.L. Importer!~n"),
  geonames_timezone:start("resources/cities500.dat"),
  timezone_offsets:start("resources/timezone_offset.dat"),
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% The Top Level Supervisor. If this fails, for some reason, then
%% either your program finished running or you're screwed.
%% If this fails, then it will bring every module down too.
%%
%% @end
%%--------------------------------------------------------------------
init([]) ->
    SupFlags = #{strategy => one_for_one,
                 intensity => 2,
                 period => 30},
    ChildSpecs = [#{id => noel_parser, start => { noel_parser, parse_directory, ["data"]}}],
    {ok, {SupFlags, ChildSpecs}}.

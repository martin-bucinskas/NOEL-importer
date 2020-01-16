%%%-------------------------------------------------------------------
%% @doc noel_importer top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(timezone_offsets_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional

%%--------------------------------------------------------------------
%% @private
%% @doc
%% The supervisor of timezone_offsets module.
%% Starts the module and keeps it alive, if it fails 2 in the space
%% 10 seconds, it will fail the program.
%%
%% @end
%%--------------------------------------------------------------------
init([]) ->
  SupFlags = #{strategy => one_for_all,
    intensity => 2,
    period => 10},
  ChildSpecs = [#{id => timezone_offsets, start => { timezone_offsets, start, []}}],
  {ok, {SupFlags, ChildSpecs}}.


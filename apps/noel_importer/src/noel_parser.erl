%%%-------------------------------------------------------------------
%%% @author martin.bucinskas
%%% @copyright (C) 2019, martin.bucinskas
%%% @doc
%%%
%%% @end
%%% Created : 26. Dec 2019 12:06
%%%-------------------------------------------------------------------
-module(noel_parser).
-author("martin.bucinskas").

%% API
-export([parse_directory/1, parse_file/1]).

parse_directory(Dirname) ->
  {ok, Filenames} = file:list_dir(Dirname),
  lists:foreach(fun(Filename) ->
                  io:format("Parsing ~p~n", [Filename]),
                  parse_file("data/" ++ Filename)
                end, Filenames).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called to read and parse an entire file.
%%
%% @end
%%--------------------------------------------------------------------
parse_file(FileName) ->
  io:format("FileName: ~p~n", [FileName]),
  {ok, Device} = file:open(FileName, [raw, {read_ahead, 1024}]),
  try get_all_lines(Device)
    after file:close(Device)
  end,
  io:format("Finished Parsing!~n").

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function reads a file line by line and parses the line
%% immediately.
%%
%% @end
%%--------------------------------------------------------------------
get_all_lines(Device) ->
%%  case io:get_line(Device, "") of
  case file:read_line(Device) of
    eof -> [];
    Line ->
      _ = get_all_lines(Device),
      parse_line(Line)
  end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function takes a line from the virtual card file and unpacks
%% the line into variables based on their length.
%%
%% @end
%%--------------------------------------------------------------------
parse_line(Line) ->
  {_, EntryLine} = Line,
  <<ID:80/bitstring, AGE:24/bitstring, LOCID:64/bitstring, CT:16/bitstring, L:8/bitstring, GIVEN:192/bitstring, FAMILY:192/bitstring, _Rest/bitstring>> = binary:list_to_bin(EntryLine),
  Packed = {ID, AGE, LOCID, CT, L, GIVEN, FAMILY},
  Pid = self(),

  spawn(fun() -> is_naughty_or_nice(Pid, L, AGE, GIVEN, FAMILY) end),
  spawn(fun() -> get_timezone_offset(Pid, LOCID) end),

  receive
    naughty ->
      receive
        {offset, Offset} ->
          FileName = "sorted/naughty_" ++ Offset ++ ".dat",
          write_to_file(FileName, Packed)
      end;
    nice ->
      receive
        {offset, Offset} ->
          FileName = "sorted/nice_" ++ Offset ++ ".dat",
          write_to_file(FileName, Packed)
      end
  end.

get_timezone_offset(Pid, LocId) ->
  Response = geonames_timezone:get_timezone_from_locid(LocId),

  {_LocId, _CityName, Zone} = lists:last(Response),
  {_, TimeOffset} = lists:last(timezone_offsets:get_timezone_offset(Zone)),
  Pid ! {offset, TimeOffset}.

write_to_file(FileName, Entry) ->
  {Id, Age, LocId, CT, L, Given, Family} = Entry,
  {ok, S} = file:open(FileName, [raw, append]),                                 %% By opening the file as raw
  file:write(S, list_to_binary([Id, Age, LocId, CT, L, Given, Family, "\n"])),  %% and using file write instead of
%%  io:format(S, "~s~s~s~s~s~s~s~n", [Id, Age, LocId, CT, L, Given, Family]),   %% io format, I was able to shave off 4 seconds.
  file:close(S).                                                                %% Erlang surprisingly does not complain about closing random string IODevices??????

is_naughty_or_nice(Pid, SentLetter, Age, GivenName, FamilyName) ->
  case SentLetter of
    <<"Y">> -> Pid ! nice;
    <<"N">> ->
      FullName = <<GivenName/bitstring, FamilyName/bitstring>>,
      Vowels = [C || <<C>> <= FullName, is_vowel(C)],
      Consonants = [C || <<C>> <= FullName, is_consonant(C)],
      Value = length(Consonants) - length(Vowels) + list_to_integer(binary:bin_to_list(Age)),
      if
        Value band 1 == 0 -> Pid ! nice;
        true -> Pid ! naughty
      end;
      _ -> Pid ! naughty
  end.

is_vowel(C) ->
  if
    C =:= $A -> true;
    C =:= $E -> true;
    C =:= $I -> true;
    C =:= $O -> true;
    C =:= $U -> true;
    true -> false
  end.

is_consonant(C) ->
  IsVowel = is_vowel(C),

  if
    IsVowel =:= true -> false;
    C =:= 32 -> false; %% ignore whitespace
    true -> true
  end.

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
-export([parse_directory/1, parse_file/2]).

parse_directory(Dirname) ->
  OutputDeviceMap = #{
    "naughty_0.0.dat" => file:open("sorted/naughty_0.0.dat", [raw, append]),
    "naughty_1.0.dat" => file:open("sorted/naughty_1.0.dat", [raw, append]),
    "naughty_2.0.dat" => file:open("sorted/naughty_2.0.dat", [raw, append]),
    "naughty_3.0.dat" => file:open("sorted/naughty_3.0.dat", [raw, append]),
    "naughty_4.0.dat" => file:open("sorted/naughty_4.0.dat", [raw, append]),
    "naughty_5.0.dat" => file:open("sorted/naughty_5.0.dat", [raw, append]),
    "naughty_5.5.dat" => file:open("sorted/naughty_5.5.dat", [raw, append]),
    "naughty_6.0.dat" => file:open("sorted/naughty_6.0.dat", [raw, append]),
    "naughty_7.0.dat" => file:open("sorted/naughty_7.0.dat", [raw, append]),
    "naughty_8.0.dat" => file:open("sorted/naughty_8.0.dat", [raw, append]),
    "naughty_9.0.dat" => file:open("sorted/naughty_9.0.dat", [raw, append]),
    "naughty_9.5.dat" => file:open("sorted/naughty_9.5.dat", [raw, append]),
    "naughty_10.0.dat" => file:open("sorted/naughty_10.0.dat", [raw, append]),
    "naughty_10.5.dat" => file:open("sorted/naughty_10.5.dat", [raw, append]),
    "naughty_11.0.dat" => file:open("sorted/naughty_11.0.dat", [raw, append]),
    "naughty_12.0.dat" => file:open("sorted/naughty_12.0.dat", [raw, append]),
    "naughty_13.0.dat" => file:open("sorted/naughty_13.0.dat", [raw, append]),
    "naughty_-1.0.dat" => file:open("sorted/naughty_-1.0.dat", [raw, append]),
    "naughty_-2.0.dat" => file:open("sorted/naughty_-2.0.dat", [raw, append]),
    "naughty_-3.0.dat" => file:open("sorted/naughty_-3.0.dat", [raw, append]),
    "naughty_-4.0.dat" => file:open("sorted/naughty_-4.0.dat", [raw, append]),
    "naughty_-5.0.dat" => file:open("sorted/naughty_-5.0.dat", [raw, append]),
    "naughty_-6.0.dat" => file:open("sorted/naughty_-6.0.dat", [raw, append]),
    "naughty_-7.0.dat" => file:open("sorted/naughty_-7.0.dat", [raw, append]),
    "naughty_-8.0.dat" => file:open("sorted/naughty_-8.0.dat", [raw, append]),
    "naughty_-9.0.dat" => file:open("sorted/naughty_-9.0.dat", [raw, append]),
    "naughty_-10.0.dat" => file:open("sorted/naughty_-10.0.dat", [raw, append]),
    "nice_0.0.dat" => file:open("sorted/nice_0.0.dat", [raw, append]),
    "nice_1.0.dat" => file:open("sorted/nice_1.0.dat", [raw, append]),
    "nice_2.0.dat" => file:open("sorted/nice_2.0.dat", [raw, append]),
    "nice_3.0.dat" => file:open("sorted/nice_3.0.dat", [raw, append]),
    "nice_4.0.dat" => file:open("sorted/nice_4.0.dat", [raw, append]),
    "nice_5.0.dat" => file:open("sorted/nice_5.0.dat", [raw, append]),
    "nice_5.5.dat" => file:open("sorted/nice_5.5.dat", [raw, append]),
    "nice_6.0.dat" => file:open("sorted/nice_6.0.dat", [raw, append]),
    "nice_7.0.dat" => file:open("sorted/nice_7.0.dat", [raw, append]),
    "nice_8.0.dat" => file:open("sorted/nice_8.0.dat", [raw, append]),
    "nice_9.0.dat" => file:open("sorted/nice_9.0.dat", [raw, append]),
    "nice_9.5.dat" => file:open("sorted/nice_9.5.dat", [raw, append]),
    "nice_10.0.dat" => file:open("sorted/nice_10.0.dat", [raw, append]),
    "nice_10.5.dat" => file:open("sorted/nice_10.5.dat", [raw, append]),
    "nice_11.0.dat" => file:open("sorted/nice_11.0.dat", [raw, append]),
    "nice_12.0.dat" => file:open("sorted/nice_12.0.dat", [raw, append]),
    "nice_13.0.dat" => file:open("sorted/nice_13.0.dat", [raw, append]),
    "nice_-1.0.dat" => file:open("sorted/nice_-1.0.dat", [raw, append]),
    "nice_-2.0.dat" => file:open("sorted/nice_-2.0.dat", [raw, append]),
    "nice_-3.0.dat" => file:open("sorted/nice_-3.0.dat", [raw, append]),
    "nice_-4.0.dat" => file:open("sorted/nice_-4.0.dat", [raw, append]),
    "nice_-5.0.dat" => file:open("sorted/nice_-5.0.dat", [raw, append]),
    "nice_-6.0.dat" => file:open("sorted/nice_-6.0.dat", [raw, append]),
    "nice_-7.0.dat" => file:open("sorted/nice_-7.0.dat", [raw, append]),
    "nice_-8.0.dat" => file:open("sorted/nice_-8.0.dat", [raw, append]),
    "nice_-9.0.dat" => file:open("sorted/nice_-9.0.dat", [raw, append]),
    "nice_-10.0.dat" => file:open("sorted/nice_-10.0.dat", [raw, append])
  },
  {ok, Filenames} = file:list_dir(Dirname),
  lists:foreach(fun(Filename) ->
                  io:format("Parsing ~p~n", [Filename]),
                  parse_file("data/" ++ Filename, OutputDeviceMap)
                end, Filenames),
  cleanup(OutputDeviceMap).

cleanup(OutputDeviceMap) ->
  io:format("Cleaning up! Closing the output file map!~n"),
  maps:fold(
    fun(_, V, ok) ->
      {ok, S} = V,
      file:close(S)
    end, ok, OutputDeviceMap).
%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called to read and parse an entire file.
%%
%% @end
%%--------------------------------------------------------------------
parse_file(FileName, OutputDeviceMap) ->
  case FileName of
    "data/.DS_Store" ->
      bad_file;
    _ ->
      io:format("FileName: ~p~n", [FileName]),
      {ok, Device} = file:open(FileName, [raw, {read_ahead, 1024}]),
      try get_all_lines(Device, OutputDeviceMap)
      after file:close(Device)
      end,
      io:format("Finished Parsing!~n")
  end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function reads a file line by line and parses the line
%% immediately.
%%
%% @end
%%--------------------------------------------------------------------
get_all_lines(Device, OutputDeviceMap) ->
%%  case io:get_line(Device, "") of
  case file:read_line(Device) of
    eof -> [];
    Line ->
      _ = get_all_lines(Device, OutputDeviceMap),
      parse_line(Line, OutputDeviceMap)
  end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function takes a line from the virtual card file and unpacks
%% the line into variables based on their length.
%%
%% @end
%%--------------------------------------------------------------------
parse_line(Line, OutputDeviceMap) ->
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
          Key = "naughty_" ++ Offset ++ ".dat",
          IODevice = maps:get(Key, OutputDeviceMap),
          write_to_file(IODevice, Packed)
      end;
    nice ->
      receive
        {offset, Offset} ->
          Key = "nice_" ++ Offset ++ ".dat",
          IODevice = maps:get(Key, OutputDeviceMap),
          write_to_file(IODevice, Packed)
      end
  end.

get_timezone_offset(Pid, LocId) ->
  Response = geonames_timezone:get_timezone_from_locid(LocId),

  {_LocId, _CityName, Zone} = lists:last(Response),
  {_, TimeOffset} = lists:last(timezone_offsets:get_timezone_offset(Zone)),
  Pid ! {offset, TimeOffset}.

write_to_file(IODevice, Entry) ->
%%  io:format("IODevice: ~p~n", [IODevice]),
  {Id, Age, LocId, CT, L, Given, Family} = Entry,
  {ok, S} = IODevice,
%%  {ok, S} = file:open(FileName, [raw, append]),                                 %% By opening the file as raw
  file:write(S, list_to_binary([Id, Age, LocId, CT, L, Given, Family, "\n"])).  %% and using file write instead of
%%  io:format(S, "~s~s~s~s~s~s~s~n", [Id, Age, LocId, CT, L, Given, Family]),   %% io format, I was able to shave off 4 seconds.
%%  file:close(S).                                                                %% Erlang surprisingly does not complain about closing random string IODevices??????

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

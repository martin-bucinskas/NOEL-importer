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
-export([parse_file/1]).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called to read and parse an entire file.
%%
%% @end
%%--------------------------------------------------------------------
parse_file(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device)
    after file:close(Device)
  end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function reads a file line by line and parses the line
%% immediately.
%%
%% @end
%%--------------------------------------------------------------------
get_all_lines(Device) ->
  case io:get_line(Device, "") of
    eof -> [];
    Line ->
      Line ++ get_all_lines(Device),
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
  <<ID:80/bitstring, AGE:24/bitstring, LOCID:64/bitstring, CT:16/bitstring, L:8/bitstring, GIVEN:192/bitstring, FAMILY:192/bitstring, _Rest/bitstring>> = binary:list_to_bin(Line),
  io:format("Name: ~p ~p~n", [GIVEN, FAMILY]),
  NaughtyOrNice = is_naughty_or_nice(L, AGE, GIVEN, FAMILY),
  io:format("Naughty or Nice: ~p~n", [NaughtyOrNice]).

is_naughty_or_nice(SentLetter, Age, GivenName, FamilyName) ->
  case SentLetter of
    <<"Y">> -> nice;
    <<"N">> ->
      FullName = <<GivenName/bitstring, FamilyName/bitstring>>,
      Vowels = [C || <<C>> <= FullName, is_vowel(C)],
      Consonants = [C || <<C>> <= FullName, is_consonant(C)],
      Value = length(Consonants) - length(Vowels) + list_to_integer(binary:bin_to_list(Age)),
      if
        Value band 1 == 0 -> nice;
        true -> naughty
      end;
      _ -> naughty
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
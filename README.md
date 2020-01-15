N.O.E.L. Data Importer
=====

An OTP application written in Erlang.
Bah, Humbug!

Build
-----

    $ rebar3 compile

Run Locally
-----------

    $ rebar3 shell


“Make it work, then make it beautiful, then if you really, really have to, make it fast.” - Joe Armstrong, one of the creators of Erlang.

BEAM is a register-based virtual machine. It has 1024 virtual registers that are used for holding temporary values and for passing arguments when calling functions. Variables that need to survive a function call are saved to the stack.

BEAM is a threaded-code interpreter. Each instruction is word pointing directly to executable C-code, making instruction dispatching very fast.

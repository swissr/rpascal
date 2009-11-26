unit rhEventloop;

{ TODO -ohp -cunfinished : unit tthEventloop. Didn't found any entries
  in R.dll, don't understand meaning of extern declaration in header }

{ Pascal (Delphi) translation of the R headerfile eventloop.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/eventloop.h). 
  Please see "DemosAndHeaders.txt" for actually used revision.
                              ---
  R is a computer language for statistical data analysis and is published
  under the GPL, the above-mentioned headerfile is distributed under LGPL.
  Copyright (C) 1995, 1996  Robert Gentleman and Ross Ihaka
  Copyright (C) 1999-2006   The R Development Core Team.
                              ---
  This file is available under two distinct licenses (GPL/proprietary):
  - The contents of this file may be used under the terms of the GNU General 
  Public License Version 2 (the "GPL").  
  - If you cannot (e.g. use of commercial third party components) or if you 
  do not want to comply with the GPL, a commercial license is available which 
  frees you from the restrictions of the GPL. More information upon request.
  - The initial developer of this code is Hans-Peter Suter (gchappi@gmail.com).
                              ---
  The software is provided in the hope that it will be useful but without any
  express or implied warranties, including, but not without limitation, the
  implied warranties of merchantability and fitness for a particular purpose.
                              ---
  Copyright (C) 2006 by Hans-Peter Suter, Treetron GmbH, Switzerland.
  All rights reserved.
                              ---                                              }

{==============================================================================}
interface
uses
  WinSock;

(*

type
  aInputhandlerProc = procedure( _userdata: pointer );

  pInputHandler = ^aInputHandler;
  aInputHandler = packed record
    ihActivity: integer;
    ihFileDescriptor: integer;
    ihHandler: aInputhandlerProc;
    ihNext: pInputHandler;
    ihActive: integer;     // Whether we should be listening to this file descriptor or not.
    ihUserData: pointer;   // Data that can be passed to the routine as its only argument. This might
  end;                     // be a user-level function or closure when we implement a callback to R mechanism.

function rhInitStdinHandler: pInputHandler; cdecl;
procedure rhConsoleInputHandler( var _buf: byte; _len: integer); cdecl;

function rhAddInputHandler( _handlers: pInputHandler; _fd: integer;
    _handler: aInputhandlerProc; _activity: integer): aInputhandlerProc; cdecl;
function rhGetaInputHandler( _handlers: pInputHandler; _fd: integer): aInputHandler; cdecl;
function rhRemoveaInputHandler( _handlers: pInputHandler; _it: aInputHandler): integer; cdecl;
{ TODO -ohp -cfixme : type pFDSet unclear. Check!!  Maybe local declaration instead of the WinWock declaration }
function rhGetSelectedHandler( _handlers: aInputHandler; _mask: pFDSet): aInputHandler; cdecl;
function rCheckActivity( _usec: integer; _ignore_stdin: integer ): pFDSet; cdecl;
function rCheckActivityEx( _usec: integer; _ignore_stdin: integer; _intr: aNoArgProc ): pFDSet; cdecl;
procedure rRunHandlers( handlers: aInputHandler; _mask: pFDSet ); cdecl;

function rSelectEx( _n: integer; _readfds, _writefds, _exceptfds: pFDSet;
    _timeout: pTimeval; _intr: aNoArgProc ): integer; cdecl;

type
  pRpolledEvents = ^aRpolledEvents;
  aRpolledEvents = procedure(); cdecl;

*)

{==============================================================================}
implementation



end {rhEventloop}.

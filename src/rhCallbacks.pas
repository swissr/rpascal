unit rhCallbacks;

{ Pascal (Delphi) translation of the R headerfile Callbacks.h
  (https://svn.r-project.org/R/trunk/src/include/R_ext/Callbacks.h). 
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
  rhRInternals, rhxTypesAndConsts;

type
    { TODO -ohp -csometimes : aRToplevelCallback: better name for _arg }
  aRToplevelCallback = function( _expr, _value: pSExp; _succeeded,
      _visible: aRboolean; _arg: pointer ): aRBoolean;

  { Linked list element for storing the top-level task callbacks. }

  pRToplevelCallbackEl = ^aRToplevelCallbackEl;
  aRToplevelCallbackEl = packed record
    cbCallback: aRToplevelCallback;   // the C routine to call.
	  cbData: pointer;                  // the user-level data to pass to the call to cb
	  cbFinalizer: aDataProc;           // Called when the callback is removed.
	  cbNname: pChar;                   // a name by which to identify this element.
	  cbNext: pRToplevelCallbackEl;     // the next element in the linked list.
  end;

function rRemoveTaskCallbackByIndex( _id: integer ): aRboolean; cdecl;
function rRemoveTaskCallbackByName( _name: pChar ): aRboolean; cdecl;
function rRemoveTaskCallback( _which: pSExp ): pSExp; cdecl;
function rAddTaskCallback( _cb: aRToplevelCallback; _data: pointer;
    _finalizer: aDataProc; _name: pChar; _pos: integer ): pRToplevelCallbackEl; cdecl;


  { The following definitions are for callbacks to R functions and methods
    related to user-level tables. This is currently implemented in a
    separate package and these declarations allow the package to
    interface to the internal R code. }

  type
  pRObjectTable = ^aRObjectTable;

  aRDbExists = function( _name: pChar; _canCache: pRBoolean; _objTable: pRObjectTable ): aRboolean;
  aRDbGet = function( _name: pChar; _canCache: pRBoolean; _objTable: pRObjectTable ): pSExp;
  aRDbRemove = function( _name: pChar; _objTable: pRObjectTable ): integer;
  aRDbAssign = function( _name: pChar; _value: pSExp; _objTable: pRObjectTable ): pSExp;
  aRDbObjects = function( _objTable: pRObjectTable ): pSExp;
  aRDbCanCache = function( _name: pChar; _objTable: pRObjectTable ): aRboolean;
  aRDbOnDetach = procedure( _objTable: pRObjectTable );
  aRDbOnAttach = procedure( _objTable: pRObjectTable );

  aRObjectTable = packed record
    otType: integer;
    otCachedNames: ppChar;
    otActive: aRboolean;
    otExists: aRDbExists;
    otGet: aRDbGet;
    otRemove: aRDbRemove;
    otAssign: aRDbAssign;
    otObjects: aRDbObjects;
    otCanCache: aRDbCanCache;
    otOnDetach: aRDbOnDetach;
    otOonAttach: aRDbOnAttach;
    otPprivateData: pointer;
  end;


{==============================================================================}
implementation

function rRemoveTaskCallbackByIndex; external TheRDll name 'Rf_removeTaskCallbackByIndex';
function rRemoveTaskCallbackByName; external TheRDll name 'Rf_removeTaskCallbackByName';
function rRemoveTaskCallback; external TheRDll name 'R_removeTaskCallback';
function rAddTaskCallback; external TheRDll name 'R_addTaskCallback';


end {rhCallbacks}.

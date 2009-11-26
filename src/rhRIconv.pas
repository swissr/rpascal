unit rhRIconv;

{ Pascal (Delphi) translation of the R headerfile Riconv, based
  (https://svn.r-project.org/R/trunk/src/include/R_ext/Riconv.h). 
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
  rhxTypesAndConsts;

function RIconvOpen( _tocode: pChar;_fromcode: pChar ): pointer; cdecl;
function RIconv( _cd: pChar; _inbuf: ppChar; _inbytesleft: psize;
    _outbuf: ppChar; _outbytesleft: pSize ): aSize; cdecl;
function RIconvClose( _cd: pointer ): integer; cdecl;


{==============================================================================}
implementation


function RIconvOpen; external TheRDll name 'Riconv_open';
function RIconv; external TheRDll name 'Riconv';
function RIconvClose; external TheRDll name 'Riconv_close';


end {rhRIconv}.

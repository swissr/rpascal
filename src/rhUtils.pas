unit rhUtils;

{ Pascal (Delphi) translation of the R headerfile Utils.h
  (https://svn.r-project.org/R/trunk/src/include/R_ext/Utils.h). 
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

{ sort }

procedure rIsort( _x: pinteger; _n: integer); cdecl;
procedure rRsort( _x: pdouble; _n: integer ); cdecl;
procedure rCsort( _x: pRComplex; _n: integer ); cdecl;
procedure rRsortWithIndex( _x: pdouble; _indx: pinteger; _n: integer); cdecl;
procedure rRevsort( _a: pdouble; _ib: pinteger; _n: integer); cdecl;
procedure rIpsort( _x: pinteger; _n, _k: integer ); cdecl;
procedure rRpsort( _x: pdouble; _n, _k: integer ); cdecl;
procedure rCpsort( _x: pRComplex; _n, _k: integer ); cdecl;

{ qsort }

procedure rQsort( _v: pdouble; _i, _j: integer); cdecl;
procedure rQsortI( _v: pdouble; _bigI: pinteger; _i, _j: integer ); cdecl;
procedure rQsortInt( _iv: pinteger; _i, _j: integer ); cdecl;
procedure rQsortIntI( _iv, _bigI: pinteger; _i: integer; _j: integer); cdecl;

{ printutils }

function rIndexWidth( _n: integer ): integer; cdecl;

{ util and others }

function rExpandFileName( _s: PChar): PChar; cdecl;
procedure rSetIVector( _vec: pinteger; _len, _val: integer ); cdecl;
procedure rSetRVector( _vec: pdouble; _len, _val: double); cdecl;
function rStringFalse( _name: PChar ): aRBoolean; cdecl;
function rStringTrue( _name: PChar ): aRBoolean; cdecl;
function rIsBlankString( _s: PChar ): aRBoolean; cdecl;

function rStrTod( _c: PChar; _end: pPChar ): double; cdecl;
function rTmpNam( _prefix: PChar; _tempdir: PChar): PChar; cdecl;

procedure rHsv2Rgb( _h, _s, _v: double; _r, _g, _b: pdouble); cdecl;
procedure rRgb2Hsv( _r, _g, _b: double; _h, _s, _v: pdouble); cdecl;

procedure rCheckUserInterrupt; cdecl;
{ TODO -ohp -caskRdevel : R_CheckStack has no entrypoint in the R.dll }
//procedure rCheckStack; cdecl;

{ skipped interv and maxcol that are also in Applic }

{==============================================================================}
implementation

procedure rGetRngState; external TheRDll name 'GetRNGstate';


procedure rIsort; external TheRDll name 'R_isort';
procedure rRsort; external TheRDll name 'R_rsort';
procedure rCsort; external TheRDll name 'R_csort';
procedure rRsortWithIndex; external TheRDll name 'rsort_with_index';
procedure rRevsort; external TheRDll name 'Rf_revsort';
procedure rIpsort; external TheRDll name 'Rf_iPsort';
procedure rRpsort; external TheRDll name 'Rf_rPsort';
procedure rCpsort; external TheRDll name 'Rf_cPsort';

procedure rQsort; external TheRDll name 'R_qsort';
procedure rQsortI; external TheRDll name 'R_qsort_I';
procedure rQsortInt; external TheRDll name 'R_qsort_int';
procedure rQsortIntI; external TheRDll name 'R_qsort_int_I';

function rIndexWidth; external TheRDll name 'Rf_IndexWidth';

function rExpandFileName; external TheRDll name 'R_ExpandFileName';
procedure rSetIVector; external TheRDll name 'Rf_setIVector';
procedure rSetRVector; external TheRDll name 'Rf_setRVector';
function rStringFalse; external TheRDll name 'Rf_StringFalse';
function rStringTrue; external TheRDll name 'Rf_StringTrue';
function rIsBlankString; external TheRDll name 'Rf_isBlankString';
function rStrTod; external TheRDll name 'R_strtod';
function rTmpNam; external TheRDll name 'R_tmpnam';
procedure rHsv2Rgb; external TheRDll name 'Rf_hsv2rgb';
procedure rRgb2Hsv; external TheRDll name 'Rf_rgb2hsv';
procedure rCheckUserInterrupt; external TheRDll name 'R_CheckUserInterrupt';
//procedure rCheckStack; external TheRDll name 'R_CheckStack';


end {rhUtils}.

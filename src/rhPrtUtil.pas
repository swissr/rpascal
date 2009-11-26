unit rhPrtUtil;

{ Pascal (Delphi) translation of the R headerfile PrtUtil.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/PrtUtils.h). 
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
  rhR, rhxTypesAndConsts;

  { Computation of printing formats }

procedure rFormatLogical( _x, _fieldwidth: pInteger );
procedure rFormatInteger( _x, _fieldwidth: pInteger );
procedure rFormatComplex( _x: pRComplex; _n: integer; _wr, _dr, _er: pInteger );

  { Formating of values }

function rEncodeLogical( _x, _w: integer ): pChar;
function rEncodeInteger( _x, _w: integer ): pChar;
function rEncodeReal( _x: double; _w, _d, _e: integer; _cdec: char ): pChar;
function rEncodeComplex( _x: pRComplex; _wr, _dr, _er, _wi, _di, _ei: integer;
    _cdec: char ): pChar;

  { Printing }

procedure rVectorIndex( _i, _w: integer );

procedure rPrintLogicalVector( _x: pInteger; _n, _indx: integer );
procedure rPrintIntegerVector( _x: pInteger; _n, _indx: integer );
procedure rPrintRealVector( _x: pDouble; _n, _indx: integer );
procedure rPrintComplexVector( _x: pRComplex; _n, _indx: integer );


{==============================================================================}
implementation


procedure rFormatLogical; external TheRDll name 'Rf_formatLogical';
procedure rFormatInteger; external TheRDll name 'Rf_formatInteger';
procedure rFormatComplex; external TheRDll name 'Rf_formatComplex';

function rEncodeLogical; external TheRDll name 'Rf_EncodeLogical';
function rEncodeInteger; external TheRDll name 'Rf_EncodeInteger';
function rEncodeReal; external TheRDll name 'Rf_EncodeReal';
function rEncodeComplex; external TheRDll name 'Rf_EncodeComplex';

procedure rVectorIndex; external TheRDll name 'Rf_VectorIndex';

procedure rPrintLogicalVector; external TheRDll name 'printLogicalVector';
procedure rPrintIntegerVector; external TheRDll name 'Rf_printIntegerVector';
procedure rPrintRealVector; external TheRDll name 'Rf_printRealVector';
procedure rPrintComplexVector; external TheRDll name 'Rf_printComplexVector';


end {rhPrtUtil}.

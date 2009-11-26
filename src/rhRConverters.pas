unit rhRConverters;

{ Pascal (Delphi) translation of the R headerfile RConverters.h
  (https://svn.r-project.org/R/trunk/src/include/R_ext/RConverters.h). 
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
  rhRinternals, rhxTypesAndConsts;


type
    { Context information controlling how the conversion is performed, passed
      to RObjToCPtr in dotcode.c and the different user level converters. }
  pCConvertInfo = ^aCConvertInfo;
  aCConvertInfo = packed record
    cciNaok: integer;
    cciNarg: integer;
    cciDup: integer;
    cciFort: integer;
    cciName: pChar;
    cciClasses: pSExp;
  end;

  pToCConverterInfo = ^aToCConverterDef;
  pFromCconvertInfo = ^aFromCConvertInfo;

  aToCPredicate = function( _obj: pSExp; _info: pFromCconvertInfo;
      _el: pToCconverterInfo ): aRBoolean;

  aToCConverter = procedure( _obj: pSExp; _info: pCConvertInfo;
      _el: pToCconverterInfo );

  aFromCConverter = function( _value: pointer; _arg: pSExp;
      _info: pFromCconvertInfo; _el: pToCconverterInfo ): pSExp;

    { The definition of the converter element which are stored as a linked list.
      (added "Def" to the name, original was "RtoCConverter" only) }
  aToCConverterDef = packed record
    tciMatcher: aToCPredicate;
    tciConverter: aToCConverter;
    tciReverse: aFromCConverter;
    tciDescription: pChar;
    tciUserData: pChar;
    tciActive: aRBoolean;
    tciNext: pToCConverterInfo;
  end;

    { Information used to convert C values to R objects at the end of do_dotCode() }
  aFromCConvertInfo = packed record
    fciFunctionName: pChar;         // the name of the routine being called (S's name for it).
    fciArgIndex: integer;           // the pariticular argument being processed.
    fciAllArgs: pSExp;              // We provide all of the arguments and the corresponding C values.
                                    // This gives the full context of the call to the reverse converter
    fciCargs: ppointer;
    fciNargs: integer;
  end;


  { Internal mechanism for employing the converter mechanism, used in do_dotCode() in dotcode.c }
procedure rConvertToC( _s: pSExp; _info: aCConvertInfo; _success: integer;_conv: aToCConverter );

  { Converter management facilities. }
function rAddToCConverter( _match: aToCPredicate; _converter: aToCConverter;
    _reverse: aFromCConverter; _userData: pointer; _desc: pChar ): pToCConverterInfo;
function rGetToCConverterByIndex( _which: integer ): pToCConverterInfo;
function rGetToCConverterByDescription( _desc: pChar ): pToCConverterInfo;
procedure rRemoveToCConverter( _el: pToCConverterInfo );

function rConverterMatchClass( _obj: pSExp; _inf: pCConvertInfo;
    _el: pToCConverterInfo ): aRBoolean;
procedure rFreeCConverter( _el: pToCConverterInfo );

  { The routines correpsonding to the .Internal() providing access to the
    management facilities of the converter list. }
function rDoGetNumRtoCConverters( _call, _op, _args, _env: pSExp ): pSExp;
function rDoGetRtoCConverterDescriptions( _call, _op, _args, _env: pSExp ): pSExp;
function rDoGetRtoCConverterStatus( _call, _op, _args, _env: pSExp ): pSExp;
function rDoSetToCConverterActiveStatus( _call, _op, _args, _env: pSExp ): pSExp;


{==============================================================================}
implementation

//function riHashash; external TheRDll name 'Hashash';


procedure rConvertToC;external TheRDll name 'Rf_convertToC';

function rAddToCConverter;external TheRDll name 'R_addToCConverter';
function rGetToCConverterByIndex;external TheRDll name 'R_getToCConverterByIndex';
function rGetToCConverterByDescription;external TheRDll name 'R_getToCConverterByDescription';
procedure rRemoveToCConverter;external TheRDll name 'R_removeToCConverter';

function rConverterMatchClass;external TheRDll name 'R_converterMatchClass';
procedure rFreeCConverter;external TheRDll name 'freeCConverter';

function rDoGetNumRtoCConverters;external TheRDll name 'do_getNumRtoCConverters';
function rDoGetRtoCConverterDescriptions;external TheRDll name 'do_GetRtoCConverterDescriptions';
function rDoGetRtoCConverterStatus;external TheRDll name 'do_getRtoCConverterStatus';
function rDoSetToCConverterActiveStatus;external TheRDll name 'do_setToCConverterActiveStatus';


end {rhRConverters}.

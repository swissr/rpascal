unit rhRDynload;

{ Pascal (Delphi) translation of the R headerfile Rdynload.h
  (https://svn.r-project.org/R/trunk/src/include/R_ext/Rdynload.h). 
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
  Windows, rhRInternals, rhxTypesAndConsts;


{---------------------------------------------------------- Rdynload.h }

type
  aDlFunc = pointer;

const
    //#define SINGLESXP 302 /* Don't have a single type for this. */
  TheSingleSxp = 302;

type
  aNativePrimitiveArgType = aSExpType;
  pNativePrimitiveArgTypeArr = ^aNativePrimitiveArgTypeArr;
  aNativePrimitiveArgTypeArr = array[0..(MaxInt div SizeOf( aNativePrimitiveArgType )) - 1 - theArrOff] of aNativePrimitiveArgType;

  aNativeObjectArgType = word;
  pNativeObjectArgTypeArr = ^aNativeObjectArgTypeArr;
  aNativeObjectArgTypeArr = array[0..(MaxInt div SizeOf( aNativeObjectArgType )) - 1 - theArrOff] of aNativeObjectArgType;

  aNativeArgStyle = ( nasArgIn, nasArgOut, nasArgInOut, nasIrrelevant );
  pNativeArgStyleArr = ^aNativeArgStyleArr;
  aNativeArgStyleArr = array[0..(MaxInt div SizeOf( aNativeArgStyle )) - 1 - theArrOff] of aNativeArgStyle;

  aNativeSymbolType = ( nstAnySym, nstCSym, nstCallSym, nstFortranSym, nstExternalSym );
  aSymbol = ( symC, symCall, symFortran, symExternal );


{---------------------------------------------------------- Rdynpriv.h }

const
  TheCacheDllSym = 1;

type
  aHInstance = HINST;

  aCFunTabEntry = packed record
    fteName: PChar;
    fteFunc: aDlFunc;
  end;

  pDotCSymbol = ^aDotCSymbol;
  aDotCSymbol = packed record
    dcsName: PChar;
    dcsFun: aDlFunc;
    dcsNumArgs: integer;
    dcsTypes: pNativePrimitiveArgTypeArr;
    dcstyles: pNativeArgStyleArr;
  end;
  pDotFortranSymbol = ^aDotFortranSymbol;
  aDotFortranSymbol = aDotCSymbol;


  pDotCallSymbol = ^aDotCallSymbol;
  aDotCallSymbol = packed record
    casName: PChar;
    casFun: aDlFunc;
    casNumArgs: integer;
    casTypes: pNativeObjectArgTypeArr;
    casStyles: pNativeArgStyleArr;
  end;
  pDotExternalSymbol = ^aDotExternalSymbol;
  aDotExternalSymbol = aDotCallSymbol;

  pDllInfo = ^aDllInfo;
  aDllInfo = packed record
    dllPath: pChar;
    dllName: pChar;
    dllHandle: aHInstance;
    dllUseDynamicLookup: aRBoolean;
    dllNumCSymbols: integer;
    dllCSymbols: pDotCSymbol;
    dllNumCallSymbols: integer;
    dllCallSymbols: pDotCallSymbol;
    dllNumFortranSymbols: integer;
    dllFortranSymbols: pDotFortranSymbol;
    dllNumExternalSymbols: integer;
    dllExternalSymbols: pDotExternalSymbol;
  end;

  pRegisteredNativeSymbol = ^aRegisteredNativeSymbol;
  aRegisteredNativeSymbol = packed record
    rnsType: aNativeSymbolType;
    rnsDll : pDllInfo;
    case aSymbol of
      symC: (rnsC: aDotCSymbol);
      symCall: (rnsCall: aDotCallSymbol);
      symFortran: (rnsFortran: aDotFortranSymbol);
      symExternal: (rnsExternal: aDotExternalSymbol);
  end;

  { OSDynSymbol and R_CPFun have not been translated }


{---------------------------------------------------------- Rdynload.h }

  pCMethodDef = ^aCMethodDef;
  aCMethodDef = packed record
    cmdName: pchar;
    cmdFunc: aDlFunc;
    cmdNumArgs: integer;
    cmdTypes: pNativePrimitiveArgTypeArr;
    cmdStyles: pNativeArgStyleArr;
  end;
  pFortranMethodDef = ^aFortranMethodDef;
  aFortranMethodDef = aCMethodDef;

  pCallMethodDef = ^aCallMethodDef;
  aCallMethodDef = packed record
    cadName: pchar;
    cadFunc: aDlFunc;
    cadNumArgs: integer;
  end;
  pExternalMethodDef = ^aExternalMethodDef;
  aExternalMethodDef = aCallMethodDef;

function rRegisterRoutines( _info: pDllInfo; _cRoutines: pCMethodDef;
    _callRoutines: pCallMethodDef; _fortranRoutines: pFortranMethodDef;
    _externalRoutines: pExternalMethodDef ): integer cdecl;

function rGetDllInfo( _name: pChar ): pDllInfo; cdecl;
function rFindSymbol( _name, _pkg: pChar; _symbol: pRegisteredNativeSymbol ): aDlFunc; cdecl;
function rModuleCDynload( _module: pChar; _local, _now: integer ): integer; cdecl;
function rUseDynamicSymbols( _info: pDllInfo; _value: aRBoolean ): aRBoolean; cdecl;


{---------------------------------------------------------- Rdynpriv.h }

function rLookupCachedSymbol( _name, _pkg: pChar; _all: integer ): aDlFunc; cdecl;
function rLookupRegisteredCSymbol( _info: pDllInfo; _name: pChar ): pDotCSymbol; cdecl;
function rLookupRegisteredCallSymbol( _info: pDllInfo; _name: pChar ): pDotCallSymbol; cdecl;
  { TODO -ohp -caskRdevel : rLookupRegisteredExternalSymbol is not defined in header
    (would work ok) }
//function rLookupRegisteredExternalSymbol( _info: pDllInfo; _name: pChar ): pDotExternalSymbol; cdecl;
function rRegisterDll( _handle: aHInstance; _path: pChar ): pDllInfo; cdecl;

function rGetDllRegisteredSymbol( _info: pDllInfo; _name: pChar;
    _symbol: pRegisteredNativeSymbol ): aDlFunc; cdecl;
function rDlSym( _info: pDllInfo; _name: pChar;
    _symbol: pRegisteredNativeSymbol ): aDlFunc; cdecl;


{==============================================================================}
implementation


function rRegisterRoutines; external TheRDll name 'R_registerRoutines';
function rGetDllInfo; external TheRDll name 'R_getDllInfo';
function rFindSymbol; external TheRDll name 'R_FindSymbol';
function rModuleCdynload; external TheRDll name 'moduleCdynload';
function rUseDynamicSymbols; external TheRDll name 'R_useDynamicSymbols';

function rLookupCachedSymbol; external TheRDll name 'Rf_lookupCachedSymbol';
function rLookupRegisteredCSymbol; external TheRDll name 'Rf_lookupRegisteredCSymbol';
function rLookupRegisteredCallSymbol; external TheRDll name 'Rf_lookupRegisteredCallSymbol';
//function rLookupRegisteredExternalSymbol; external TheRDll name 'Rf_lookupRegisteredExternalSymbol';
function rRegisterDll; external TheRDll name 'R_RegisterDll';
function rGetDllRegisteredSymbol; external TheRDll name 'GetDLLRegisteredSymbol';
function rDlSym; external TheRDll name 'R_dlsym';

end {rhRDynload}.

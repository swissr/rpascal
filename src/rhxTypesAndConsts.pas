unit rhxTypesAndConsts;

{ Pascal (Delphi) translation of some common stuff (types and constants)
  of the R headerfiles.
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

{---------------------------------------------------------- settings }

const
  TheRDll = 'R.dll';
  TheBlasDll = 'Rblas.dll';

{---------------------------------------------------------- common things }

const
  theArrOff = 50;   // offset to prevent error message in arrays in records

type
  pPCharArr = ^aPCharArr;
  aPCharArr = array[0..(MaxInt div SizeOf( pChar )) - 1 - theArrOff] of pChar;

  pDouble = ^double;
  pDoubleArr = ^aDoubleArr;
  aDoubleArr = array[0..(MaxInt div SizeOf( double )) - 1 - theArrOff] of double;

  pInteger = ^integer;
  pIntegerArr = ^aIntegerArr;
  aIntegerArr = array[0..(MaxInt div SizeOf( integer )) - 1 - theArrOff] of integer;

  pLongWordArr = ^aLongWordArr;
  aLongWordArr = array[0..(MaxInt div SizeOf( LongWord )) - 1 - theArrOff] of LongWord;

  pByte = byte;                     // use this for unsigned char*
  pByteArr = ^aByteArr;
  aByteArr = array[0..(MaxInt div SizeOf( byte )) - 1 - theArrOff] of byte;

  aPointerArr = array[0..(MaxInt div SizeOf( pointer )) - 1 - theArrOff] of pointer;

  va_list = PChar;  // redeclared from windows.pas

{---------------------------------------------------------- misc. R headers }

{ stddef.h }

type
  pSize = ^aSize;
  aSize = word;

{ Boolean.h }

type
  pRBoolean = ^aRBoolean;
  aRBoolean = boolean;

{ Complex.h }

  pRComplex = ^aRComplex;
  aRComplex = packed record
    compR: double;
    compI: double;
  end;
  pRcomplexArr = ^aRComplexArr;
  aRcomplexArr = array[0..(MaxInt div SizeOf( aRComplex )) - 1 - theArrOff] of aRComplex;

{ Constants.h }

const
  ThePi = 3.141592653589793238462643383279502884197169399375;
    { the following constants are taken from BDS4.0 float.h (or Math.pas) }
  TheSingleEps =    1.19209290E-07;
  TheSingleBase =   2;
  TheSingleXMin =   1.17549435E-38;
  TheSingleXMax =   3.4e+38;   // from Math.pas
  TheDoubleDigits = 53;
  TheDoubleEps =    2.2204460492503131E-16;
  TheDoubleXMax =   1.7e+308;  // from Math.pas
  TheDoubleXMin =   2.2250738585072014E-308;

{ Random.h }

type
  int32 = Word;

{ R.h }

  sfloat = double;
  sint = integer;

{ RInternals.h }

  pRByte = ^aRByte;             // unsigned char
  aRByte = byte;                // unsigned char
  aRLen = integer;              // will be long later, LONG64 or ssize_t on Win64
  pFile = ^File;

{---------------------------------------------------------- callbacks }

type
    { declared common callbacks here, specific one in the respective units }
  aProc = procedure(); cdecl;
  aDataProc = procedure( _data: pointer ); cdecl;
  aRboolFunc = function(): aRBoolean; cdecl;
  aDoubleFunc = function(): double; cdecl;

{---------------------------------------------------------- global vars }

type
  aRVarsType = ( vtUndefined, vtSExp, vtDouble, vtInteger );
  aRVars = record
    gvName: string;
    gvPointer: pointer;  // pointer to a global pSExp variable
    gvType: aRVarsType;
  end;

  aRVarsArr = array of aRVars;


{==============================================================================}
implementation


end {rhxTypesAndConsts}.

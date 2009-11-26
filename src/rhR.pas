unit rhR;

{ Pascal (Delphi) translation of the R headerfile R.h.
  (https://svn.r-project.org/R/trunk/src/include/R.h). 
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
{.$DEFINE USEMATH}

uses
  {$IFDEF USEMATH}Math,{$ENDIF} rhxTypesAndConsts;

{---------------------------------------------------------- Arith.h }

var
  { TODO -ohp -csometimes : skipped: NA_LOGICAL, NA_INTEGER and NA_REAL }
  RNaN: double {$IFDEF USEMATH}= -NaN{$ENDIF};
  RPosInf: double {$IFDEF USEMATH}= Infinity{$ENDIF};
  RNegInf: double {$IFDEF USEMATH}= -Infinity{$ENDIF};
  { TODO -ohp -ccheck : the initialization is not correct, see demo missing values
    (Windows is big endian, indices set to: hw = 0, lw = 1 and value set to
     x.word[hw] = 0x7ff00000;  x.word[lw] = 1954;
     $7ff00000 shl 32 should give:  7f f0 00 00  00 00 00 00
     1954 should give:              00 00 00 00  00 00 07 A2)
    Not so important, is initialized with the R value anyway, changed
    variable to Wrong<name> and will check later }
  WrongRNaReal: double = ($7ff00000 shl 32) or 1954;
  RNaReal: double {$IFDEF USEMATH}= +NaN{$ENDIF};
  RNaInt: integer = 0;

  { Support variable initialization }
type
  aVarArith =           ( varRNaN, varRPosInf, varRNegInf
                        , varRNaReal, varRNaInt );
  aLoadVarArith =       set of aVarArith;

const
  TheVarArithName:      array[aVarArith] of string
                        = ( 'R_NaN', 'R_PosInf', 'R_NegInf'
                          , 'R_NaReal', 'R_NaInt' );

  TheVarArithPtr:       array[aVarArith] of pointer
                        = ( @RNaN, @RPosInf, @RNegInf
                          , @RNaReal, @RNaInt );

  TheVarArithType:      array[aVarArith] of aRVarsType
                        = ( vtDouble, vtDouble, vtDouble
                          , vtDouble, vtInteger );

  TheLoadVarArith:      aLoadVarArith
                        = [ varRNaN, varRPosInf, varRNegInf
                          , varRNaReal, varRNaInt ];

function ToRVarsArr( _set: aLoadVarArith ): aRVarsArr; overload;


function rIsNA( _value: double): integer; cdecl;
{ TODO -ohp -ccheck : ISNAN has different definitions in Arith.h. }
function rIsNaN( _value: double): integer; cdecl;
function rFinite( _value: double): integer; cdecl;
function rIsnancpp( _value: double): integer cdecl;

{---------------------------------------------------------- Boolean.h }
  { declared in tthCommTypesAndConsts }

{---------------------------------------------------------- Complex.h }
  { declared in tthCommTypesAndConsts }

{---------------------------------------------------------- Constants.h }
  { declared in tthCommTypesAndConsts }

{---------------------------------------------------------- Error.h }

procedure rError( _value: PChar ); cdecl; varargs;
procedure rWarning( _value: PChar ); cdecl; varargs;
procedure rWrongArgCount( _value: PChar ); cdecl;
procedure rUnimplemented( _value: PChar ); cdecl;
procedure rShowMessage( _s: PChar ); cdecl;

{---------------------------------------------------------- Memory.h }

function rVmaxget: PChar; cdecl;
procedure rVmaxset( _ovmax: PChar); cdecl;
procedure rGc; cdecl;
function rAlloc( _nelem: LongInt; _eltsize: integer): PChar; cdecl;
function rSAlloc( _nelem: LongInt; _eltsize: integer): PChar; cdecl;
function rSRealloc( _p: PChar; _new: LongInt; _old: LongInt; _size: integer): PChar; cdecl;

{---------------------------------------------------------- Print.h }

{ TODO -ohp -cfixme : line break doesn't work in rRprintf, neither does
  the backslash work as a "protector", grr. }

  { use "'bla bla %s', #13#10" for line breaks. "'bla bla \n'" doesn't work }
procedure rRprintf( _format: PChar ); cdecl; varargs;
procedure rREprintf( _format: PChar ); cdecl; varargs;
procedure rRvprintf( _format: PChar; _args: va_list ); cdecl;
procedure rREvprintf( _format: PChar; _args: va_list ); cdecl;

{---------------------------------------------------------- Random.h }

type
  aRngType = ( rngWichmannHill, rngMarsagliaMulticarry, rngSuperDuper
             , rngMersenneTwister, rngKnuthTaocp, rngUserUnif, rngKnuthTaocp2 );

  aNo1Type = ( no1BuggyKindermanRamage, no1AhrensDieter, no1BoxMuller
             , no1UserNorm, no1Inversion, no1KindermanRamage );

procedure rGetRngState; cdecl;
procedure rPutRngState; cdecl;
function rUnifRand: double; cdecl;

function rNormRand: double; cdecl;
function rExpRand: double; cdecl;

{ TODO -ohp -caskRdevel : The following user_<xy>_<yz> functions don't have entrypoints in the R.dll }
//function rUserUnifRand: pDouble; cdecl;
//procedure rUserUnifInit( _val: int32 ); cdecl;
//function rUserUnifNseed: pInteger; cdecl;
//function rUserUnifSeedloc: pInteger; cdecl;
//function rUserNormRand: pDouble; cdecl;

{---------------------------------------------------------- Utils.h }
  { declared in tthUtils }

{---------------------------------------------------------- RS.h }

{ skipped some MACRO definitions }
function rChkCalloc( _nelem: aSize; _elsize: aSize ): pointer; cdecl;
function rChkRealloc( _ptr: pointer; _size: aSize ): pointer; cdecl;
procedure rChkFree( _ptr: pointer ); cdecl;
{ skipped Calloc, Realloc, Free, R_Free and Memcpy  }
procedure rCallR( _func: PChar; _nargs: LongInt; _arguments: ppointer;
    _modes: ppChar; _length: plongint; _names: pPChar;
    _nres: LongInt; _results: ppChar); cdecl;

{---------------------------------------------------------- R.h }
  { declared in tthCommTypesAndConsts }


{==============================================================================}
implementation

{ Support for global variable initialization }

function ToRVarsArr( _set: aLoadVarArith ): aRVarsArr;
  var
    i: aVarArith;
    idx: integer;
  begin
    SetLength( result, 0 );
    for i:= Low( aVarArith ) to High( aVarArith ) do begin
      if i in _set then begin
        idx:= Length( result );
        SetLength( result, idx + 1 );
        result[idx].gvName:= TheVarArithName[i];
        result[idx].gvPointer:= TheVarArithPtr[i];
        result[idx].gvType:= TheVarArithType[i];
      end;
    end;
  end {LoadVarRInternalsToArr};


{---------------------------------------------------------- Arith.h }

function rIsNa; external TheRDll name 'R_IsNA';
function rIsNan; external TheRDll name 'R_IsNaN';
function rFinite; external TheRDll name 'R_finite';
function rIsnancpp; external TheRDll name 'R_isnancpp';

{---------------------------------------------------------- Error.h }

procedure rError; external TheRDll name 'Rf_error';
procedure rWarning; external TheRDll name 'Rf_warning';
procedure rWrongArgCount; external TheRDll name 'WrongArgCount';
procedure rUnimplemented; external TheRDll name 'Unimplemented';
procedure rShowMessage; external TheRDll name 'R_ShowMessage';

{---------------------------------------------------------- Memory.h }

function rVmaxget; external TheRDll name 'vmaxget';
procedure rVmaxset; external TheRDll name 'vmaxset';
procedure rGc; external TheRDll name 'R_gc';
function rAlloc; external TheRDll name 'R_alloc';
function rSAlloc; external TheRDll name 'S_alloc';
function rSRealloc; external TheRDll name 'S_realloc';

{---------------------------------------------------------- Print.h }

procedure rRprintf; external TheRDll name 'Rprintf';
procedure rREprintf; external TheRDll name 'REprintf';
procedure rRvprintf; external TheRDll name 'Rvprintf';
procedure rREvprintf; external TheRDll name 'REvprintf';

{---------------------------------------------------------- Random.h }

procedure rGetRngState; external TheRDll name 'GetRNGstate';
procedure rPutRngState; external TheRDll name 'PutRNGstate';
function rUnifRand; external TheRDll name 'unif_rand';
function rNormRand; external TheRDll name 'norm_rand';
function rExpRand; external TheRDll name 'exp_rand';
{ FIXME: missing - no entrypoints? }
//function rUserUnifRand; external TheRDll name 'UserUnifRand';
//procedure rUserUnifInit; external TheRDll name 'UserUnifInit';
//function rUserUnifNseed; external TheRDll name 'UserUnifNseed';
//function rUserUnifSeedloc; external TheRDll name 'UserUnifSeedloc';
//function rUserNormRand; external TheRDll name 'UserNormRand';

{---------------------------------------------------------- RS.h }

function rChkCalloc; external TheRDll name 'R_chk_calloc';
function rChkRealloc; external TheRDll name 'R_chk_realloc';
procedure rChkFree; external TheRDll name 'R_chk_free';
procedure rCallR; external TheRDll name 'call_R';


end {rhR}.

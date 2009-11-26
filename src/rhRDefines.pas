unit rhRDefines;

{ Pascal (Delphi) translation of the R headerfile Rdefines.h
  (https://svn.r-project.org/R/trunk/src/include/Rdefines.h). 
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

  {  Much is from John Chambers' "Programming With Data".
     Some of this is from Doug Bates. }

  {  Added some macros defined in S.h from Splus 5.1 }

var
  NullUserObject: pSExp = nil;

  { Support variable initialization }
function LoadNullUserObject: boolean;


function rdAsLogical( _x: pSExp ): pSExp;
function rdAsInteger( _x: pSExp ): pSExp;
function rdAsNumeric( _x: pSExp ): pSExp;
function rdAsCharacter( _x: pSExp ): pSExp;
function rdAsComplex( _x: pSExp ): pSExp;
function rdAsVector( _x: pSExp ): pSExp;
function rdAsList( _x: pSExp ): pSExp;
function rdAsRaw( _x: pSExp ): pSExp;

function rdIsLogical( _x: pSExp ): aRBoolean;
function rdIsInteger( _x: pSExp ): aRBoolean;
function rdIsNumeric( _x: pSExp ): aRBoolean;
function rdIsCharacter( _x: pSExp ): aRBoolean;
function rdIsComplex( _x: pSExp ): aRBoolean;
function rdIsVector( _x: pSExp ): aRBoolean;
function rdIsList( _x: pSExp ): aRBoolean;
function rdIsRaw( _x: pSExp ): aRBoolean;

function rdNewLogical( _n: aRlen ): pSExp;
function rdNewInteger( _n: aRlen ): pSExp;
function rdNewNumeric( _n: aRlen ): pSExp;
function rdNewCharacter( _n: aRlen ): pSExp;
function rdNewComplex( _n: aRlen ): pSExp;
function rdNewList( _n: aRlen ): pSExp;
function rdNewString( _n: aRlen ): pSExp;
function rdNewRaw( _n: aRlen ): pSExp;

function rdLogicalPointer( _x: pSExp ): pIntegerArr;
function rdIntegerPointer( _x: pSExp ): pIntegerArr;
function rdNumericPointer( _x: pSExp ): pDoubleArr;
function rdCharacterPointer( _x: pSExp ): aSexpArr;
function rdComplexPointer( _x: pSExp ): pRComplexArr;
function rdListPointer( _x: pSExp ): aSexpArr;
function rdRawPointer( _x: pSExp ): pRByte;

  { The following are not defined in `Programming with Data' but are
    defined in S.h in Svr4 }

function rdLogicalData( _x: pSExp ): pIntegerArr;
function rdIntegerData( _x: pSExp ): pIntegerArr;
function rdDoubleData( _x: pSExp ): pDoubleArr;
function rdNumericData( _x: pSExp ): pDoubleArr;
function rdCharacterData( _x: pSExp ): aSexpArr;
function rdComplexData( _x: pSExp ): pRComplexArr;
function rdRecursiveData( _x: pSExp ): aSexpArr;
function rdVectorData( _x: pSExp ): aSexpArr;

function rdLogicalValue( _x: pSExp ): integer;
function rdIntegerValue( _x: pSExp ): integer;
function rdNumericValue( _x: pSExp ): double;
function rdCharacterValue( _x: pSExp ): pChar;
function rdStringValue( _x: pSExp ): pChar;
{ The "value" of a list object or a raw object is not defined,
  therefore rdListValue and rdRawValue have been skipped }

procedure rdSetElement( _x: pSExp; _i: integer; _val: pSExp);
function rdGetAttr( _x: pSExp; _what: pSExp ): pSExp;
function rdGetClass( _x: pSExp ): pSExp;
function rdGetDim( _x: pSExp ): pSExp;
function rdGetDimnames( _x: pSExp ): pSExp;
function rdGetColnames( _x: pSExp ): pSExp;
function rdGetRownames( _x: pSExp ): pSExp;
function rdGetLevels( _x: pSExp ): pSExp;
function rdGetTsp( _x: pSExp ): pSExp;
function rdGetNames( _x: pSExp ): pSExp;
procedure rdSetClass( _x: pSExp; _name: pSExp );
procedure rdSetDim( _x: pSExp; _name: pSExp );
procedure rdSetDimnames( _x: pSExp ; _name: pSExp);
procedure rdSetLevels( _x: pSExp; _l: pSExp );
procedure rdSetNames( _x: pSExp; _name: pSExp );
function rdGetLength( _x: pSExp ): integer;
procedure rdSetLength( var _x: pSExp; _v: integer );

function rdGetSlot( _x: pSExp; _what: pSExp ): pSExp;
procedure rdSetSlot( _x: pSExp; _what: pSExp; _value: pSExp );

function rdMakeClass( _what: pSExp ): pSExp;
  { NEW_OBJECT is recommended; NEW is for green book compatibility }
function rdNewObject( _classDef: pSExp ): pSExp;
function rdNew( _classDef: pSExp ): pSExp;

type
{ TODO -ohp -cfixme : Is this ok? (original is SEXPREC which is the record???) }
  aSObject = pSExp;

function rdCopyToUserString( _x: pChar ): pSExp;
function rdCreateStringVector( _x: pChar ): pSExp;

{ TODO -ohp -caskRdevel : CreateFunctionCall is not defined anywhere }
//#define CREATE_FUNCTION_CALL(name, argList) createFunctionCall(name, argList)

function rdEval( _e: pSExp ): pSExp;

{==============================================================================}
implementation


function rdAsLogical( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setLglSxp );
  end;
function rdAsInteger( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setIntSxp );
  end;
function rdAsNumeric( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setRealSxp );
  end;
function rdAsCharacter( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setStrSxp );
  end;
function rdAsComplex( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setCplxSxp );
  end;
function rdAsVector( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setVecSxp );
  end;
function rdAsList( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setVecSxp );
  end;
function rdAsRaw( _x: pSExp ): pSExp;
  begin
    result:= riCoerceVector( _x, setRawSxp );
  end;

function rdIsLogical( _x: pSExp ): aRBoolean;
  begin
    result:= riIsLogical( _x );
  end;
function rdIsInteger( _x: pSExp ): aRBoolean;
  begin
    result:= riIsInteger( _x );
  end;
function rdIsNumeric( _x: pSExp ): aRBoolean;
  begin
    result:= riIsReal( _x );
  end;
function rdIsCharacter( _x: pSExp ): aRBoolean;
  begin
    result:= riIsString( _x );
  end;
function rdIsComplex( _x: pSExp ): aRBoolean;
  begin
    result:= riIsComplex( _x );
  end;
function rdIsVector( _x: pSExp ): aRBoolean;
  begin
    result:= riIsVector( _x );
  end;
function rdIsList( _x: pSExp ): aRBoolean;
  begin
    result:= riIsVector( _x );
  end;
function rdIsRaw( _x: pSExp ): aRBoolean;
  begin
    result:= riTypeOf( _x ) = setRawSxp;
  end;

function rdNewLogical( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setLglSxp, _n );
  end;
function rdNewInteger( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setIntSxp, _n );
  end;
function rdNewNumeric( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setReaLsxP, _n );
  end;
function rdNewCharacter( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setStrSxp, _n );
  end;
function rdNewComplex( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setCplXsxP, _n );
  end;
function rdNewList( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setVecSxp, _n );
  end;
function rdNewString( _n: aRlen ): pSExp;
  begin
    result:= rdNewcharacter( _n );
  end;
function rdNewRaw( _n: aRlen ): pSExp;
  begin
    result:= riAllocVector( setRawSxp, _n );
  end;

function rdLogicalPointer( _x: pSExp ): pIntegerArr;
  begin
    result:= riLogical( _x );
  end;
function rdIntegerPointer( _x: pSExp ): pIntegerArr;
  begin
    result:= riInteger( _x );
  end;
function rdNumericPointer( _x: pSExp ): pDoubleArr;
  begin
    result:= riReal( _x );
  end;
function rdCharacterPointer( _x: pSExp ): aSexpArr;
  begin
    result:= riStringPtr( _x );
  end;
function rdComplexPointer( _x: pSExp ): pRComplexArr;
  begin
    result:= riComplex( _x );
  end;
function rdListPointer( _x: pSExp ): aSexpArr;
  begin
    result:= riVectorPtr( _x );
  end;
function rdRawPointer( _x: pSExp ): pRByte;
  begin
    result:= riRaw( _x );
  end;

  { The following are not defined in `Programming with Data' but are
    defined in S.h in Svr4 }

function rdLogicalData( _x: pSExp ): pIntegerArr;
  begin
    result:= riLogical( _x );
  end;
function rdIntegerData( _x: pSExp ): pIntegerArr;
  begin
    result:= riInteger( _x );
  end;
function rdDoubleData( _x: pSExp ): pDoubleArr;
  begin
    result:= riReal( _x );
  end;
function rdNumericData( _x: pSExp ): pDoubleArr;
  begin
    result:= riReal( _x );
  end;
function rdCharacterData( _x: pSExp ): aSexpArr;
  begin
    result:= riStringPtr( _x );
  end;
function rdComplexData( _x: pSExp ): pRComplexArr;
  begin
    result:= riComplex( _x );
  end;
function rdRecursiveData( _x: pSExp ): aSexpArr;
  begin
    result:= riVectorPtr( _x );
  end;
function rdVectorData( _x: pSExp ): aSexpArr;
  begin
    result:= riVectorPtr( _x );
  end;

function rdLogicalValue( _x: pSExp ): integer;
  begin
    result:= riAsLogical( _x );
  end;
function rdIntegerValue( _x: pSExp ): integer;
  begin
    result:= riAsInteger( _x );
  end;
function rdNumericValue( _x: pSExp ): double;
  begin
    result:= riAsReal( _x );
  end;
function rdCharacterValue( _x: pSExp ): pChar;
  begin
    result:= riChar( riAsChar( _x ) );
  end;
function rdStringValue( _x: pSExp ): pChar;
  begin
    result:= riChar( riAsChar( _x ) );
  end;
procedure rdSetElement( _x: pSExp; _i: integer; _val: pSExp);
  begin
    riSetVectorElt( _x, _i, _val);
  end;
function rdGetAttr( _x: pSExp; _what: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, _what );
  end;
function rdGetClass( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RClassSymbol );
  end;
function rdGetDim( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RDimSymbol );
  end;
function rdGetDimnames( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RDimNamesSymbol );
  end;
function rdGetColnames( _x: pSExp ): pSExp;
  begin
    result:= riGetColNames( _x);
  end;
function rdGetRownames( _x: pSExp ): pSExp;
  begin
    result:= riGetRowNames( _x);
  end;
function rdGetLevels( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RLevelsSymbol );
  end;
function rdGetTsp( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RTspSymbol );
  end;
function rdGetNames( _x: pSExp ): pSExp;
  begin
    result:= riGetAttrib( _x, RNamesSymbol );
  end;
procedure rdSetClass( _x: pSExp; _name: pSExp );
  begin
    riSetAttrib( _x, RClassSymbol, _name );
  end;
procedure rdSetDim( _x: pSExp; _name: pSExp );
  begin
    riSetAttrib( _x, RDimSymbol, _name );
  end;
procedure rdSetDimnames( _x: pSExp ; _name: pSExp);
  begin
    riSetAttrib( _x, RDimNamesSymbol, _name );
  end;
procedure rdSetLevels( _x: pSExp; _l: pSExp );
  begin
    riSetAttrib( _x, RLevelsSymbol, _l );
  end;
procedure rdSetNames( _x: pSExp; _name: pSExp );
  begin
    riSetAttrib( _x, RNamesSymbol, _name );
  end;
function rdGetLength( _x: pSExp ): integer;
  begin
    result:= riLength( _x );
  end;
procedure rdSetLength( var _x: pSExp; _v: integer );
  begin
  { TODO -ohp -cfixme : not sure if this is ok }
    _x:=  riLengthgets( _x, _v );
  end;
function rdGetSlot( _x: pSExp; _what: pSExp ): pSExp;
  begin
    result:= riDoSlot( _x, _what );
  end;
procedure rdSetSlot( _x: pSExp; _what: pSExp; _value: pSExp );
  begin
    riDoSlotAssign( _x, _what, _value );
  end;
function rdMakeClass( _what: pSExp ): pSExp;
  begin
    result:= riDoMakeClass( _what );
  end;

  { NEW_OBJECT is recommended; NEW is for green book compatibility }
function rdNewObject( _classDef: pSExp ): pSExp;
  begin
    result:= riDoNewObject( _classDef );
  end;
function rdNew( _classDef: pSExp ): pSExp;
  begin
    result:= riDoNewObject( _classDef );
  end;


function rdCopyToUserString( _x: pChar ): pSExp;
  begin
    result:= riMkChar( _x );
  end;
function rdCreateStringVector( _x: pChar ): pSExp;
  begin
    result:= riMkChar( _x );
  end;

{ TODO -ohp -caskRdevel : CreateFunctionCall is not defined anywhere }
//#define CREATE_FUNCTION_CALL(name, argList) createFunctionCall(name, argList)

function rdEval( _e: pSExp ): pSExp;
  begin
    result:= riEval( _e, RGlobalEnv );
  end;

function LoadNullUserObject: boolean;
  begin
    result:= Assigned( RNilValue );
    if result then rhRDefines.NullUserObject:= RNilValue;
  end {LoadNullUserObject};


end {rhRDefines}.

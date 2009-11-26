unit rhRInternals;

{ Pascal (Delphi) translation of the R headerfile Rinternals.h.
  (https://svn.r-project.org/R/trunk/src/include/Rinternals.h). 
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

type
  aProtectIndex = integer;

const
  TheRLenMax = MaxInt;

{---------------------------------------------------------- sxpinfo_struct }
const
  TheSetFunSxp = 99;                          // warning in tthRUseInternals.aSxpInfo
type
    { The $Z4 directive tells Delphi to store the enumeration type as an
      unsigned double-word which conforms with "typedef unsigned int SEXPTYPE" }
{$Z4}
  aSExpType = ( setNilSxp     =  0            // nil = NULL
              , setSymSxp     =  1            // symbols
              , setListSxp    =  2            // lists of dotted pairs
              , setCloSxp     =  3            // closures
              , setEnvSxp     =  4            // environments
              , setPromSxp    =  5            // promises: [un]evaluated closure arguments
              , setLangSxp    =  6            // language constructs (special lists)
              , setSpecialSxp =  7            // special forms
              , setBuiltinSxp =  8            // builtin non-special forms
              , setCharSxp    =  9            // scalar" string type (internal only
              , setLglSxp     = 10            // logical vectors
              , setIntSxp     = 13            // integer vectors
              , setRealSxp    = 14            // real variables
              , setCplxSxp    = 15            // complex variables
              , setStrSxp     = 16            // string vectors
              , setDotSxp     = 17            // dot-dot-dot object
              , setAnySxp     = 18            // make "any" args work. Used in specifying types for symbol registration to mean anything is okay
              , setVecSxp     = 19            // generic vectors
              , setExprSxp    = 20            // expressions vectors
              , setBcodeSxp   = 21            // byte code
              , setExtptrSxp  = 22            // external pointer
              , setWeakrefSxp = 23            // weak reference
              , setRawSxp     = 24            // raw bytes
              , setFunSxp     = TheSetFunSxp  // Closure or Builtin or Special
              );

function SExpTypeToStr( _type: aSExpType ): string; overload;
function SExpTypeToStr( _type: integer ): string; overload;

{----------------------------------------------------------}
type
  { TODO -ohp -caskRDevel : I don't understand why the aliasing
    "typedef struct SEXPREC *SEXP;" does work.
    (SEXP is a an alias of a pointer to the SEXPREC structure. So all occurences
    of SEXP will be replaced by the preprocessor which leads to the symbol *SEXPREC.
    How/where this is defined? The only occurence of SEXPREC that I could find was
    in the USE_INTERNAL section which isn't used (we are in the else part!) ??? }
  ppSExp = ^pSExp;
  pSExp = pointer;
  { TODO -ohp -cfixme : not sure, if aSExpArr works/is necessary }
  aSExpArr = array[0..(MaxInt div SizeOf( pSExp )) - 1 - theArrOff] of pSExp;
  aSExpFunc = function(): pSExp; cdecl;


{---------------------------------------------------------- a solitude function }

{ TODO -ohp -csometimes : CHAR is also defined as R_Char and should therefore
  become RChar. Because other definitions are called REAL, INTEGER etc. it
  seems better to use CHAR alone }
function riChar( _x: pSExp ): pChar; cdecl;


{---------------------------------------------------------- types and constants
                                                            for functions below }
{ misc }

type
  { TODO -ohp -cfixme : Same remark as for pSExp }
  pRConnection = pointer;

  aAttrGetter = function( _x, _data: pSExp ): pSExp; cdecl;
  aStringEltGetter = function( _x: pSExp; _i: integer ): pSExp; cdecl;
  aRCFinalizer = procedure( _fun: pSExp ); cdecl;
  aToplevelExec = procedure( _fun: pointer ); cdecl;

{ save/load interface }

const
  theRXdrDoubleSize = 8;
  theRXdrIntegerSize = 4;

type
  aPStreamData = pointer;
  aPStreamFormat = ( rpfAny, rpfAscii, rpfBinary, rpfXdr );

  pInPStream = ^aInPStream;
  pOutPStream = ^aOutPStream;

  aInChar = procedure( _stream: pInPStream; _c: integer ); cdecl;
  aInBytes = procedure( _stream: pInPStream; _buffer: pointer; _c: integer ); cdecl;
  aOutChar = procedure( _stream: pOutPStream; _c: integer ); cdecl;
  aOutBytes = procedure( _stream: pOutPStream; _buffer: pointer; _c: integer ); cdecl;
    { TODO -ohp -cfixme : Unsure about the arguments of aOutPersistHookFunc }
  aInOutPersistHookFunc = function( _s, _stream: pSExp ): pSExp; cdecl;

  aInPStream = packed record
    ipsData: aPStreamData;
    ipsType_: aPStreamFormat;
    ipsVersion: integer;
    ipsInChar: aInChar;
    ipsInBytes: aInBytes;
    ipsInPersistHookFunc: aInOutPersistHookFunc;
    ipsInPersistHookData: pSExp;
  end;

  aOutPStream = packed record
    opsData: aPStreamData;
    opsType_: aPStreamFormat;
    opsVersion: integer;
    opsOutChar: aOutChar;
    opsOutBytes: aOutBytes;
    opsOutPersistHookFunc: aInOutPersistHookFunc;
    opsOutPersistHookData: pSExp;
  end;


{---------------------------------------------------------- Accessor functions }

{ General Cons Cell Attributes }

function riAttrib( _x: pSExp ): pSExp; cdecl;
function riObject( _x: pSExp ): integer; cdecl;
function riMark( _x: pSExp ): integer; cdecl;
function riTypeOf( _x: pSExp ): aSExpType; cdecl;
function riNamed( _x: pSExp ): integer; cdecl;
procedure riSetObject( _x: pSExp; _v: integer ); cdecl;
procedure riSetTypeof( _x: pSExp; _v: aSExpType ); cdecl;
procedure riSetNamed( _x: pSExp; _v: integer ); cdecl;

{ Vector Access Macros }

function riLength( _x: pSExp ): integer; cdecl;
function riTruelength( _x: pSExp ): integer; cdecl;
procedure riSetLength( _x: pSExp; _v: integer ); cdecl;
procedure riSetTruelength( _x: pSExp; _v: integer ); cdecl;
function riLevels( _x: pSExp ): integer; cdecl;
function riSetLevels( _x: pSExp; _v: integer ): integer; cdecl;

function riLogical( _x: pSExp ): pIntegerArr; cdecl;
function riInteger( _x: pSExp ): pIntegerArr; cdecl;
function riRaw( _x: pSExp ): pRByte; cdecl;
function riReal( _x: pSExp ): pDoubleArr; cdecl;
function riComplex( _x: pSExp ): pRcomplexArr; cdecl;
function riStringElt( _x: pSExp; _i: integer ): pSExp; cdecl;
function riVectorElt( _x: pSExp; _i: integer ): pSExp; cdecl;
procedure riSetStringElt( _x: pSExp; _i: integer; _v: pSExp ); cdecl;
procedure riSetVectorElt( _x: pSExp; _i: integer; _v: pSExp ); cdecl;
function riStringPtr( _x: pSExp ): aSExpArr; cdecl;
function riVectorPtr( _x: pSExp ): aSExpArr; cdecl;

{ List Access Macros (These also work for ... objects) }

function riTag( _x: pSExp ): pSExp; cdecl;
function riCar( _x: pSExp ): pSExp; cdecl;
function riCdr( _x: pSExp ): pSExp; cdecl;
function riCaar( _x: pSExp ): pSExp; cdecl;
function riCdar( _x: pSExp ): pSExp; cdecl;
function riCadr( _x: pSExp ): pSExp; cdecl;
function riCddr( _x: pSExp ): pSExp; cdecl;
function riCaddr( _x: pSExp ): pSExp; cdecl;
function riCadddr( _x: pSExp ): pSExp; cdecl;
function riCad4r( _x: pSExp ): pSExp; cdecl;
function riMissing( _x: pSExp ): pSExp; cdecl;
procedure riSetMissing( _x: pSExp; _v: integer ); cdecl;
function riSetTag( _x, _v: pSExp ): pSExp; cdecl;
function riSetCar( _x, _v: pSExp ): pSExp; cdecl;
function riSetCdr( _x, _v: pSExp ): pSExp; cdecl;
function riSetCadr( _x, _v: pSExp ): pSExp; cdecl;
function riSetCaddr( _x, _v: pSExp ): pSExp; cdecl;
function riSetCadddr( _x, _v: pSExp ): pSExp; cdecl;
function riSetCad4r( _x, _v: pSExp ): pSExp; cdecl;

{ Closure Access Macros }

function riFormals( _x: pSExp ): pSExp; cdecl;
function riBody( _x: pSExp ): pSExp; cdecl;
function riCloenv( _x: pSExp ): pSExp; cdecl;
function riDebug( _x: pSExp ): integer; cdecl;
function riTrace( _x: pSExp; _v: integer ): integer; cdecl;
procedure riSetDebug( _x: pSExp; _v: integer ); cdecl;
procedure riSetTrace( _x: pSExp; _v: integer ); cdecl;
procedure riSetFormals( _x, _v: pSExp ); cdecl;
procedure riSetBody( _x, _v: pSExp ); cdecl;
procedure riSetCloenv( _x, _v: pSExp ); cdecl;

{ Symbol Access Macros }

function riPrintName( _x: pSExp ): pSExp; cdecl;
function riSymvalue( _x: pSExp ): pSExp; cdecl;
function riInternal( _x: pSExp ): pSExp; cdecl;
function riDdval( _x: pSExp ): integer; cdecl;
function riSetDdval( _x: pSExp; _v: integer ): pSExp; cdecl;
function riSetPrintname( _x, _v: pSExp ): pSExp; cdecl;
procedure riSetSymvalue( _x, _v: pSExp ); cdecl;
procedure riSetInternal( _x, _v: pSExp ); cdecl;

{ Environment Access Macros }

function riFrame( _x: pSExp ): pSExp; cdecl;
function riEnclos( _x: pSExp ): pSExp; cdecl;
function riHashtab( _x: pSExp ): pSExp; cdecl;
function riEnvflags( _x: pSExp ): integer; cdecl;
procedure riSetFrame( _x, _v: pSExp ); cdecl;
procedure riSetEnclos( _x, _v: pSExp ); cdecl;
procedure riSetHashtab( _x, _v: pSExp ); cdecl;
procedure riSetEnvflags( _x: pSExp; _v: integer ); cdecl;

{ Promise Access Macros }

function riPrcode( _x: pSExp ): pSExp; cdecl;
function riPrenv( _x: pSExp ): pSExp; cdecl;
function riPrvalue( _x: pSExp ): pSExp; cdecl;
function riPrseen( _x: pSExp ): integer; cdecl;
procedure riSetPrenv( _x, _v: pSExp ); cdecl;
procedure riSetPrvalue( _x, _v: pSExp ); cdecl;
procedure riSetPrcode( _x, _v: pSExp ); cdecl;
procedure riSetPrseen( _x: pSExp; _v: integer ); cdecl;

{ Hashing Macros }

function riHashash( _x: pSExp ): integer; cdecl;
function riHashvalue( _x: pSExp ): integer; cdecl;
procedure riSetHashash( _x: pSExp; _v: integer ); cdecl;
procedure riSetHashvalue( _x: pSExp; _v: integer ); cdecl;

{ External pointer access macros }

function riExtptrPtr( _x: pSExp ): pSExp;     // calls riCar
function riExtptrProt( _x: pSExp ): pSExp;    // calls riCdr
function riExtptrTag( _x: pSExp ): pSExp;     // calls riTag

{ Bytecode access macros }

function riBcodeCode( _x: pSExp ): pSExp;     // calls riCar
function riBcodeConsts( _x: pSExp ): pSExp;   // calls riCdr
function riBcodeExpr( _x: pSExp ): pSExp;     // calls riTag
function riIsBytecode( _x: pSExp ): boolean;

{ Skipped pointer protection macro declaration, see real declaration below }


{---------------------------------------------------------- global variables }

var
    { Evaluation Environment }
  RGlobalEnv: pSExp = nil;
  REmptyEnv: pSExp = nil;
  RBaseEnv: pSExp = nil;
  RBaseNamespace: pSExp = nil;
  RNamespaceRegistry: pSExp = nil;

    { Special Values }
  RNilValue: pSExp = nil;
  RUnboundValue: pSExp = nil;
  RMissingArg: pSExp = nil;
  RRestartToken: pSExp = nil;

    { Symbol Table Shortcuts }
  RBracket2Symbol: pSExp = nil;     // "[["
  RBracketSymbol: pSExp = nil;      // "["
  RBraceSymbol: pSExp = nil;        // "{"
  RTmpvalSymbol: pSExp = nil;       // "*tmp*"
  RClassSymbol: pSExp = nil;	      // "class"
  RDimNamesSymbol: pSExp = nil;     // "dimnames"
  RDimSymbol: pSExp = nil;	        // "dim"
  RDollarSymbol: pSExp = nil;	      // "$"
  RDotsSymbol: pSExp = nil;	        // "..."
  RDropSymbol: pSExp = nil;	        // "drop"
  RLevelsSymbol: pSExp = nil;	      // "levels"
  RModeSymbol: pSExp = nil;	        // "mode"
  RNamesSymbol: pSExp = nil;	      // "names"
  RNaRmSymbol: pSExp = nil;	        // "na.rm"
  RRowNamesSymbol: pSExp = nil;     // "row.names"
  RSeedsSymbol: pSExp = nil;	      // ".Random.seed"
  RTspSymbol: pSExp = nil;	        // "tsp"
  RLastvalueSymbol: pSExp = nil;    // ".Last.value"
  RCommentSymbol: pSExp = nil;      // "comment"
  RSourceSymbol: pSExp = nil;       // "source"
  RDotEnvSymbol: pSExp = nil;       // ".Environment"
  RRecursiveSymbol: pSExp = nil;    // "recursive"
  RUseNamesSymbol: pSExp = nil;     // "use.names"

    { Missing Values - others from Arith.h }
  RNaString: pSExp;                   // NA_STRING as a CHARSXP
  RBlankString: pSExp;                // "" as a CHAR§SXP

{ Support for variable initialization }

type
  aVarRinternals =      ( vriRGlobalEnv, vriREmptyEnv, vriRBaseEnv, vriRBaseNamespace
                        , vriRNamespaceRegistry, vriRNilValue, vriRUnboundValue
                        , vriRMissingArg, vriRRestartToken, vriRBracket2Symbol
                        , vriRBracketSymbol, vriRBraceSymbol, vriRTmpvalSymbol
                        , vriRClassSymbol, vriRDimNamesSymbol, vriRDimSymbol
                        , vriRDollarSymbol, vriRDotsSymbol, vriRDropSymbol
                        , vriRLevelsSymbol, vriRModeSymbol, vriRNamesSymbol
                        , vriRNaRmSymbol, vriRRowNamesSymbol, vriRSeedsSymbol
                        , vriRTspSymbol, vriRLastvalueSymbol, vriRCommentSymbol
                        , vriRSourceSymbol, vriRDotEnvSymbol, vriRRecursiveSymbol
                        , vriRUseNamesSymbol, vriRNaString, vriRBlankString );
  aLoadVarRInternals =  set of aVarRInternals;

const
  TheVarRInternalsName: array[aVarRinternals] of string
                        = ( 'R_GlobalEnv', 'R_EmptyEnv', 'R_BaseEnv', 'R_BaseNamespace'
                          , 'R_NamespaceRegistry', 'R_NilValue', 'R_UnboundValue'
                          , 'R_MissingArg', 'R_RestartToken', 'R_Bracket2Symbol'
                          , 'R_BracketSymbol', 'R_BraceSymbol', 'R_TmpvalSymbol'
                          , 'R_ClassSymbol', 'R_DimNamesSymbol', 'R_DimSymbol'
                          , 'R_DollarSymbol', 'R_DotsSymbol', 'R_DropSymbol'
                          , 'R_LevelsSymbol', 'R_ModeSymbol', 'R_NamesSymbol'
                          , 'R_NaRmSymbol', 'R_RowNamesSymbol', 'R_SeedsSymbol'
                          , 'R_TspSymbol', 'R_LastvalueSymbol', 'R_CommentSymbol'
                          , 'R_SourceSymbol', 'R_DotEnvSymbol', 'R_RecursiveSymbol'
                          , 'R_UseNamesSymbol', 'R_NaString', 'R_BlankString' );

  TheVarRInternalsPtr:  array[aVarRinternals] of pointer
                        = ( @RGlobalEnv, @REmptyEnv, @RBaseEnv, @RBaseNamespace
                          , @RNamespaceRegistry, @RNilValue, @RUnboundValue
                          , @RMissingArg, @RRestartToken, @RBracket2Symbol
                          , @RBracketSymbol, @RBraceSymbol, @RTmpvalSymbol
                          , @RClassSymbol, @RDimNamesSymbol, @RDimSymbol
                          , @RDollarSymbol, @RDotsSymbol, @RDropSymbol
                          , @RLevelsSymbol, @RModeSymbol, @RNamesSymbol
                          , @RNaRmSymbol, @RRowNamesSymbol, @RSeedsSymbol
                          , @RTspSymbol, @RLastvalueSymbol, @RCommentSymbol
                          , @RSourceSymbol, @RDotEnvSymbol, @RRecursiveSymbol
                          , @RUseNamesSymbol, @RNaString, @RBlankString );

  TheLoadVarRInternals: aLoadVarRInternals
                        = [ vriRGlobalEnv, vriRBaseEnv, vriRBaseNamespace
                          , vriRNamespaceRegistry, vriRNilValue, vriRUnboundValue
                          , vriRMissingArg, vriRRestartToken, vriRBracket2Symbol
                          , vriRBracketSymbol, vriRBraceSymbol, vriRTmpvalSymbol
                          , vriRClassSymbol, vriRDimNamesSymbol, vriRDimSymbol
                          , vriRDollarSymbol, vriRDotsSymbol, vriRDropSymbol
                          , vriRLevelsSymbol, vriRModeSymbol, vriRNamesSymbol
                          , vriRNaRmSymbol, vriRRowNamesSymbol, vriRSeedsSymbol
                          , vriRTspSymbol, vriRLastvalueSymbol, vriRCommentSymbol
                          , vriRSourceSymbol, vriRDotEnvSymbol, vriRRecursiveSymbol
                          , vriRUseNamesSymbol, vriRNaString, vriRBlankString ];
{ TODO -ohp -csometimes : "vriREmptyEnv" didn't load and we left it out, maybe
                          I could check this with the newsgroup  }

function ToRVarsArr( _set: aLoadVarRInternals): aRVarsArr; overload;

{---------------------------------------------------------- functions }

{ Type Coercions of all kinds }

function riAsChar( _x: pSExp ): pSExp; cdecl;
function riAsCommon( _call: pSExp; _u: pSExp; _type: aSExpType ): pSExp; cdecl;
function riCoerceVector( _v: pSExp; _type: aSExpType ): pSExp; cdecl;
{ TODO -ohp -caskRdevel : no entry point for Rf_coerceList }
//function riCoerceList( _v: pSExp; _type: aSExpType ): pSExp; cdecl;
procedure riCoercionWarning( _warn: integer ); cdecl;
function riPairToVectorList( _x: pSExp ): pSExp; cdecl;
function riVectorToPairList( _x: pSExp ): pSExp; cdecl;

function riLogicalFromInteger( _x: integer; var _warn: integer ): integer; cdecl;
function riLogicalFromReal( _x: double; var _warn: integer ): integer; cdecl;
function riLogicalFromComplex( _x: aRComplex; var _warn: integer ): integer; cdecl;
function riLogicalFromString( _x: pSExp; var _warn: integer): integer; cdecl;
function riIntegerFromLogical( _x: integer; var _warn: integer ): integer; cdecl;
function riIntegerFromReal( _x: double; var _warn: integer): integer; cdecl;
function riIntegerFromComplex( _x: aRComplex; var _warn: integer ): integer; cdecl;
function riIntegerFromString( _x: pSExp; var _warn: integer ): integer; cdecl;
function riRealFromLogical( _x: integer; var _warn: integer ): double; cdecl;
function riRealFromInteger( _x: integer; var _warn: integer ): double; cdecl;
function riRealFromComplex( _x: aRComplex; var _warn: integer ): double; cdecl;
function riRealFromString( _x: pSExp; var _warn: integer ): double; cdecl;
function riComplexFromLogical( _x: integer; var _warn: integer ): aRComplex; cdecl;
function riComplexFrominteger( _x: integer; var _warn: integer ): aRComplex; cdecl;
function riComplexFromReal( _x: double; var _warn: integer ): aRComplex; cdecl;
function riComplexFromString( _x: pSExp; var _warn: integer ): aRComplex; cdecl;
function riStringFromLogical( _x: integer; var _warn: integer ): pSExp; cdecl;
function riStringFromInteger( _x: integer; var _warn: integer ): pSExp; cdecl;
function riStringFromReal( _x: double; var _warn: integer ): pSExp; cdecl;
function riStringFromComplex( _x: aRComplex; var _warn: integer ): pSExp; cdecl;
function riEnsureString( _s: pSExp ): pSExp; cdecl;

{ Other Internally Used Functions }

function riAllocArray( _mode: aSExpType; _dims: pSExp ): pSExp; cdecl;
function riAllocMatrix( _mode: aSExpType; _nrow: integer; _ncol: integer ): pSExp; cdecl;
function riAllocList( _n: integer ): pSExp; cdecl;
function riAllocSExp( _type: aSExpType ): pSExp; cdecl;
function riAllocVector( _type: aSExpType; _length: aRLen ): pSExp; cdecl;
function riApplyClosure( _call: pSExp; _op: pSExp; _arglist: pSExp;
    _rho: pSExp; _suppliedEnv: pSExp ): pSExp; cdecl;
function riArraySubscript( _dim: integer; _s: pSExp; _dims: pSExp;
    _dng: aAttrGetter; _strg: aStringEltGetter; _x: pSExp ): pSExp; cdecl;
function riAsVecSize( _x: pSExp ): aRLen; cdecl;
function riClassgets( _vec: pSExp; _class: pSExp ): pSExp; cdecl;
function riCons( _car: pSExp; _cdr: pSExp ): pSExp; cdecl;
procedure riCopyListMatrix( _s: pSExp; _t: pSExp; _byRow: aRBoolean ); cdecl;
procedure riCopyMatrix( _s: pSExp; _t: pSExp; _byRow: aRBoolean ); cdecl;
procedure riCopyMostAttrib( _inp: pSExp; _ans: pSExp ); cdecl;
procedure riCopyMostAttribNoTs( _inp: pSExp; _ans: pSExp ); cdecl;
procedure riCopyVector( _s: pSExp; _t: pSExp ); cdecl;
function riCreateTag( _x: pSExp ): pSExp; cdecl;
procedure riCustomPrintValue( _s: pSExp; _env: pSExp ); cdecl;
procedure riDefineVar( _symbol: pSExp; _value: pSExp; _rho: pSExp ); cdecl;
function riDimgets( _vec: pSExp; _val: pSExp ): pSExp; cdecl;
function riDimnamesgets( _vec: pSExp; _val: pSExp ): pSExp; cdecl;
function riDropDims( _x: pSExp ): pSExp; cdecl;
function riDuplicate( _s: pSExp ): pSExp; cdecl;
function riDuplicated( _x: pSExp ): pSExp; cdecl;
function riEval( _e: pSExp; _rho: pSExp ): pSExp; cdecl;
function riEvalArgs( _el: pSExp; _rho: pSExp; _dropMissing: integer): pSExp; cdecl;
function riEvalList( _el: pSExp; _rho: pSExp ): pSExp; cdecl;
function riEvalListKeepMissing( _el: pSExp; _rho: pSExp ): pSExp; cdecl;
function riFindFun( _xymbol: pSExp; _rho: pSExp ): pSExp; cdecl;
function riFindVar( _symbol: pSExp; _rho: pSExp ): pSExp; cdecl;
function riFindVarInFrame( _rho: pSExp; _symbol: pSExp ): pSExp; cdecl;
function riFindVarInFrame3( _rho: pSExp; _symbol: pSExp; _doGet: aRBoolean): pSExp; cdecl;
function riGetAttrib( _vec: pSExp; _name: pSExp ): pSExp; cdecl;
function riGetArrayDimnames( _x: pSExp ): pSExp; cdecl;
function riGetColnames( _dimnames: pSExp ): pSExp; cdecl;
procedure riGetMatrixDimnames( _x: pSExp; var _rl: pSExp; var _cl: pSExp;
    var _rn: PChar; var _cn: PChar); cdecl;
function riGetOption( _tag: pSExp; _rho: pSExp ): pSExp; cdecl;
function riGetOptionDigits( _rho: pSExp ): integer; cdecl;
function riGetOptionWidth( _rho: pSExp ): integer; cdecl;
function riGetRownames( _dimnames: pSExp ): pSExp; cdecl;
procedure riGsetVar( _symbol: pSExp; _value: pSExp; _rho: pSExp ); cdecl;
function riInstall( _name: PChar): pSExp; cdecl;
function riIsFree( _val: pSExp ): aRBoolean; cdecl;
function riIsFunction( _val: pSExp ): aRBoolean; cdecl;
function riIsUnsorted( _x: pSExp ): aRBoolean; cdecl;
function riItemName( _names: pSExp; _i: integer): pSExp; cdecl;
function riLengthgets( _x: pSExp; _length: aRLen): pSExp; cdecl;
function riMakeSubscript( _x: pSExp; _s: pSExp; var _stretch: integer): pSExp; cdecl;
function riMatch( _itable: pSExp; _ix: pSExp; _nmatch: integer): pSExp; cdecl;
function riMatchArg( _tag: pSExp; var _list: pSExp ): pSExp; cdecl;
function riMatchArgExact( _tag: pSExp; var _list: pSExp ): pSExp; cdecl;
function riMatchArgs( _formals: pSExp; _supplied: pSExp ): pSExp; cdecl;
function riMatchPar( _tag: PChar; var _list: pSExp ): pSExp; cdecl;
function riNamesgets( _vec: pSExp; _val: pSExp ): pSExp; cdecl;
function riNonNullStringMatch( _s: pSExp; _t: pSExp ): aRBoolean; cdecl;
function riNcols( _s: pSExp ): integer; cdecl;
function riNrows( _s: pSExp ): integer; cdecl;
function riNthcdr( _s: pSExp; _n: integer): pSExp; cdecl;
function riPmatch( _formal: pSExp; _tag: pSExp; _exact: aRBoolean): aRBoolean; cdecl;
function riPsmatch( _f: PChar; _t: PChar; _exact: aRBoolean): aRBoolean; cdecl;
procedure riPrintDefaults( _rho: pSExp ); cdecl;
procedure riPrintValue( _s: pSExp ); cdecl;
procedure riPrintValueEnv( _s: pSExp; _env: pSExp ); cdecl;
procedure riPrintValueRec( _s: pSExp; _env: pSExp ); cdecl;
function riProtect( _s: pSExp ): pSExp; cdecl;
{ TODO -ohp -cfixme : Strange, rownamesgets is nowhere to be found in the sources }
//function riRownamesgets( _1: pSExp; _2: pSExp ): pSExp; cdecl;
function riSetAttrib( _vec: pSExp; _name: pSExp; _val: pSExp ): pSExp; cdecl;
procedure riSetSVector( var _vec: pSExp; _len: integer; _val: pSExp ); cdecl;
procedure riSetVar( _symbol: pSExp; _value: pSExp; _rho: pSExp ); cdecl;
function riStringBlank( _x: pSExp ): aRBoolean; cdecl;
function riSubstitute( _lang: pSExp; _rho: pSExp ): pSExp; cdecl;
function riTryEval( e: pSExp; env: pSExp; var ErrorOccurred: integer): pSExp; cdecl;
procedure riUnprotect( _l: integer); cdecl;
procedure riUnprotect_ptr( _s: pSExp ); cdecl;
function riVectorSubscript( _nx: integer; _s: pSExp; _stretch: pSExp;
    _dng: aAttrGetter; _str: aStringEltGetter; _x: pSExp ): pSExp; cdecl;
procedure riProtectWithIndex( _s: pSExp; var _pi: aProtectIndex ); cdecl;
procedure riReprotect( _s: pSExp; var _i: aProtectIndex ); cdecl;
function riSubassign3_dflt( _call: pSExp; _x: pSExp; _nlist: pSExp; _val: pSExp ): pSExp; cdecl;
function riSubset3_dflt( _x: pSExp; _input: pSExp ): pSExp; cdecl;

function riError_return( _msg: pchar ): pSExp;
function riErrorcall_return( _call: pSExp; _format: pchar ): pSExp;


{---------------------------------------------------------- more functions }

{ External pointer interface }

function riMakeExternalPtr( _p: pointer; _tag: pSExp; _prot: pSExp ): pSExp; cdecl;
function riExternalPtrAddr( _s: pSExp ): pointer; cdecl;
function riExternalPtrTag( _s: pSExp ): pSExp; cdecl;
function riExternalPtrProtected( _s: pSExp ): pSExp; cdecl;
procedure riClearExternalPtr( _s: pSExp ); cdecl;
procedure riSetExternalPtrAddr( _s: pSExp; _p: pointer); cdecl;
procedure riSetExternalPtrTag( _s: pSExp; _tag: pSExp ); cdecl;
procedure riSetExternalPtrProtected( _s: pSExp; _p: pSExp ); cdecl;

{ Finalization interface }

procedure riRegisterFinalizer( _s: pSExp; _fun: pSExp ); cdecl;
procedure riRegisterCFinalizer( _s: pSExp; _fun: aRCFinalizer ); cdecl;
procedure riRegisterFinalizerEx( _s: pSExp; _fun: pSExp; _onexit: aRBoolean ); cdecl;
procedure riRegisterCFinalizerEx( _s: pSExp; _fun: aRCfinalizer; _onexit: aRBoolean ); cdecl;

{ Weak reference interface }

function riMakeWeakRef( _key: pSExp; _val: pSExp; _fin: pSExp; _onexit: aRBoolean): pSExp; cdecl;
function riMakeWeakRefC( _key: pSExp; _val: pSExp; _fin: aRcfinalizer; _onexit: aRBoolean): pSExp; cdecl;
function riWeakRefKey( _w: pSExp ): pSExp; cdecl;
function riWeakRefValue( _w: pSExp ): pSExp; cdecl;
procedure riRunWeakRefFinalizer( _w: pSExp ); cdecl;

function riPromiseExpr( _p: pSExp ): pSExp; cdecl;
function riClosureExpr( _p: pSExp ): pSExp; cdecl;
procedure riInitializeBcode; cdecl;
function riBcEncode( _bytes: pSExp ): pSExp; cdecl;
function riBcDecode( _bytes: pSExp ): pSExp; cdecl;
  { TODO -ohp -cfixme : PREXPR and BODY_EXPR are dependant from the BYTECODE directive
   (Don't know what this is (it's defined in Defn.h) and therefore the functions
    - function riPreExpr( _p: pSExp ): pSExp;
    - function riBodyExpr( _p: pSExp ): pSExp;
   have not been implemented for now }

{ Protected evaluation }

function riToplevelExec( _fun: aToplevelExec; _data: pointer ): aRBoolean; cdecl;

{ Environment and Binding Features*/ }

procedure riRestoreHashCount( _rho: pSExp ); cdecl;
function riIsPackageEnv( _rho: pSExp ): aRBoolean; cdecl;
function riPackageEnvName( _rho: pSExp ): pSExp; cdecl;
function riFindPackageEnv( _info: pSExp ): pSExp; cdecl;
function riIsNamespaceEnv( _rho: pSExp ): aRBoolean; cdecl;
function riNamespaceEnvSpec( _rho: pSExp ): pSExp; cdecl;
function riFindNamespace( _info: pSExp ): pSExp; cdecl;
procedure riLockEnvironment( _env: pSExp; _bindings: aRBoolean); cdecl;
function riEnvironmentIsLocked( _env: pSExp ): aRBoolean; cdecl;
procedure riLockBinding( _sym: pSExp; _env: pSExp ); cdecl;
procedure riMakeActiveBinding( _sym: pSExp; _fun: pSExp; _env: pSExp ); cdecl;
function riBindingIsLocked( _sym: pSExp; _env: pSExp ): aRBoolean; cdecl;
function riBindingIsActive( _sym: pSExp; _env: pSExp ): aRBoolean; cdecl;
function riHasFancyBindings( _rho: pSExp ): aRBoolean; cdecl;

{ Errors.c - needed for R_load/savehistory handling in front ends }

procedure riErrorcall( _call: pSExp; _format: PChar ); cdecl; varargs;
procedure riWarningcall( _call: pSExp; _format: PChar ); cdecl; varargs;

{ Experimental Changes in Dispatching }

{ TODO -ohp -caskRdevel : no entry point for (experimental) R_SetUseNamespaceDispatch }
//procedure riSetUseNamespaceDispatch( _val: aRBoolean); cdecl;

{ Save/Load Interface }

procedure riXdrEncodeDouble( _d: double; _buf: pointer); cdecl;
function riXdrDecodeDouble( _buf: pointer): double; cdecl;
procedure riXdrEncodeinteger( _i: integer; _buf: pointer); cdecl;
function riXdrDecodeinteger( _buf: pointer): integer; cdecl;

procedure riInitInPStream( _stream: aInPStream; _data: aPStreamData;
    _type: aPStreamFormat; _inchar: aInChar; _inbytes: aInBytes;
    _phook: aInOutPersistHookFunc; _pdata: pSExp ); cdecl;
procedure riInitOutPStream( _stream: aOutPStream; _data: aPStreamData;
    _type: aPStreamFormat; _version: integer; _outchar: aOutChar;
    _outbytes: aOutBytes; _phok: aInOutPersistHookFunc; _pdata: pSExp ); cdecl;

  { TODO -ohp -cFixme : maybe it's better to take a faked file (e.g. TRFile) type and not just FILE }
procedure riInitFileInPStream( _stream: aInpstream; var _fp: File;
    _type: aPStreamFormat; _phook: aInOutPersistHookFunc; _pdat: pSExp ); cdecl;
procedure riInitFileOutPStream( _stream: aInpstream; var _fp: File;
    _type: aPStreamFormat; _phook: aInOutPersistHookFunc; _pdat: pSExp ); cdecl;

{ Connection interface (not yet available to packages) }

procedure riInitConnInPStream( _stream: aInPStream; _con: pRConnection;
    _type: aPStreamFormat; _phook: aInOutPersistHookFunc; _pdat: pSExp ); cdecl;
procedure riInitConnOutPStream( _stream: aOutPStream; _con: pRConnection;
    _type: aPStreamFormat; _version: integer; _phook: aInOutPersistHookFunc;
    _pdat: pSExp ); cdecl;

procedure riSerialize( _s: pSExp; _ops: aOutPStream ); cdecl;
function riUnserialize( _ips: aInPStream ): pSExp; cdecl;

{ Slot management }

function riDoSlot( _obj, _name: pSExp ): pSExp; cdecl;
function riDoSlotAssign( _obj, _name, _value: pSExp ): pSExp; cdecl;

{ Class definition, new objects }

function riDoMakeClass( _what: pChar ): pSExp; cdecl;
function riDoNewObject( _classDef: pSExp ): pSExp; cdecl;

{ Preserve objects across GCs }

procedure riPreserveObject( _obj: pSExp ); cdecl;
procedure riReleaseObject( _obj: pSExp ); cdecl;

{ Shutdown actions }

procedure riDotLast(); cdecl;
procedure riRunExitFinalizers(); cdecl;

{ Recpalcments for popen and system }

function riPopen( _command, _type: pChar ): pFile; cdecl;
function riSystem( _command: pChar ): integer; cdecl;

{---------------------------------------------------------- remapped functions }
  { declared above }

{----------------------------------------------------------  R"inlined"funs }

function riAllocString( _length: integer ): pSExp; cdecl;
function riAsComplex( _x: pSExp ): aRComplex; cdecl;
function riAsInteger( _x: pSExp ): integer; cdecl;
function riAsLogical( _x: pSExp ): integer; cdecl;
function riAsReal( _x: pSExp ): double; cdecl;
function riConformable( _x, _y: pSExp ): aRBoolean; cdecl;
function riElt( _list: pSExp; _i: integer ): pSExp; cdecl;
function riInherits( _s: pSExp; _name: pChar ): aRBoolean; cdecl;
function riIsArray( _s: pSExp ): aRBoolean; cdecl;
function riIsComplex( _s: pSExp ): aRBoolean; cdecl;
function riIsEnvironment( _s: pSExp ): aRBoolean; cdecl;
function riIsExpression( _s: pSExp ): aRBoolean; cdecl;
function riIsFactor( _s: pSExp ): aRBoolean; cdecl;
function riIsFrame( _s: pSExp ): aRBoolean; cdecl;
function riIsInteger( _s: pSExp ): aRBoolean; cdecl;
{ TODO -ohp -creportRdevel : riIsFunction is already declared before }
//function rfIsFunction( _s: pSExp ): aRBoolean;
function riIsLanguage( _s: pSExp ): aRBoolean; cdecl;
function riIsList( _s: pSExp ): aRBoolean; cdecl;
function riIsLogical( _s: pSExp ): aRBoolean; cdecl;
function riIsMatrix( _s: pSExp ): aRBoolean; cdecl;
function riIsNewList( _s: pSExp ): aRBoolean; cdecl;
function riIsNull( _s: pSExp ): aRBoolean; cdecl;
function riIsNumeric( _s: pSExp ): aRBoolean; cdecl;
function riIsObject( _s: pSExp ): aRBoolean; cdecl;
function riIsOrdered( _s: pSExp ): aRBoolean; cdecl;
function riIsPairList( _s: pSExp ): aRBoolean; cdecl;
function riIsPrimitive( _s: pSExp ): aRBoolean; cdecl;
function riIsReal( _s: pSExp ): aRBoolean; cdecl;
function riIsString( _s: pSExp ): aRBoolean; cdecl;
function riIsSymbol( _s: pSExp ): aRBoolean; cdecl;
function riIsTs( _s: pSExp ): aRBoolean; cdecl;
function riIsUnordered( _s: pSExp ): aRBoolean; cdecl;
function riIsUserBinop( _s: pSExp ): aRBoolean; cdecl;
function riIsValidString( _x: pSExp ): aRBoolean; cdecl;
function riIsValidStringF( _x: pSExp ): aRBoolean; cdecl;
function riIsVector( _s: pSExp ): aRBoolean; cdecl;
function riIsVectorAtomic( _s: pSExp ): aRBoolean; cdecl;
function riIsVectorList( _s: pSExp ): aRBoolean; cdecl;
function riIsVectorizable( _s: pSExp ): aRBoolean; cdecl;
function riLang1( _s: pSExp ): pSExp; cdecl;
function riLang2( _s, _t: pSExp ): pSExp; cdecl;
function riLang3( _s, _t, _u: pSExp ): pSExp; cdecl;
function riLang4( _s, _t, _u, _v: pSExp ): pSExp; cdecl;
function riLastElt( _list: pSExp ): pSExp; cdecl;
function riLcons( _car, _cdr: pSExp ): pSExp; cdecl;
function rLength( _s: pSExp ): aRLen; cdecl;  // riLength is already occupied!
function riList1( _s: pSExp ): pSExp; cdecl;
function riList2( _s, _t: pSExp ): pSExp; cdecl;
function riList3( _s, _t, _u: pSExp ): pSExp; cdecl;
function riList4( _s, _t, _u, _v: pSExp ): pSExp; cdecl;
function riListAppend( _s, _t: pSExp ): pSExp; cdecl;
function riMkChar( _name: pChar ): pSExp; cdecl;
function riMkString( _s: pChar ): pSExp; cdecl;
function riNlevels( _f: pSExp ): integer; cdecl;
function riScalarComplex( _x: aRComplex ): pSExp; cdecl;
function riScalarInteger( x: integer ): pSExp; cdecl;
function riScalarLogical( x: integer ): pSExp; cdecl;
function riScalarRaw( _x: aRByte): pSExp; cdecl;
function riScalarReal( _x: double ): pSExp; cdecl;
function riScalarString( _x: pSExp ): pSExp; cdecl;


{==============================================================================}
implementation

{ Support for global variable initialization }

function ToRVarsArr( _set: aLoadVarRInternals): aRVarsArr;
  var
    i: aVarRinternals;
    idx: integer;
  begin
    SetLength( result, 0 );
    for i:= Low( aVarRinternals ) to High( aVarRinternals ) do begin
      if i in _set then begin
        idx:= Length( result );
        SetLength( result, idx + 1 );
        result[idx].gvName:= TheVarRInternalsName[i];
        result[idx].gvPointer:= TheVarRInternalsPtr[i];
        result[idx].gvType:= vtSExp;
      end;
    end;
  end {LoadVarRInternalsToArr};

{ SExptype to string conversion }

function SExpTypeToStr( _type: aSExpType ): string;
  begin
    result:= SExpTypeToStr( integer(_type) );
  end;

function SExpTypeToStr( _type: integer ): string;
  const
    TheSExpType:  array[0..23] of string
                  = ( 'NilSxp', 'SymSxp', 'ListSxp', 'CloSxp', 'EnvSxp', 'PromSxp'
                    , 'LangSxp', 'SpecialSxp', 'BuiltinSxp', 'CharSxp', 'LglSxp'
                    , 'IntSxp', 'RealSxp', 'CplxSxp', 'StrSxp', 'DotSxp', 'AnySxp'
                    , 'VecSxp', 'ExprSxp', 'BcodeSxp', 'ExtptrSxp', 'WeakrefSxp'
                    , 'RawSxp', 'FunSxp' );
  begin
    case _type of
      0..10:        result:= TheSexpType[_type];
      13..24:       result:= TheSexpType[_type - 2];
      TheSetFunSxp: result:= TheSExpType[23];
    else
      result:= 'invalid';
    end;
  end;


{ Misc }

function riChar; external TheRDll name 'R_CHAR';

{  Accessor functions }

function riAttrib; external TheRDll name 'ATTRIB';
function riObject; external TheRDll name 'OBJECT';
function riMark; external TheRDll name 'MARK';
function riTypeOf; external TheRDll name 'TYPEOF';
function riNamed; external TheRDll name 'NAMED';
procedure riSetObject; external TheRDll name 'SET_OBJECT';
procedure riSetTypeof; external TheRDll name 'SET_TYPEOF';
procedure riSetNamed; external TheRDll name 'SET_NAMED';

function riLength; external TheRDll name 'LENGTH';
function riTruelength; external TheRDll name 'TRUELENGTH';
procedure riSetLength; external TheRDll name 'SETLENGTH';
procedure riSetTruelength; external TheRDll name 'SET_TRUELENGTH';
function riLevels; external TheRDll name 'LEVELS';
function riSetLevels; external TheRDll name 'SETLEVELS';

function riLogical; external TheRDll name 'LOGICAL';
function riInteger; external TheRDll name 'INTEGER';
function riRaw; external TheRDll name 'RAW';
function riComplex; external TheRDll name 'COMPLEX';
function riReal; external TheRDll name 'REAL';
function riStringElt; external TheRDll name 'STRING_ELT';
function riVectorElt; external TheRDll name 'VECTOR_ELT';
function riStringPtr; external TheRDll name 'STRING_PTR';
function riVectorPtr; external TheRDll name 'VECTOR_PTR';
procedure riSetStringElt; external TheRDll name 'SET_STRING_ELT';
procedure riSetVectorElt; external TheRDll name 'SET_VECTOR_ELT';

function riTag; external TheRDll name 'TAG';
function riCar; external TheRDll name 'CAR';
function riCdr; external TheRDll name 'CDR';
function riCaar; external TheRDll name 'CAAR';
function riCdar; external TheRDll name 'CDAR';
function riCadr; external TheRDll name 'CADR';
function riCddr; external TheRDll name 'CDDR';
function riCaddr; external TheRDll name 'CADDR';
function riCadddr; external TheRDll name 'CADDDR';
function riCad4r; external TheRDll name 'CAD4R';
function riMissing; external TheRDll name 'MISSING';
procedure riSetMissing; external TheRDll name 'SET_MISSING';
function riSetTag; external TheRDll name 'SET_TAG';
function riSetCar; external TheRDll name 'SETCAR';
function riSetCdr; external TheRDll name 'SETCDR';
function riSetCadr; external TheRDll name 'SETCADR';
function riSetCaddr; external TheRDll name 'SETCADDR';
function riSetCadddr; external TheRDll name 'SETCADDDR';
function riSetCad4r; external TheRDll name 'SETCAD4R';

function riFormals; external TheRDll name 'FORMALS';
function riBody; external TheRDll name 'BODY';
function riCloenv; external TheRDll name 'CLOENV';
function riDebug; external TheRDll name 'DEBUG';
function riTrace; external TheRDll name 'TRACE';
procedure riSetDebug; external TheRDll name 'SET_DEBUG';
procedure riSetTrace; external TheRDll name 'SET_TRACE';
procedure riSetFormals; external TheRDll name 'SET_FORMALS';
procedure riSetBody; external TheRDll name 'SET_BODY';
procedure riSetCloenv; external TheRDll name 'SET_CLOENV';

function riPrintName; external TheRDll name 'PRINTNAME';
function riSymvalue; external TheRDll name 'SYMVALUE';
function riInternal; external TheRDll name 'INTERNAL';
function riDdval; external TheRDll name 'DDVAL';
function riSetDdval; external TheRDll name 'SET_DDVAL';
function riSetPrintname; external TheRDll name 'SET_PRINTNAME';
procedure riSetSymvalue; external TheRDll name 'SET_SYMVALUE';
procedure riSetInternal; external TheRDll name 'SET_INTERNAL';

function riFrame; external TheRDll name 'FRAME';
function riEnclos; external TheRDll name 'ENCLOS';
function riHashtab; external TheRDll name 'HASHTAB';
function riEnvflags; external TheRDll name 'ENVFLAGS';
procedure riSetFrame; external TheRDll name 'SET_FRAME';
procedure riSetEnclos; external TheRDll name 'SET_ENCLOS';
procedure riSetHashtab; external TheRDll name 'SET_HASHTAB';
procedure riSetEnvflags; external TheRDll name 'SET_ENVFLAGS';

function riPrcode; external TheRDll name 'PRCODE';
function riPrenv; external TheRDll name 'PRENV';
function riPrvalue; external TheRDll name 'PRVALUE';
function riPrseen; external TheRDll name 'PRSEEN';
procedure riSetPrenv; external TheRDll name 'SET_PRENV';
procedure riSetPrvalue; external TheRDll name 'SET_PRVALUE';
procedure riSetPrcode; external TheRDll name 'SET_PRCODE';
procedure riSetPrseen; external TheRDll name 'SET_PRSEEN';

function riHashash; external TheRDll name 'HASHASH';
function riHashvalue; external TheRDll name 'HASHVALUE';
procedure riSetHashash; external TheRDll name 'SET_HASHASH';
procedure riSetHashvalue; external TheRDll name 'SET_HASHVALUE';

function riExtptrPtr( _x: pSExp ): pSExp;
  begin
    result:= riCar( _x );
  end;
function riExtptrProt( _x: pSExp ): pSExp;
  begin
    result:= riCdr( _x );
  end;
function riExtptrTag( _x: pSExp ): pSExp;
  begin
    result:= riTag( _x );
  end;

function riBcodeCode( _x: pSExp ): pSExp;
  begin
    result:= riCar( _x );
  end;
function riBcodeConsts( _x: pSExp ): pSExp;
  begin
    result:= riCdr( _x );
  end;
function riBcodeExpr( _x: pSExp ): pSExp;
  begin
    result:= riTag( _x );
  end;
function riIsBytecode( _x: pSExp ): boolean;
  begin
    result:= riTypeOf( _x ) = setBcodeSxp;
  end;


{  functions }

function riAsChar; external TheRDll name 'Rf_asChar';
function riAsCommon; external TheRDll name 'Rf_ascommon';
function riCoerceVector; external TheRDll name 'Rf_coerceVector';
//function riCoerceList; external TheRDll name 'CoerceList';
procedure riCoercionWarning; external TheRDll name 'Rf_CoercionWarning';
function riPairToVectorList; external TheRDll name 'Rf_PairToVectorList';
function riVectorToPairList; external TheRDll name 'Rf_VectorToPairList';
function riLogicalFrominteger; external TheRDll name 'Rf_LogicalFromInteger';
function riLogicalFromReal; external TheRDll name 'Rf_LogicalFromReal';
function riLogicalFromComplex; external TheRDll name 'Rf_LogicalFromComplex';
function riLogicalFromString; external TheRDll name 'Rf_LogicalFromString';
function riIntegerFromLogical; external TheRDll name 'Rf_IntegerFromLogical';
function riIntegerFromReal; external TheRDll name 'Rf_IntegerFromReal';
function riIntegerFromComplex; external TheRDll name 'Rf_IntegerFromComplex';
function riIntegerFromString; external TheRDll name 'Rf_IntegerFromString';
function riRealFromLogical; external TheRDll name 'Rf_RealFromLogical';
function riRealFromInteger; external TheRDll name 'Rf_RealFrominteger';
function riRealFromComplex; external TheRDll name 'Rf_RealFromComplex';
function riRealFromString; external TheRDll name 'Rf_RealFromString';
function riComplexFromLogical; external TheRDll name 'Rf_ComplexFromLogical';
function riComplexFrominteger; external TheRDll name 'Rf_ComplexFrominteger';
function riComplexFromReal; external TheRDll name 'Rf_ComplexFromReal';
function riComplexFromString; external TheRDll name 'Rf_ComplexFromString';
function riStringFromLogical; external TheRDll name 'Rf_StringFromLogical';
function riStringFromInteger; external TheRDll name 'Rf_StringFromInteger';
function riStringFromReal; external TheRDll name 'Rf_StringFromReal';
function riStringFromComplex; external TheRDll name 'Rf_StringFromComplex';
function riEnsureString; external TheRDll name 'Rf_EnsureString';

function riAllocArray; external TheRDll name 'Rf_allocArray';
function riAllocMatrix; external TheRDll name 'Rf_allocMatrix';
function riAllocList; external TheRDll name 'Rf_allocList';
function riAllocSExp; external TheRDll name 'Rf_allocSExp';
function riAllocVector; external TheRDll name 'Rf_allocVector';
function riApplyClosure; external TheRDll name 'Rf_applyClosure';
function riArraySubscript; external TheRDll name 'Rf_arraySubscript';
function riAsVecSize; external TheRDll name 'Rf_asVecSize';
function riClassgets; external TheRDll name 'Rf_classgets';
function riCons; external TheRDll name 'Rf_cons';
procedure riCopyListMatrix; external TheRDll name 'Rf_copyListMatrix';
procedure riCopyMatrix; external TheRDll name 'Rf_copyMatrix';
procedure riCopyMostAttrib; external TheRDll name 'Rf_copyMostAttrib';
procedure riCopyMostAttribNoTs; external TheRDll name 'Rf_copyMostAttribNoTs';
procedure riCopyVector; external TheRDll name 'Rf_copyVector';
function riCreateTag; external TheRDll name 'Rf_createTag';
procedure riCustomPrintValue; external TheRDll name 'Rf_CustomPrintValue';
procedure riDefineVar; external TheRDll name 'Rf_defineVar';
function riDimgets; external TheRDll name 'Rf_dimgets';
function riDimnamesgets; external TheRDll name 'Rf_dimnamesgets';
function riDropDims; external TheRDll name 'Rf_DropDims';
function riDuplicate; external TheRDll name 'Rf_duplicate';
function riDuplicated; external TheRDll name 'Rf_duplicated';
function riEval; external TheRDll name 'Rf_eval';
function riEvalArgs; external TheRDll name 'Rf_EvalArgs';
function riEvalList; external TheRDll name 'Rf_evalList';
function riEvalListKeepMissing; external TheRDll name 'Rf_evalListKeepMissing';
function riFindFun; external TheRDll name 'Rf_findFun';
function riFindVar; external TheRDll name 'Rf_findVar';
function riFindVarInFrame; external TheRDll name 'Rf_findVarInFrame';
function riFindVarInFrame3; external TheRDll name 'Rf_findVarInFrame3';
function riGetAttrib; external TheRDll name 'Rf_getAttrib';
function riGetArrayDimnames; external TheRDll name 'Rf_GetArrayDimnames';
function riGetColnames; external TheRDll name 'Rf_GetColnames';
procedure riGetMatrixDimnames; external TheRDll name 'Rf_GetMatrixDimnames';
function riGetOption; external TheRDll name 'Rf_GetOption';
function riGetOptionDigits; external TheRDll name 'Rf_GetOptionDigits';
function riGetOptionWidth; external TheRDll name 'Rf_GetOptionWidth';
function riGetRownames; external TheRDll name 'Rf_GetRownames';
procedure riGsetVar; external TheRDll name 'Rf_gsetVar';
function riInstall; external TheRDll name 'Rf_install';
function riIsFree; external TheRDll name 'Rf_isFree';
function riIsFunction; external TheRDll name 'Rf_isFunction';
function riIsUnsorted; external TheRDll name 'Rf_isUnsorted';
function riItemName; external TheRDll name 'Rf_itemName';
function riLengthgets; external TheRDll name 'Rf_lengthgets';
function riMakeSubscript; external TheRDll name 'Rf_makeSubscript';
function riMatch; external TheRDll name 'Rf_match';
function riMatchArg; external TheRDll name 'Rf_matchArg';
function riMatchArgExact; external TheRDll name 'Rf_matchArgExact';
function riMatchArgs; external TheRDll name 'Rf_matchArgs';
function riMatchPar; external TheRDll name 'Rf_matchPar';
function riNamesgets; external TheRDll name 'Rf_namesgets';
function riNonNullStringMatch; external TheRDll name 'Rf_NonNullStringMatch';
function riNcols; external TheRDll name 'Rf_ncols';
function riNrows; external TheRDll name 'Rf_nrows';
function riNthcdr; external TheRDll name 'Rf_nthcdr';
function riPmatch; external TheRDll name 'Rf_pmatch';
function riPsmatch; external TheRDll name 'Rf_psmatch';
procedure riPrintDefaults; external TheRDll name 'Rf_PrintDefaults';
procedure riPrintValue; external TheRDll name 'Rf_PrintValue';
procedure riPrintValueEnv; external TheRDll name 'Rf_PrintValueEnv';
procedure riPrintValueRec; external TheRDll name 'Rf_PrintValueRec';
function riProtect; external TheRDll name 'Rf_protect';

function riSetAttrib; external TheRDll name 'Rf_setAttrib';
procedure riSetSVector; external TheRDll name 'Rf_setSVector';
procedure riSetVar; external TheRDll name 'Rf_setVar';
function riStringBlank; external TheRDll name 'Rf_StringBlank';
function riSubstitute; external TheRDll name 'Rf_substitute';
function riTryEval; external TheRDll name 'R_tryEval';
procedure riUnprotect; external TheRDll name 'Rf_unprotect';
procedure riUnprotect_ptr; external TheRDll name 'Rf_unprotect_ptr';
function riVectorSubscript; external TheRDll name 'Rf_vectorSubscript';
procedure riProtectWithIndex; external TheRDll name 'R_ProtectWithIndex';
procedure riReprotect; external TheRDll name 'R_Reprotect';
function riSubassign3_dflt; external TheRDll name 'R_subassign3_dflt';
function riSubset3_dflt; external TheRDll name 'R_subset3_dflt';

function riError_return( _msg: pchar ): pSExp;
  begin
    rError( _msg, [] );
    result:= RNilValue;
  end;
function riErrorcall_return( _call: pSExp; _format: pchar ): pSExp;
  begin
    riErrorcall( _call, _format, [] );
    result:= RNilValue;
  end;

{ more functions }

function riMakeExternalPtr; external TheRDll name 'R_MakeExternalPtr';
function riExternalPtrAddr; external TheRDll name 'R_ExternalPtrAddr';
function riExternalPtrTag; external TheRDll name 'R_ExternalPtrTag';
function riExternalPtrProtected; external TheRDll name 'R_ExternalPtrProtected';
procedure riClearExternalPtr; external TheRDll name 'R_ClearExternalPtr';
procedure riSetExternalPtrAddr; external TheRDll name 'R_SetExternalPtrAddr';
procedure riSetExternalPtrTag; external TheRDll name 'R_SetExternalPtrTag';
procedure riSetExternalPtrProtected; external TheRDll name 'R_SetExternalPtrProtected';

procedure riRegisterFinalizer; external TheRDll name 'R_RegisterFinalizer';
procedure riRegisterCFinalizer; external TheRDll name 'R_RegisterCFinalizer';
procedure riRegisterFinalizerEx; external TheRDll name 'R_RegisterFinalizerEx';
procedure riRegisterCFinalizerEx; external TheRDll name 'R_RegisterCFinalizerEx';

function riMakeWeakRef; external TheRDll name 'R_MakeWeakRef';
function riMakeWeakRefC; external TheRDll name 'R_MakeWeakRefC';
function riWeakRefKey; external TheRDll name 'R_WeakRefKey';
function riWeakRefValue; external TheRDll name 'R_WeakRefValue';
procedure riRunWeakRefFinalizer; external TheRDll name 'R_RunWeakRefFinalizer';
function riPromiseExpr; external TheRDll name 'R_PromiseExpr';
function riClosureExpr; external TheRDll name 'R_ClosureExpr';
procedure riInitializeBcode; external TheRDll name 'R_initialize_bcode';
function ribcEncode; external TheRDll name 'R_bcEncode';
function ribcDecode; external TheRDll name 'R_bcDecode';

function riToplevelExec; external TheRDll name 'R_ToplevelExec';

procedure riRestoreHashCount; external TheRDll name 'R_RestoreHashCount';
function riIsPackageEnv; external TheRDll name 'R_IsPackageEnv';
function riPackageEnvName; external TheRDll name 'R_PackageEnvName';
function riFindPackageEnv; external TheRDll name 'R_FindPackageEnv';
function riIsNamespaceEnv; external TheRDll name 'R_IsNamespaceEnv';
function riNamespaceEnvSpec; external TheRDll name 'R_NamespaceEnvSpec';
function riFindNamespace; external TheRDll name 'R_FindNamespace';
procedure riLockEnvironment; external TheRDll name 'R_LockEnvironment';
function riEnvironmentIsLocked; external TheRDll name 'R_EnvironmentIsLocked';
procedure riLockBinding; external TheRDll name 'R_LockBinding';
procedure riMakeActiveBinding; external TheRDll name 'R_MakeActiveBinding';
function riBindingIsLocked; external TheRDll name 'R_BindingIsLocked';
function riBindingIsActive; external TheRDll name 'R_BindingIsActive';
function riHasFancyBindings; external TheRDll name 'R_HasFancyBindings';

procedure riErrorcall; external TheRDll name 'Rf_errorcall';
procedure riWarningcall; external TheRDll name 'Rf_warningcall';

//procedure riSetUseNamespaceDispatch; external TheRDll name 'SetUseNamespaceDispatch';

procedure riXDREncodeDouble; external TheRDll name 'R_XDREncodeDouble';
function riXDRDecodeDouble; external TheRDll name 'R_XDRDecodeDouble';
procedure riXDREncodeinteger; external TheRDll name 'R_XDREncodeInteger';
function riXDRDecodeinteger; external TheRDll name 'R_XDRDecodeInteger';
procedure riInitInPStream; external TheRDll name 'R_InitInPStream';
procedure riInitOutPStream; external TheRDll name 'R_InitOutPStream';
procedure riInitFileInPStream; external TheRDll name 'R_InitFileInPStream';
procedure riInitFileOutPStream; external TheRDll name 'R_InitFileOutPStream';
procedure riInitConnInPStream; external TheRDll name 'R_InitConnInPStream';
procedure riInitConnOutPStream; external TheRDll name 'R_InitConnOutPStream';

procedure riSerialize; external TheRDll name 'R_Serialize';     // there's also a lower case variant
function riUnserialize; external TheRDll name 'R_Unserialize';  // there's also a lower case variant

function riDoSlot; external TheRDll name 'R_do_slot';
function riDoSlotAssign; external TheRDll name 'R_do_slot_assign';

function riDoMakeClass; external TheRDll name 'R_do_MAKE_CLASS';
function riDoNewObject; external TheRDll name 'R_do_new_object';

procedure riPreserveObject; external TheRDll name 'R_PreserveObject';
procedure riReleaseObject; external TheRDll name 'R_ReleaseObject';

procedure riDotLast; external TheRDll name 'R_dot_Last';
procedure riRunExitFinalizers; external TheRDll name 'R_RunExitFinalizers';

function riPopen; external TheRDll name 'R_popen';
function riSystem; external TheRDll name 'R_system';

{ R"inlined"funs }

function riAllocString; external TheRDll name 'Rf_allocString';
function riAsComplex; external TheRDll name 'Rf_asComplex';
function riAsInteger; external TheRDll name 'Rf_asInteger';
function riAsLogical; external TheRDll name 'Rf_asLogical';
function riAsReal; external TheRDll name 'Rf_asReal';
function riConformable; external TheRDll name 'Rf_conformable';
function riELt; external TheRDll name 'Rf_elt';
function riInherits; external TheRDll name 'Rf_inherits';
function riIsArray; external TheRDll name 'Rf_isArray';
function riIsComplex; external TheRDll name 'Rf_isComplex';
function riIsEnvironment; external TheRDll name 'Rf_isEnvironment';
function riIsExpression; external TheRDll name 'Rf_isExpression';
function riIsFactor; external TheRDll name 'Rf_isFactor';
function riIsFrame; external TheRDll name 'Rf_isFrame';
function riIsInteger; external TheRDll name 'Rf_isInteger';
function riIsLanguage; external TheRDll name 'Rf_isLanguage';
function riIsList; external TheRDll name 'Rf_isList';
function riIsLogical; external TheRDll name 'Rf_isLogical';
function riIsMatrix; external TheRDll name 'Rf_isMatrix';
function riIsNewList; external TheRDll name 'Rf_isNewList';
function riIsNull; external TheRDll name 'Rf_isNull';
function riIsNumeric; external TheRDll name 'Rf_isNumeric';
function riIsObject; external TheRDll name 'Rf_isObject';
function riIsOrdered; external TheRDll name 'Rf_isOrdered';
function riIsPairList; external TheRDll name 'Rf_isPairList';
function riIsPrimitive; external TheRDll name 'Rf_isPrimitive';
function riIsReal; external TheRDll name 'Rf_isReal';
function riIsString; external TheRDll name 'Rf_isString';
function riIsSymbol; external TheRDll name 'Rf_isSymbol';
function riIsTs; external TheRDll name 'Rf_isTs';
function riIsUnordered; external TheRDll name 'Rf_isUnordered';
function riIsUserBinop; external TheRDll name 'Rf_isUserBinop';
function riIsValidString; external TheRDll name 'Rf_isValidString';
function riIsValidStringF; external TheRDll name 'Rf_isValidStringF';
function riIsVector; external TheRDll name 'Rf_isVector';
function riIsVectorAtomic; external TheRDll name 'Rf_isVectorAtomic';
function riIsVectorList; external TheRDll name 'Rf_isVectorList';
function riIsVectorizable; external TheRDll name 'Rf_isVectorizable';
function riLang1; external TheRDll name 'Rf_lang1';
function riLang2; external TheRDll name 'Rf_lang2';
function riLang3; external TheRDll name 'Rf_lang3';
function riLang4; external TheRDll name 'Rf_lang4';
function riLastElt; external TheRDll name 'Rf_lastElt';
function riLcons; external TheRDll name 'Rf_lcons';
function rLength; external TheRDll name 'Rf_length';
function riList1; external TheRDll name 'Rf_list1';
function riList2; external TheRDll name 'Rf_ist2';
function riList3; external TheRDll name 'Rf_list3';
function riList4; external TheRDll name 'Rf_list4';
function riListAppend; external TheRDll name 'Rf_listAppend';
function riMkChar; external TheRDll name 'Rf_mkChar';
function riMkString; external TheRDll name 'Rf_mkString';
function riNlevels; external TheRDll name 'Rf_nlevels';
function riScalarComplex; external TheRDll name 'Rf_ScalarComplex';
function riScalarInteger; external TheRDll name 'Rf_ScalarInteger';
function riScalarLogical; external TheRDll name 'Rf_ScalarLogical';
function riScalarRaw; external TheRDll name 'Rf_ScalarRaw';
function riScalarReal; external TheRDll name 'Rf_ScalarReal';
function riScalarString; external TheRDll name 'Rf_ScalarString';


end {rhRInternals}.

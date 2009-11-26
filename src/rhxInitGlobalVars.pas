unit rhxInitGlobalVars;

{ TODO ??? This code/unit is probably no longer necessary and has
  been replaced with rhxLoadRVars.pas? Check.

  Initialize global variables of the R header files. They can be
  defined in the first section below.
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

{ TODO -ohp -cfixme : rhxInitGlobalVars should become more generic }

{==============================================================================}
interface
uses
  rhRInternals, rhRGraphics, rhR;

const
{ TODO -ohp -csometimes : The variable initialization stuff is a bit
  complicated. Though the pointers appear to work, I am unsure: are they always
  valid? (normally I would use memory-mapped files to share variables) }

{----------------------------------------------------------
 The following variables well be initialized (with LoadGlobalVar()
----------------------------------------------------------- }

{ from rhRInternals }

  TheLoadVarRInternals: array[0..33] of aVarRInternals
                        =  ( vriRglobalEnv, vriRemptyEnv, vriRbaseEnv, vriRbaseNamespace
                           , vriRnamespaceRegistry, vriRnilValue, vriRunboundValue
                           , vriRmissingArg, vriRrestartToken, vriRBracket2Symbol
                           , vriRBracketSymbol, vriRBraceSymbol, vriRTmpvalSymbol
                           , vriRClassSymbol, vriRDimNamesSymbol, vriRDimSymbol
                           , vriRDollarSymbol, vriRDotsSymbol, vriRDropSymbol
                           , vriRLevelsSymbol, vriRModeSymbol, vriRNamesSymbol
                           , vriRNaRmSymbol, vriRRowNamesSymbol, vriRSeedsSymbol
                           , vriRTspSymbol, vriRLastvalueSymbol, vriRCommentSymbol
                           , vriRSourceSymbol, vriRDotEnvSymbol, vriRRecursiveSymbol
                           , vriRUseNamesSymbol, vriRNaString, vriRBlankString );

{ from rhRGraphics }

  TheLoadVarRGraphics:  array[0..3] of aVarRGraphics
                        = ( vrgRcolorTableSize, vrgRcolorTable
                          , vrgColorDataBase, vrgDefaultPalette );

{ from rhArith }

  TheLoadVarArith:      array[0..4] of aVarArith
                        = ( varRNaN, varRPosInf, varRNegInf
                          , varRNaReal, varRNaInt );

{ from rhRDefines }

  TheLoadNullUserObject = True;


  
{---------------------------------------------------------- functions }

function LoadGlobalVar(): boolean; overload;
function LoadGlobalVar( _vars: array of string; _ptrs: array of pointer ): boolean; overload;


{==============================================================================}
implementation
uses
  Windows, rhRDefines, rhxTypesAndConsts;

{---------------------------------------------------------- some internal stuff }

type
  aStringArr = array of string;
  aPointerArr = array of pointer;


function LoadGlobalVar( _vars: array of string; _ptrs: array of pointer ): boolean;
  var
    dllHdl: THandle;
    i: integer;
  begin
    assert( Length( _vars ) = Length( _ptrs ), 'InitRglobalVar: _vars and _ptrs must have the same length' );
    result:= True;

    dllHdl:= Windows.LoadLibrary( TheRDll );
    try
      if dllHdl <> 0 then begin
        for i:= 0 to Length( _vars ) - 1 do begin
        { TODO -ohp -cimportant : does this really work? }
          _ptrs[i]:= GetProcAddress( dllHdl, pChar(_vars[i]) );
          if _ptrs[i] = nil then result:= False;
        end {for};
      end else begin
        result:= False;
      end;
    finally
      FreeLibrary( dllHdl );
    end {try};
  end {LoadGlobalVarInternal};

{ TODO -ohp -cfixme : Make var initialization / this GetForXY procedures more generic (somehow)!!! }
procedure GetForVarRInternals( _vars: array of aVarRInternals;
    var _allvars: aStringArr; var _allptrs: aPointerArr );
  var
    i, offs: integer;
  begin
    offs:= Length( _allvars );
    SetLength( _allvars, offs + Length( _vars ) );
    SetLength( _allptrs, offs + Length( _vars ) );

    for i:= 0 to Length( _vars ) - 1 do begin
      _allvars[offs + integer(i) + 1]:= rhRInternals.TheVarRInternalsName[_vars[i]];
      _allptrs[offs + integer(i) + 1]:= rhRInternals.TheVarRInternalsPtr[_vars[i]];
    end;
  end {GetForVarRInternals};

procedure GetForVarRGraphics( _vars: array of aVarRGraphics;
    var _allvars: aStringArr; var _allptrs: aPointerArr );
  var
    i, offs: integer;
  begin
    offs:= Length( _allvars );
    SetLength( _allvars, offs + Length( _vars ) );
    SetLength( _allptrs, offs + Length( _vars ) );

    for i:= 0 to Length( _vars ) - 1 do begin
      _allvars[offs + integer(i) + 1]:= rhRgraphics.TheVarRGraphicsName[_vars[i]];
      _allptrs[offs + integer(i) + 1]:= rhRgraphics.TheVarRGraphicsPtr[_vars[i]];
    end;
  end {GetForVarRGraphics};

procedure GetForVarArith( _vars: array of aVarArith;
    var _allvars: aStringArr; var _allptrs: aPointerArr );
  var
    i, offs: integer;
  begin
    offs:= Length( _allvars );
    SetLength( _allvars, offs + Length( _vars ) );
    SetLength( _allptrs, offs + Length( _vars ) );

    for i:= 0 to Length( _vars ) - 1 do begin
      _allvars[offs + integer(i) + 1]:= rhR.TheVarArithName[_vars[i]];
      _allptrs[offs + integer(i) + 1]:= rhR.TheVarArithPtr[_vars[i]];
    end;
  end {GetForVarArith};

{---------------------------------------------------------- load function }

function LoadGlobalVar(): boolean;
  var
    names: aStringArr;
    ptrs: aPointerArr;
  begin
    GetForVarRInternals( TheLoadVarRInternals, names, ptrs );
    GetForVarRGraphics( TheLoadVarRGraphics, names, ptrs );
    GetForVarArith( TheLoadVarArith, names, ptrs );

    result:= LoadGlobalVar( names, ptrs );

    if TheLoadNullUserObject then NullUserObject:= RNilValue;

  end;

end {rhxInitGlobalVars}.

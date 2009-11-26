unit rhRUseInternals;

{ Pascal (Delphi) translation of the internal stuff of Rinternals.h.
  (https://svn.r-project.org/R/trunk/src/include/Rinternals.h). 
  Please see "DemosAndHeaders.txt" for actually used revision.
                              ---
  R is a computer language for statistical data analysis and is published
  under the GPL, the above-mentioned headerfile is distributed under LGPL.
  Copyright (C) 1995, 1996  Robert Gentleman and Ross Ihaka
  Copyright (C) 1999-2006   The R Development Core Team.
                              ---
  This file is closed source and will *not* be published under GPL and there's
  also *no* proprietary release planned. This decision is driven by the fact,
  that the internal structures are intended for use only within R itself and
  we don't want to expose them broadly. Use the "macros" (in rhRinternals.pas).
                              ---
  Copyright (C) 2006 by Hans-Peter Suter, Treetron GmbH, Switzerland.
  All rights reserved.
                              ---                                              }

{==============================================================================}
interface
uses
  rhRinternals, rhR, rhxTypesAndConsts;


{---------------------------------------------------------- sxpinfo }

type
    { sxpinfo_struct has bitfields and is quite difficult to translate to Delphi,
      I took an approach according to http://tinyurl.com/darky, the values can
      be retrieved with methods (see impl. section) }
  aSxpInfo = packed record
    sxpField1: byte;  // type=5   // aSExpType (warning: sxFunSxp ==> sxCloSxp)
                      // obj=1
                      // named=2
    gp: longword;     // gp=16    // levels
    sxpField2: byte;  // mark=1
                      // debug=1
                      // trace=1
                      // fin=1
                      // gcgen=1
                      // gccls=3
  end;

{---------------------------------------------------------- node data }

  pSExp = ^aSExp;

  aVecSxp = packed record
    vsLength: aRLen;
    vsTruelength: aRLen;
  end;
  aPrimSxp = packed record
    psOffset: integer;
  end;
  aSymSxp = packed record
    ssPname: pSExp;
    ssValue: pSExp;
    ssInternal: pSExp;
  end;
  aListSxp = packed record
    lsCarval: pSExp;
    lsCdrval: pSExp;
    lsTagval: pSExp;
  end;
  aEnvSxp = packed record
    esFrame: pSExp;
    esEnclos: pSExp;
    esHashtab: pSExp;
  end;
  aCloSxp = packed record
    csFormals: pSExp;
    csBody: pSExp;
    csEnv: pSExp;
  end;
  aPromSxp = packed record
    psValue: pSExp;
    psExpr: pSExp;
    psEnv: pSExp;
  end;

{---------------------------------------------------------- SExp node structure }

  aSExp = packed record
      { header (keep in sync. with aVecSExp) }
    seSxpinfo: aSxpInfo;
    seAttrib: pSExp;
    seGengcNextNode: pSExp;
    seGengcPrevNnode: pSExp;
      { data }
    case byte of
      1: (sePrimsxp: aPrimSxp);
      2: (seSymsxp: aSymSxp);
      3: (seListsxp: aListSxp);
      4: (seEnvsxp: aEnvSxp);
      5: (seClosxp: aCloSxp);
      6: (sePromsxp: aPromSxp);
  end;

  pVecSExp = ^aVecSExp;
  aVecSExp = packed record
      { header (keep in sync. with aSExp) }
    sxpinfo: aSxpInfo;
    attrib: pSExp;
    gengc_next_node: pSExp;
    gengc_prev_node: pSExp;
      { data }
    vecsxp: aVecSxp;
  end;

  pSExpAlign = ^aSExpAlign;
  aSExpAlign = packed record
    case byte of
      1: (seaS: aVecSExp;);
      2: (seaAlign: double;);
  end;

{---------------------------------------------------------- access SEXP }

{ General Cons Cell Attributes }

function ruiAttrib( _x: pSExp ): pSExp; inline;
function ruiObject( _x: pSExp ): integer;               // inlined not possible
function ruiMark( _x: pSExp ): integer;                 // inlined not possible
function ruiTypeOf( _x: pSExp ): aSExpType;             // inlined not possible
function ruiNamed( _x: pSExp ): integer;                // inlined not possible
procedure ruiSetObject( _x: pSExp; _v: integer );       // inlined not possible
procedure ruiSetTypeof( _x: pSExp; _v: aSExpType );     // inlined not possible
procedure ruiSetNamed( _x: pSExp; _v: integer );        // inlined not possible

{ Vector Access Macros }

function ruiLength( _x: pSExp ): integer; inline;
function ruiTruelength( _x: pSExp ): integer; inline;
procedure ruiSetLength( _x: pSExp; _v: integer ); inline;
procedure ruiSetTruelength( _x: pSExp; _v: integer ); inline;
function ruiLevels( _x: pSExp ): integer; inline;
function ruiSetLevels( _x: pSExp; _v: integer ): integer; inline;

{ Under the generational allocator the data for vector nodes comes
  immediately after the node structure, so the data address is a
  known offset from the node SEXP. }

function ruiDataptr( _x: pSExp ): pointer;              // inlined not possible
function ruiChar( _x: pSExp ): pChar;                // inlined not possible
function ruiLogical( _x: pSExp ): aIntegerArr;          // inlined not possible
function ruiInteger( _x: pSExp ): aIntegerArr;          // inlined not possible
{ TODO -ohp -cfixme : ruiRaw must probably give back a pByteArr }
function ruiRaw( _x: pSExp ): aPointerArr;              // inlined not possible
function ruiComplex( _x: pSExp ): aRcomplexArr;         // inlined not possible
function ruiReal( _x: pSExp ): aDoubleArr;              // inlined not possible
function ruiStringElt( _x: pSExp; _i: integer ): pSExp; // inlined not possible
{ TODO: what about a direkt string variant: pData(pData(a)^.pa[0])^.ca }
function ruiVectorElt( _x: pSExp; _i: integer ): pSExp; // inlined not possible
function ruiStringPtr( _x: pSExp ): aSExpArr;           // inlined not possible
function ruiVectorPtr( _x: pSExp ): aSExpArr;           // inlined not possible

{ List Access Macros (These also work for ... objects) }

function ruiListval( _x: pSExp ): aListSxp; inline;
function ruiTag( _x: pSExp ): pSExp; inline;
function ruiCar( _x: pSExp ): pSExp; inline;
function ruiCdr( _x: pSExp ): pSExp; inline;
function ruiCaar( _x: pSExp ): pSExp; inline;
function ruiCdar( _x: pSExp ): pSExp; inline;
function ruiCadr( _x: pSExp ): pSExp; inline;
function ruiCddr( _x: pSExp ): pSExp; inline;
function ruiCaddr( _x: pSExp ): pSExp; inline;
function ruiCadddr( _x: pSExp ): pSExp; inline;
function ruiCad4r( _x: pSExp ): pSExp; inline;
function ruiMissing( _x: pSExp ): integer; inline;
{ TODO -ohp -csometimes : skipped ruiSetMissing (looks a bit complicated... - maybe later) }
// function ruiSetMissing( _x: pSExp ): pSExp;

{ Closure Access Macros }

function ruiFormals( _x: pSExp ): pSExp; inline;
function ruiBody( _x: pSExp ): pSExp; inline;
function ruiCloenv( _x: pSExp ): pSExp; inline;
function ruiDebug( _x: pSExp ): integer;                // inlined not possible
function ruiTrace( _x: pSExp; _v: integer ): integer;   // inlined not possible
procedure ruiSetDebug( _x: pSExp; _v: integer );        // inlined not possible
procedure ruiSetTrace( _x: pSExp; _v: integer );        // inlined not possible

{ Symbol Access Macros }

function ruiPrintName( _x: pSExp ): pSExp; inline;
function ruiSymvalue( _x: pSExp ): pSExp; inline;
function ruiInternal( _x: pSExp ): pSExp; inline;
function ruiDdval( _x: pSExp ): integer; inline;
procedure ruiSetDdvalBit( _x: pSExp ); inline;
function ruiUnsetDdvalBit( _x: pSExp ): pSExp; inline;
function ruiSetDdval( _x: pSExp; _v: integer ): pSExp; inline;

{ Environment Access Macros }

function ruiFrame( _x: pSExp ): pSExp; inline;
function ruiEnclos( _x: pSExp ): pSExp; inline;
function ruiHashtab( _x: pSExp ): pSExp; inline;
function ruiEnvflags( _x: pSExp ): integer; inline;
procedure ruiSetEnvflags( _x: pSExp; _v: integer ); inline;


{==============================================================================}
implementation

{---------------------------------------------------------- support bitfields }

type
  aBitSet = packed record
    Mask, Shift: Byte;
  end;

function GetWordBits( const _src: word; const _fld: aBitSet): word;
  begin
    result:= (_src shr _fld.Shift) and _fld.Mask;
  end;

procedure SetByteBits( var _dst: byte; const _fld: aBitSet; _val: byte );
  begin
    _dst:= _dst and not (_fld.Mask shl _fld.Shift) or
           ((_val and _fld.Mask) shl _fld.Shift);
  end;

const
  sxpinf1Type: aBitSet  = ( Mask: $0005; Shift: 0 );
  sxpinf1Obj: aBitSet   = ( Mask: $0001; Shift: 5 );
  sxpinf1Named: aBitSet = ( Mask: $0002; Shift: 6 );
  sxpinf2Mark: aBitSet =  ( Mask: $0001; Shift: 0 );
  sxpinf2Debug: aBitSet = ( Mask: $0001; Shift: 1 );
  sxpinf2Trace: aBitSet = ( Mask: $0001; Shift: 2 );
  sxpinf2Fin: aBitSet =   ( Mask: $0001; Shift: 3 );
  sxpinf2Gcgen: aBitSet = ( Mask: $0001; Shift: 4 );
  sxpinf2Gccls: aBitSet = ( Mask: $0003; Shift: 5 );


{---------------------------------------------------------- support direct access }

type
{ TODO -ohp -cfixme : not sure if CharArr and CplxArr work (in aData record) }
  pData = ^aData;
  aData = packed record
    offset: array[1..24] of byte;
    case byte of
      1: (IntArr: aIntegerArr);
      2: (DoubleArr: aDoubleArr);
      3: (CharArr: pChar);
      4: (ByteArr: aByteArr);
      5: (PtrArr: aPointerArr);
      6: (CplxArr: aRcomplexArr);
      7: (SExpArr: aSExpArr);
    end;

{---------------------------------------------------------- access SEXP }

{ General Cons Cell Attributes }

function ruiAttrib( _x: pSExp ): pSExp;
  begin
    result:= _x.seAttrib;
  end;

function ruiObject( _x: pSExp ): integer;
  begin
    result:= GetWordBits( _x.seSxpinfo.sxpField1, sxpinf1Obj );
  end;

function ruiMark( _x: pSExp ): integer;
  begin
    result:= GetWordBits( _x.seSxpinfo.sxpField2, sxpinf2Mark );
  end;

function ruiNamed( _x: pSExp ): integer;
  begin
    result:= GetWordBits( _x.seSxpinfo.sxpField1, sxpinf1Named );
  end;

function ruiTypeOf( _x: pSExp ): aSExpType;
  begin
    result:= aSExpType(GetWordBits( _x.seSxpinfo.sxpField1, sxpinf1Type ));
  end;

procedure ruiSetObject( _x: pSExp; _v: integer );
  begin
    SetByteBits( _x.seSxpinfo.sxpField1, sxpinf1Obj, _v );
  end;

procedure ruiSetTypeof( _x: pSExp; _v: aSExpType );
  var
    typ: integer;
  begin
    typ:= integer(_v);
    assert( (typ >= 0) and (typ <= 31),
        Format( 'rhSetTypeof: value (%d) violates range (0..31)' + #13#10#13#10 +
                '(Maybe this is the known problem that setFunSxp (%d) cannot be ' +
                'encoded in a 5 bit field)', [typ, TheSetFunSxp] ) );
    SetByteBits( _x.seSxpinfo.sxpField1, sxpinf1Type, typ );
  end;

procedure ruiSetNamed( _x: pSExp; _v: integer );
  begin
    SetByteBits( _x.seSxpinfo.sxpField1, sxpinf1Named, _v );
  end;

{ Vector Access Macros }

function ruiLength( _x: pSExp ): integer;
  begin
    result:= pVecSExp(_x).vecsxp.vsLength;
  end;

function ruiTruelength( _x: pSExp ): integer;
  begin
    result:= pVecSExp(_x).vecsxp.vsTruelength;
  end;

procedure ruiSetLength( _x: pSExp; _v: integer );
  begin
    pVecSExp(_x).vecsxp.vsLength:= _v;
  end;

procedure ruiSetTruelength( _x: pSExp; _v: integer );
  begin
    pVecSExp(_x).vecsxp.vsTruelength:= _v;
  end;

function ruiLevels( _x: pSExp ): integer;
  begin
    result:= _x.seSxpinfo.gp;
  end;

function ruiSetLevels( _x: pSExp; _v: integer ): integer;
  begin
    result:= pVecSExp(_x).vecsxp.vsTruelength;
  end;

function ruiDataptr( _x: pSExp ): pointer;
  begin
    result:= pData(_x).PtrArr[0];
  end;

function ruiChar( _x: pSExp ): pChar;
  begin
    result:= pData(_x).CharArr;
  end;
function ruiLogical( _x: pSExp ): aIntegerArr;
  begin
    result:= pData(_x).IntArr;
  end;
function ruiInteger( _x: pSExp ): aIntegerArr;
  begin
    result:= pData(_x).IntArr;
  end;
function ruiRaw( _x: pSExp ): aPointerArr;
  begin
    result:= pData(_x).PtrArr;
  end;
function ruiComplex( _x: pSExp ): aRcomplexArr;
  begin
    result:= pData(_x).CplxArr;
  end;
function ruiReal( _x: pSExp ): aDoubleArr;
  begin
    result:= pData(_x).DoubleArr;
  end;
function ruiStringElt( _x: pSExp; _i: integer ): pSExp;
  begin
    result:= pData(_x).PtrArr[_i];
  end;

function ruiVectorElt( _x: pSExp; _i: integer ): pSExp;
  begin
    result:= pData(_x).PtrArr[_i];
  end;

function ruiStringPtr( _x: pSExp ): aSExpArr;
  begin
    result:= pData(_x).SExpArr;
  end;

function ruiVectorPtr( _x: pSExp ): aSExpArr;
  begin
    result:= pData(_x).SExpArr;
  end;

{ List Access Macros (These also work for ... objects) }

function ruiListval( _x: pSExp ): aListSxp;
  begin
    result:= _x.seListsxp;
  end;

function ruiTag( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsTagval;
  end;

function ruiCar( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCarval;
  end;

function ruiCdr( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval;
  end;

function ruiCaar( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCarval.seListsxp.lsCarval;
  end;

function ruiCdar( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCarval.seListsxp.lsCdrval;
  end;

function ruiCadr( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval.seListsxp.lsCarval;
  end;

function ruiCddr( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval.seListsxp.lsCdrval;
  end;

function ruiCaddr( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCarval;
  end;

function ruiCadddr( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCarval;
  end;

function ruiCad4r( _x: pSExp ): pSExp;
  begin
    result:= _x.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCdrval.seListsxp.lsCarval;
  end;

function ruiMissing( _x: pSExp ): integer;
  const
    theMissingMask = 15;
  begin
      { TODO -ohp -cfixme : not sure if this is the right translation }
    result:= _x.seSxpinfo.gp and theMissingMask;
  end;

{ Closure Access Macros }

function ruiFormals( _x: pSExp ): pSExp;
  begin
    result:= _x.seClosxp.csFormals;
  end;

function ruiBody( _x: pSExp ): pSExp;
  begin
    result:= _x.seClosxp.csBody;
  end;

function ruiCloenv( _x: pSExp ): pSExp;
  begin
    result:= _x.seClosxp.csEnv;
  end;

function ruiDebug( _x: pSExp ): integer;
  begin
    result:= GetWordBits( _x.seSxpinfo.sxpField2, sxpinf2Debug );
  end;

function ruiTrace( _x: pSExp; _v: integer ): integer;
  begin
    result:= GetWordBits( _x.seSxpinfo.sxpField2, sxpinf2Trace );
  end;

procedure ruiSetDebug( _x: pSExp; _v: integer );
  begin
    SetByteBits( _x.seSxpinfo.sxpField2, sxpinf2Debug, _v );
  end;

procedure ruiSetTrace( _x: pSExp; _v: integer );
  begin
    SetByteBits( _x.seSxpinfo.sxpField2, sxpinf2Trace, _v );
  end;

{ Symbol Access Macros }

function ruiPrintName( _x: pSExp ): pSExp;
  begin
    result:= _x.seSymsxp.ssPname;
  end;

function ruiSymvalue( _x: pSExp ): pSExp;
  begin
    result:= _x.seSymsxp.ssValue;
  end;

function ruiInternal( _x: pSExp ): pSExp;
  begin
    result:= _x.seSymsxp.ssInternal;
  end;

function ruiDdval( _x: pSExp ): integer;
  const
    theDdvalMask = 1;
  begin
      { TODO -ohp -cfixme : not sure if this is the right translation of "(x)->sxpinfo.gp & DDVAL_MASK" }
    result:= _x.seSxpinfo.gp and theDdvalMask;
  end;

procedure ruiSetDdvalBit( _x: pSExp );
  begin
      { TODO -ohp -cimportant : SET_DDVAL_BIT missing in macros below }
    assert( False, 'rhSetDdvalBit: not (yet) implemented' );
  end;

function ruiUnsetDdvalBit( _x: pSExp ): pSExp;
  begin
      { TODO -ohp -cimportant : UNSET_DDVAL missing in macros below }
    assert( False, 'rhUnsetDdvalBit: not (yet) implemented' );
    result:= nil;  // avoid warnings
  end;

function ruiSetDdval( _x: pSExp; _v: integer ): pSExp;
  begin
      { TODO -ohp -cfixme : need SET_DDVAL_BIT and UNSET_DDVAL }
    if _v <> 0 then begin
      // SET_DDVAL_BIT
    end else begin
      // UNSET_DDVAL
    end {if true};
    result:= nil;  // avoid warnings
  end;

{ Environment Access Macros }

function ruiFrame( _x: pSExp ): pSExp;
  begin
    result:= _x.seEnvsxp.esFrame;
  end;

function ruiEnclos( _x: pSExp ): pSExp;
  begin
    result:= _x.seEnvsxp.esEnclos;
  end;

function ruiHashtab( _x: pSExp ): pSExp;
  begin
    result:= _x.seEnvsxp.esHashtab;
  end;

function ruiEnvflags( _x: pSExp ): integer;
  begin
    result:= _x.seSxpinfo.gp;
  end;

procedure ruiSetEnvflags( _x: pSExp; _v: integer );
  begin
    _x.seSxpinfo.gp:= _v;
  end;


end {rhRUseInternals}.

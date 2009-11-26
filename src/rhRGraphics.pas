unit rhRGraphics;

{ Pascal (Delphi) translation of the R headerfile Rgraphics.h
  (https://svn.r-project.org/R/trunk/src/include/Rgraphics.h). 
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


function rRgb( _r, _g, _b: LongWord ): LongWord;
function rRgba( _r, _g, _b, _a: LongWord ): LongWord;
function rRed( _col: LongWord ): LongWord;
function rGreen( _col: LongWord ): LongWord;
function rBlue( _col: LongWord ): LongWord;
function rAlpha( _col: LongWord ): LongWord;
function rOpaque( _col: LongWord ): boolean;
function rTransparent( _col: LongWord ): boolean;
function rTranwhite: LongWord;

const
{ TODO -ohp -csometimes : Not entirely sure if these shl  constants work as intended }
  TheLtyBlank	= -1;
  TheLtySolid	= 0;
  TheLtyDashed = 4 + (4 shl 4);
  TheLtyDotted = 1 + (3 shl 4 );
  TheLtyDotdash	= 1 + (3 shl 4) + (4 shl 8) + (3 shl 12);
  TheLtyLongdash =7 + (3 shl 4 );
  TheLtyTwodash	= 2 + (2 shl 4) + (6 shl 8) + (2 shl 12);

	{ possible coordinate systems (for specifying locations) }
type
  aGUnit = ( gunDevice	= 0 	    // native device coordinates (rasters)
           , gunNdc	= 1 	        // normalised device coordinates x=(0,1), y=(0,1)
           , gunInches = 13	      // inches x=(0,width), y=(0,height)
           , gunNic	= 6 	        // normalised inner region coordinates (0,1)
           , gunOma1	= 2 	      // outer margin 1 (bottom) x=NIC, y=LINES
           , gunOma2	= 3 	      // outer margin 2 (left)
           , gunOma3	= 4 	      // outer margin 3 (top)
           , gunOma4	= 5 	      // outer margin 4 (right)
           , gunNfc	= 7 	        // normalised figure region coordinates (0,1)
           , gunNpc	= 16	        // normalised plot region coordinates (0,1)
           , gunUser	= 12	      // user/data/world coordinat * x,=(xmin,xmax), y=(ymin,ymax) */
           , gunMar1	= 8 	      // figure margin 1 (bottom) x=USER(x), y=LINES
           , gunMar2	= 9 	      // figure margin 2 (left)   x=USER(y), y=LINES
           , gunMar3	= 10	      // figure margin 3 (top)    x=USER(x), y=LINES
           , gunMar4	= 11	      // figure margin 4 (right)  x=USER(y), y=LINES
           , gunLines = 14        // multiples of a line in the margin (mex)
           , gunChars = 15	      // multiples of text height (cex)
           );

  aColorDataBaseEntry = packed record
	  cbeName: pchar;              // X11 Color Name
	  cbeRgb: pChar;               // RRGGBB String
	  cbeCode: word;               // Internal R Color Code
  end;
  pColorDataBaseEntryArr = ^aColorDataBaseEntryArr;
  aColorDataBaseEntryArr = array[0..(MaxInt div SizeOf( aColorDataBaseEntry )) - 1 - theArrOff] of aColorDataBaseEntry;

{---------------------------------------------------------- global variables }

var
  RColorTableSize: integer;
  RColorTable: pLongWordArr;
  ColorDataBase: pColorDataBaseEntryArr;
  DefaultPalette: pChar;

type
  aVarRGraphics =       ( vrgRcolorTableSize, vrgRcolorTable
                        , vrgColorDataBase, vrgDefaultPalette );
  aLoadVarRGraphics =   set of aVarRGraphics;

const
  TheVarRGraphicsName:  array[aVarRGraphics] of string
                        = ( 'R_ColorTableSize', 'R_ColorTable'
                          , 'ColorDataBase', 'DefaultPalette' );

  TheVarRGraphicsPtr:   array[aVarRGraphics] of pointer
                        = ( @RcolorTableSize, @RColorTable
                          , @ColorDataBase, @DefaultPalette );

  TheVarRGraphicsType:  array[aVarRGraphics] of aRVarsType
                        = ( vtInteger, vtUndefined, vtUndefined, vtUndefined );

  TheLoadVarRGraphics:  aLoadVarRGraphics
                        = [ vrgRcolorTableSize, vrgRcolorTable
                          , vrgColorDataBase, vrgDefaultPalette ];

function ToRVarsArr( _set: aLoadVarRGraphics ): aRVarsArr; overload;

{---------------------------------------------------------- }

type
  pDevDesc = ^aDevDesc;
  aDevDesc = packed record
    ddDummy: integer;
  end;

{---------------------------------------------------------- }

{ GPar functions }

procedure rGRestore( _dd: pDevDesc );
procedure rGSavePars( _dd: pDevDesc );
procedure rGRestorePars( _dd: pDevDesc );

{ Device state functions }

procedure rGCheckState( _dd: pDevDesc );
procedure rGSetState( _newstate: integer; _dd: pDevDesc );


{ Graphical primitives }

procedure rGCircle( _x, _y: double; _coords: integer; _radius: double;
    _bg, _fg: integer; _dd: pDevDesc );

procedure rGClip( _dd: pDevDesc );
function rGClipPolygon( _x, _y: pDouble; _n, _coods, _store: integer;
    _xout, _yout: pDouble; _dd: pDevDesc ): integer;

procedure rGForceClip( _dd: pDevDesc );
procedure rGLine( _x1, y1, x2, y2: double; _coords: integer; _dd: pDevDesc );
function rGLocator(_x, _y: double; _coords: integer; _dd: pDevDesc ): aRBoolean;
procedure rGMetricInfo( _c: integer; _ascent, _descent, _width: pDouble;
    _units: aGUnit; _dd: pDevDesc);

procedure rGMode( _mode: integer; _dd: pDevDesc );
procedure rGPolygon( _n: integer; _x, _y: pDouble; _coords, _bg, _fg: integer; _dd: pDevDesc );
procedure rGPolyline( _n: integer; _x, _y: pDouble; _coords: integer; _dd: pDevDesc );
procedure rGRect( _x0, y0, x1, y1: double; _coords, _gb, _fg: integer; _dd: pDevDesc );
function rGStrHeight( _str: pChar; _units: aGUnit; _dd: pDevDesc ): double;
function rGStrWidth( _str: pChar; _units: aGUnit; _dd: pDevDesc ): double;
procedure rGText( _x, _y: double; _coords: integer; _str: pChar;
    _xc, _yc, _rot: double; _dd: pDevDesc );

{ TODO -ohp -caskRdevel : no entrypoints for GStartPath and GEndPath (in Rgraphics.h) }
//procedure GStartPath( _DevDesc*);
//procedure GEndPath( _DevDesc*);

procedure rGMathText( _x, y: double; _coords: integer; _expr: pSExp;
    _xc, _yc, _rot: double; _dd: pDevDesc );
procedure rGMMathText( _str: pSExp; _side: integer; _line: double; _outer: integer;
    _at: double; _las: integer; _yadj: double; _dd: pDevDesc );

type
  aGVTextRoutine = procedure( _x, _y, _unit: integer; _s: pChar;
      _typeface, _fontindex: integer; _xadj, _yadj, _rot: double; _dd: pDevDesc );

  aGVStrWidthRoutine = function( _s: pChar; _typeface, _fontindex, _unit: integer;
      _dd: pDevDesc ): double;

  aGVStrHeightRoutine = function( _s: pChar; _typeface, _fontindex, _unit: integer;
      _dd: pDevDesc ): double;

  aRSetVFontRoutines = procedure( _vwidth: aGVStrWidthRoutine;
      _vheight: aGVStrHeightRoutine; _vtext: aGVTextRoutine );

procedure rGVText( _x, _y: double; _unit: integer; _s: pChar;
    _typeface, _fontindex: integer; _xadj, _yadj, _rot: double; _dd: pDevDesc );
function rGVStrWidth( _s: pChar; _typeface, _fontindex, _unit: integer;
      _dd: pDevDesc ): double;
function rGVStrHeight( _s: pChar; _typeface, _fontindex, _unit: integer;
      _dd: pDevDesc ): double;

{ Graphical utilities }

procedure rGArrow( _xfrom, _yfrom, _xto, _yto: double; _coords: integer;
    _length, _angle: double; _code: integer; _dd: pDevDesc );

procedure rGBox( _which: integer; _dd: pDevDesc );
procedure rGPretty( _lo, _up: pDouble; _ndiv: integer );
procedure rGLPretty( _ul, _uh: double; _n: integer );
procedure rGMtext( _str: pChar; _side: integer; _line: double; _outer: integer;
    _at: double; _las: integer; _yadj: double; _dd: pDevDesc );

procedure rGSymbol( _x, _y: double; _coords, _pch: integer; _dd: pDevDesc );
  { Should be moved and is NOT part of the graphics engine API }
function rGExpressionHeight( _expr: pSExp; _units: aGUnit; _dd: pDevDesc ): double;
function rGExpressionWidth( _expr: pSExp; _units: aGUnit; _dd: pDevDesc ): double;

{ Colour code }

function rRgbPar( _x: pSExp; _i: integer ): integer;
function rCol2Name( _col: integer ): pChar;

{ Line texture code }

function rLtyPar( _value: pSExp; _ind: integer): integer;
function rLtyGet( _lty: integer): pSExp;

{ Transformations }

function rGMapUnits( _runits: integer ): aGUnit;
procedure rGConvert( _x, _y: pDouble; _from, _to: aGUnit; _dd: pDevDesc );
function rGConvertX( _x: double; _from, _to: aGUnit; _dd: pDevDesc ): double;
function rGConvertY( _y: double; _from, _to: aGUnit; _dd: pDevDesc ): double;
function rGConvertXUnits( _x: double; _from, _to: aGUnit; _dd: pDevDesc ): double;
function rGConvertYUnits( _y: double; _from, _to: aGUnit; _dd: pDevDesc ): double;

procedure rGReset( _dd: pDevDesc );

procedure rGMapWin2Fig( _dd: pDevDesc );
function rGNewPlot( _recording: aRBoolean ): pDevDesc;
procedure rGScale( _min, _max: double; _axis: integer; _dd: pDevDesc );
procedure rGSetupAxis( _axis: integer; _dd: pDevDesc );
procedure rCurrentFigureLocation( _row, _col: pInteger; _dd: pDevDesc );

  { which of these conversions should be public? maybe all? [NO_REMAP] }
function rXDevtoNDC( _x: double; _dd: pDevDesc ): double;
function rYDevtoNDC( _y: double; _dd: pDevDesc ): double;
function rXDevtoNFC( _x: double; _dd: pDevDesc ): double;
function rYDevtoNFC( _y: double; _dd: pDevDesc ): double;
function rXDevtoNPC( _x: double; _dd: pDevDesc ): double;
function rYDevtoNPC( _y: double; _dd: pDevDesc ): double;
function rXDevtoUsr( _x: double; _dd: pDevDesc ): double;
function rYDevtoUsr( _y: double; _dd: pDevDesc ): double;
function rXNPCtoUsr( _x: double; _dd: pDevDesc ): double;
function rYNPCtoUsr( _y: double; _dd: pDevDesc ): double;

{ TODO -ohp -caskRdevel : The next 3 function (Vector fonts) are already declared above!! }
//function GVStrWidth( _s: pChar; _typeface, _fontindex, _unit: integer; _dd: pDevDesc ): double;
//function GVStrHeight( _s: pChar; _typeface, _fontindex, _unit: integer; _dd: pDevDesc ): double;
//procedure GVText( _x, _y: double; _unit: integer; _s: pChar; _typeface, _fontindex: double; _xJustify, _yJustify, _rotation: double; _dd: pDevDesc );

{ Devices }

function rCurDevice(): integer;
function rCurrentDevice(): pDevDesc;
function rNoDevices(): integer;
function rNewFrameConfirm(): aRBoolean;
procedure rInitDisplayList( _dd: pDevDesc );

{ some functions that plot.c needs to share with plot3d.c }

function rCreateAtVector( _axp, _usr: pDouble; _nint: integer; _logflag: aRBoolean): pSExp;
procedure rGetAxisLimits( _left, _right: double; _low, _high: pDouble );
function rLabelformat( _labels: pSExp ): pSExp;


{==============================================================================}
implementation
uses
  rhR;

{ Support for global variable initialization }

function ToRVarsArr( _set: aLoadVarRGraphics ): aRVarsArr;
  var
    i: aVarRGraphics;
    idx: integer;
  begin
    SetLength( result, 0 );
    for i:= Low( aVarRGraphics ) to High( aVarRGraphics ) do begin
      if i in _set then begin
        if i <> vrgRcolorTableSize then begin
          rRprintf( pChar('Global variable "' + TheVarRGraphicsName[i] +
              '" cannot be loaded. Only ' + TheVarRGraphicsName[vrgRcolorTableSize] +
              ' is supported right now') );
          Continue;
        end;
        idx:= Length( result );
        SetLength( result, idx + 1 );
        result[idx].gvName:= TheVarRGraphicsName[i];
        result[idx].gvPointer:= TheVarRGraphicsPtr[i];
        result[idx].gvType:= TheVarRGraphicsType[i];
      end;
    end;
  end {LoadVarRGraphicsToArr};


{ TODO -ohp -csometimes : Not entirely sure if these shl  things work as intended }
function rRgb( _r, _g, _b: LongWord ): LongWord;
  begin
  	result:= (_r) or (_g shl 8) or (_b shl 16) or ($FF000000);
  end;
function rRgba( _r, _g, _b, _a: LongWord ): LongWord;
  begin
  	result:= (_r) or (_g shl 8) or (_b shl 16) or (_a shl 24);
  end;
function rRed( _col: LongWord ): LongWord;
  begin
    result:= _col and 255;
  end;
function rGreen( _col: LongWord ): LongWord;
  begin
    result:= (_col shr 8) and 255;
  end;
function rBlue( _col: LongWord ): LongWord;
  begin
    result:= (_col shr 16) and 255;
  end;
function rAlpha( _col: LongWord ): LongWord;
  begin
    result:= (_col shr 24) and 255;
  end;
function rOpaque( _col: LongWord ): boolean;
  begin
    result:= rAlpha( _col ) = 255;
  end;
function rTransparent( _col: LongWord ): boolean;
  begin
    result:= rAlpha( _col ) = 0;
  end;
function rTranwhite: LongWord;
  begin
    result:= rRgba( 255, 255, 255, 0 );
  end;

{---------------------------------------------------------- }

procedure rGRestore; external TheRDll name 'Rf_GRestore';
procedure rGSavePars; external TheRDll name 'Rf_GSavePars';
procedure rGRestorePars; external TheRDll name 'Rf_GRestorePars';

procedure rGCheckState; external TheRDll name 'Rf_GCheckState';
procedure rGSetState; external TheRDll name 'Rf_GSetState';

procedure rGCircle; external TheRDll name 'Rf_GCircle';
procedure rGClip; external TheRDll name 'Rf_GClip';
function rGClipPolygon; external TheRDll name 'Rf_GClipPolygon';
procedure rGForceClip; external TheRDll name 'Rf_GForceClip';
procedure rGLine; external TheRDll name 'Rf_GLine';
function rGLocator; external TheRDll name 'Rf_GLocator';
procedure rGMetricInfo; external TheRDll name 'Rf_GMetricInfo';
procedure rGMode; external TheRDll name 'Rf_GMode';
procedure rGPolygon; external TheRDll name 'Rf_GPolygon';
procedure rGPolyline; external TheRDll name 'Rf_GPolyline';
procedure rGRect; external TheRDll name 'Rf_GRect';
function rGStrHeight; external TheRDll name 'Rf_GStrHeight';
function rGStrWidth; external TheRDll name 'Rf_GStrWidth';
procedure rGText; external TheRDll name 'Rf_GText';

procedure rGMathText; external TheRDll name 'Rf_GMathText';
procedure rGMMathText; external TheRDll name 'Rf_GMMathText';

procedure rGVText; external TheRDll name 'Rf_GVText';
function rGVStrWidth; external TheRDll name 'Rf_GVStrWidth';
function rGVStrHeight; external TheRDll name 'Rf_GVStrHeight';

procedure rGArrow; external TheRDll name 'Rf_GArrow';
procedure rGBox; external TheRDll name 'Rf_GBox';
procedure rGPretty; external TheRDll name 'Rf_GPretty';
procedure rGLPretty; external TheRDll name 'Rf_GLPretty';
procedure rGMtext; external TheRDll name 'Rf_GMtext';
procedure rGSymbol; external TheRDll name 'Rf_GSymbol';
function rGExpressionHeight; external TheRDll name 'Rf_GExpressionHeight';
function rGExpressionWidth; external TheRDll name 'Rf_GExpressionWidth';

function rRgbPar; external TheRDll name 'Rf_RGBpar';
function rCol2Name; external TheRDll name 'Rf_col2name';

function rLtyPar; external TheRDll name 'Rf_LTYpar';
function rLtyGet; external TheRDll name 'Rf_LTYget';

function rGMapUnits; external TheRDll name 'Rf_GMapUnits';
procedure rGConvert; external TheRDll name 'Rf_GConvert';
function rGConvertX; external TheRDll name 'Rf_GConvertX';
function rGConvertY; external TheRDll name 'Rf_GConvertY';
function rGConvertXUnits; external TheRDll name 'Rf_GConvertXUnits';
function rGConvertYUnits; external TheRDll name 'Rf_GConvertYUnits';

procedure rGReset; external TheRDll name 'Rf_GReset';

procedure rGMapWin2Fig; external TheRDll name 'Rf_GMapWin2Fig';
function rGNewPlot; external TheRDll name 'Rf_GNewPlot';
procedure rGScale; external TheRDll name 'Rf_GScale';
procedure rGSetupAxis; external TheRDll name 'Rf_GSetupAxis';
procedure rCurrentFigureLocation; external TheRDll name 'Rf_currentFigureLocation';

  { which of these conversions should be public? maybe all? [NO_REMAP] }
function rXDevtoNDC; external TheRDll name 'Rf_xDevtoNDC';
function rYDevtoNDC; external TheRDll name 'Rf_yDevtoNDC';
function rXDevtoNFC; external TheRDll name 'Rf_xDevtoNFC';
function rYDevtoNFC; external TheRDll name 'Rf_yDevtoNFC';
function rXDevtoNPC; external TheRDll name 'Rf_xDevtoNPC';
function rYDevtoNPC; external TheRDll name 'Rf_yDevtoNPC';
function rXDevtoUsr; external TheRDll name 'Rf_xDevtoUsr';
function rYDevtoUsr; external TheRDll name 'Rf_yDevtoUsr';
function rXNPCtoUsr; external TheRDll name 'Rf_xNPCtoUsr';
function rYNPCtoUsr; external TheRDll name 'Rf_yNPCtoUsr';

function rCurDevice; external TheRDll name 'Rf_curDevice';
function rCurrentDevice; external TheRDll name 'Rf_CurrentDevice';
function rNoDevices; external TheRDll name 'Rf_NoDevices';
function rNewFrameConfirm; external TheRDll name 'Rf_NewFrameConfirm';
procedure rInitDisplayList; external TheRDll name 'Rf_initDisplayList';

function rCreateAtVector; external TheRDll name 'Rf_CreateAtVector';
procedure rGetAxisLimits; external TheRDll name 'Rf_GetAxisLimits';
function rLabelformat; external TheRDll name 'Rf_labelformat';


end {rhRGraphics}.

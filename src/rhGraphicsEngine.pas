unit rhGraphicsEngine;

{ Pascal (Delphi) translation of the R headerfile GraphicsEngine.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsEngine.h). 
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
  rhRinternals, rhGraphicsDevice, rhxTypesAndConsts;

const
  TheRGeVersion = 2;

function rGeGetVersion: integer; cdecl;
procedure rGeCheckVersionOrDie( _version: integer ); cdecl;

type
  aGeUnit =  ( geuDevice = 0        // native device coordinates (rasters)
	           , geuNdc = 1           // normalised device coordinates x=(0,1), y=(0,1)
             , geuInches = 2
             , geuCm = 3 );

const
  TheMaxGraphicsSystems = 24;

type
  aGeEvent = ( geInitState = 0
             , geFinaliseState = 1
             , geSaveState = 2
             , geRestoreState = 6
             , geCopyState = 3
             , geSaveSnapshotState = 4
             , geRestoreSnapshotState = 5
             , geCheckPlot = 7
             , geScalePS = 8 );

  pGeDevDesc = ^aGeDevDesc;
  pGeSystemDesc = ^aGeSystemDesc;

  aGeCallback = function( _evt: aGeEvent; _dd: pGeDevDesc; _arg: pSExp ): pSExp;

  aGeSystemDesc = packed record
    gsdSystemSpecific: pointer;
    gsdCallback: aGeCallback;
  end;

  aGeDevDesc = packed record
    gddNewDevStruct: integer;
    gddDdev: pNewDevDesc;
    gddDirty: aRBoolean;
    gddRecordGraphics: aRBoolean;
    gddCesd: array[0..TheMaxGraphicsSystems - 1] of pGeSystemDesc;
  end;

  aRGeLineEnd = ( gleRoundCap = 1, gleButtCap = 2, gleSquareCap = 3 );
  aRGeLineJoin = ( gljRoundJoin = 1, gljMitreJoin = 2, gljBevelJoin = 3 );

pRGeGcontext = ^aRGeGcontext;
aRGeGcontext = packed record
  rgcCol: integer;                  // pen colour (lines, text, borders, ...)
  rgcFill: integer;                 // fill colour (for polygons, circles, rects, ...)
  rgcGamma: double;                 // Gamma correction

  rgcLwd: double;                   // Line width (roughly number of pixels)
  rgcLty: integer;                  // Line type (solid, dashed, dotted, ...)
  rgcLend: aRgeLineEnd;             // Line end
	rgcLjoin: aRgeLineJoin;           // line join
  rgcLmitre: double;                // line mitre

  rgcCex: double;                   // character expansion (font size = fontsize*cex)
  rgcPs: double;                    // Font size in points
  rgcLineHeight: double;            // Line height (multiply by font size)
  rgcFontFace: integer;             // Font face (plain, italic, bold, ...)
  rgcFontfamily: array[0..200] of char;  // Font family
end;

function rGeCreateDevDesc( _dev: pNewDevDesc ): PGeDevDesc; cdecl;
procedure rGeDestroyDevDesc( _dd: pGeDevDesc ); cdecl;
function rGeSstemState( _dd: pGeDevDesc; _index: integer ): pointer; cdecl;
procedure rGeRegisterWithDevice( _dd: pGeDevDesc ); cdecl;
procedure rGeRegisterSystem( _callback: aGeCallback; _systemRegisterIndex: pInteger); cdecl;
procedure rGeUnregisterSystem( _registerIndex: integer); cdecl;

function rGeHandleEvent(event: aGeEvent; var dev: pNewDevDesc; data: pSExp): pSExp; cdecl;

function rFromDeviceX( _value: double; _to: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rToDeviceX( _value: double; from: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rFromDeviceY( _value: double; _to: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rToDeviceY( _value: double; from: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rFromDeviceWidth( _value: double; _to: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rToDeviceWidth( _value: double; from: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rFromDeviceHeight( _value: double; _to: aGeUnit; var dd: pGeDevDesc): double; cdecl;
function rToDeviceHeight( _value: double; from: aGeUnit; var dd: pGeDevDesc): double; cdecl;

const
  TheLtyBlank = -1;
  TheLtySolid = 0;
  { TODO -ohp -ccheck : not sure if these bitwise operations are correct (esp. the "+") }
  TheLtyDashed = 4 + (4 shl 4);
  TheLtyDotted = 1 + (3 shl 4);
  TheLtyDotdash = 1 + (3 shl 4) + (4 shl 8) + (3 shl 12);
  TheLtyLongdash = 7 + (3 shl 4);
  TheLtyTwodash = 2 + (2 shl 4) + (6 shl 8) + (2 shl 12);

function rLendPar( _value: pSExp; _ind: integer): aRgeLineEnd; cdecl;
function rLendGet(lend: aRgeLineEnd): pSExp; cdecl;
function rLjoinPar( _value: pSExp; _ind: integer): aRgeLineJoin; cdecl;
function rLjoinGet( _ljoin: aRgeLineJoin): pSExp; cdecl;

procedure rGeSetClip( _x1, _y1, _x2, _y2: double; _dd: pGeDevDesc); cdecl;
procedure rGeNewPage( _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGeLine( _x1, _y1, _x2, _y2: double; _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGePolyline( _n: integer; _x, _y: pDouble;_gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGePolygon( _n: integer; _x, _y: pDouble; _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
{ TODO -ohp -caskRdevel : GEXspline doesn't have an entry point }
//function rGeXspline( _n: integer; _x, _y, _s: pDouble; _open: aRBoolean;
//    _repEnds: aRBoolean; _draw: aRBoolean; _gc: pRgeGcontext; _dd: pGeDevDesc): pSExp; cdecl;
procedure rGeCircle( _x, _y, _radius: double; _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGeRect(x0, y0, x1, y1: double; _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGeText( _x, _y: double; _str: PChar; _xc, _yc, _rot: double;
    _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGeMode( _mode: integer; _dd: pGeDevDesc); cdecl;
procedure rGeSymbol( _x, _y: double; _pch: integer; _size: double;
    _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;
procedure rGePretty( _lo, _up: pDouble; _ndiv: pInteger); cdecl;
procedure rGeMetricInfo( _c: integer; _gc: pRgeGcontext;
    _ascent, descent, width: pDouble; _dd: pGeDevDesc); cdecl;
function rGeStrWidth( _str: PChar; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;
function rGeStrHeight( _str: PChar; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;

function rGeExpressionWidth( _expr: pSExp; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;
function rGeExpressionHeight( _expr: pSExp; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;
procedure rGeMathText( _x, _y: double; _expr: pSExp; _xc, _yc, _rot: double;
    _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;

function rGeContourLines( _x: pDouble; _nx: integer; _y: double; _ny: integer;
    _z, _levels: double; _nl: integer): pSExp; cdecl;

type
  aRGeVtextroutine = procedure( _x, _y: double; _s: pChar; _xJustify,
      _yJustify, _rotation: double; _gc: pRgeGcontext; _dd: pGeDevDesc );

  aRGeVstrWidthHeightRoutine = function( _s: pByte; _gc: pRgeGcontext;
      _dd: pGeDevDesc ): double;

procedure rGeSetVFontRoutines( _vwidth, _vheight: aRgeVstrWidthHeightRoutine;
    _vtext: aRgeVtextroutine ); cdecl;
function rGeVStrWidth( _s: pByte; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;
function rGeVStrHeight( _s: PByte; _gc: pRgeGcontext; _dd: pGeDevDesc): double; cdecl;
procedure rGeVText( _x, _y: double; _s: pChar; _xJustify, _yJustify,
    _rotation: double; _gc: pRgeGcontext; _dd: pGeDevDesc); cdecl;

const
  TheDeg2Rad = 0.01745329251994329576;

function rGeCurrentDevice: pGeDevDesc; cdecl;
function rGeDeviceDirty(_dd: pGeDevDesc): aRBoolean; cdecl;
procedure rGeDirtyDevice(_dd: pGeDevDesc); cdecl;
function rGeCheckState(_dd: pGeDevDesc): aRBoolean; cdecl;
function rGeRecording( _call: pSExp; _dd: pGeDevDesc): aRBoolean; cdecl;
procedure rGeRecordGraphicOperation( _op: pSExp; _args: pSExp; _dd: pGeDevDesc); cdecl;
procedure rGeInitDisplayList( _dd: pGeDevDesc); cdecl;
procedure rGePlayDisplayList( _dd: pGeDevDesc); cdecl;
procedure rGeCopyDisplayList( _fromDevice: integer); cdecl;
function rGeCreateSnapshot( _dd: pGeDevDesc): pSExp; cdecl;
procedure rGePlaySnapshot( _snapshot: pSExp; _dd: pGeDevDesc); cdecl;
procedure rGeOnExit; cdecl;
{ TODO -ohp -caskRdevel : GEnullDevice doesn't have an entry point }
//procedure rGeNullDevice; cdecl;


{==============================================================================}
implementation

function rGeGetVersion; external TheRDll name 'R_GE_getVersion';
procedure rGeCheckVersionOrDie; external TheRDll name 'R_GE_checkVersionOrDie';

function rGeCreateDevDesc; external TheRDll name 'GEcreateDevDesc';
procedure rGeDestroyDevDesc; external TheRDll name 'GEdestroyDevDesc';
function rGeSstemState; external TheRDll name 'GEsystemState';
procedure rGeRegisterWithDevice; external TheRDll name 'GEregisterWithDevice';
procedure rGeRegisterSystem; external TheRDll name 'GEregisterSystem';
procedure rGeUnregisterSystem; external TheRDll name 'GEunregisterSystem';

function rGeHandleEvent; external TheRDll name 'GEHandleEvent';

function rFromDeviceX; external TheRDll name 'FromDeviceX';
function rToDeviceX; external TheRDll name 'ToDeviceX';
function rFromDeviceY; external TheRDll name 'FromDeviceY';
function rToDeviceY; external TheRDll name 'ToDeviceY';
function rFromDeviceWidth; external TheRDll name 'FromDeviceWidth';
function rToDeviceWidth; external TheRDll name 'ToDeviceWidth';
function rFromDeviceHeight; external TheRDll name 'FromDeviceHeight';
function rToDeviceHeight; external TheRDll name 'ToDeviceHeight';

function rLendPar; external TheRDll name 'LENDpar';
function rLendGet; external TheRDll name 'LENDget';
function rLjoinPar; external TheRDll name 'LJOINpar';
function rLjoinGet; external TheRDll name 'LJOINget';

procedure rGeSetClip; external TheRDll name 'GESetClip';
procedure rGeNewPage; external TheRDll name 'GENewPage';
procedure rGeLine; external TheRDll name 'GELine';
procedure rGePolyline; external TheRDll name 'GEPolyline';
procedure rGePolygon; external TheRDll name 'GEPolygon';
//function rGeXspline; external TheRDll name 'GEXspline';
procedure rGeCircle; external TheRDll name 'GECircle';
procedure rGeRect; external TheRDll name 'GERect';
procedure rGeText; external TheRDll name 'GEText';
procedure rGeMode; external TheRDll name 'GEMode';
procedure rGeSymbol; external TheRDll name 'GESymbol';
procedure rGePretty; external TheRDll name 'GEPretty';

procedure rGeMetricInfo; external TheRDll name 'GEMetricInfo';
function rGeStrWidth; external TheRDll name 'GEStrWidth';
function rGeStrHeight; external TheRDll name 'GEStrHeight';

function rGeExpressionWidth; external TheRDll name 'GEExpressionWidth';
function rGeExpressionHeight; external TheRDll name 'GEExpressionHeight';
procedure rGeMathText; external TheRDll name 'GEMathText';

function rGeContourLines; external TheRDll name 'GEcontourLines';

procedure rGeSetVFontRoutines; external TheRDll name 'R_GE_setVFontRoutines';
function rGeVStrWidth; external TheRDll name 'R_GE_VStrWidth';
function rGeVStrHeight; external TheRDll name 'R_GE_VStrHeight';
procedure rGeVText; external TheRDll name 'R_GE_VText';

function rGeCurrentDevice; external TheRDll name 'GEcurrentDevice';
function rGeDeviceDirty; external TheRDll name 'GEdeviceDirty';
procedure rGeDirtyDevice; external TheRDll name 'GEdirtyDevice';
function rGeCheckState; external TheRDll name 'GEcheckState';
function rGeRecording; external TheRDll name 'GErecording';
procedure rGeRecordGraphicOperation; external TheRDll name 'GErecordGraphicOperation';
procedure rGeInitDisplayList; external TheRDll name 'GEinitDisplayList';
procedure rGePlayDisplayList; external TheRDll name 'GEplayDisplayList';
procedure rGeCopyDisplayList; external TheRDll name 'GEcopyDisplayList';
function rGeCreateSnapshot; external TheRDll name 'GEcreateSnapshot';
procedure rGePlaySnapshot; external TheRDll name 'GEplaySnapshot';
procedure rGeOnExit; external TheRDll name 'GEonExit';
//procedure rGeNullDevice; external TheRDll name 'GEnullDevice';


end {rhGraphicsEngine}.

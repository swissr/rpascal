unit rhGraphicsDevice;

{ Pascal (Delphi) translation of the R headerfile GraphicsDevice.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsDevice.h). 
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

type
  pNewDevDesc = ^aNewDevDesc;
  aNewDevDesc = packed record
    nddNewDevStruct: integer;       // new device driver is 1, old driver 0

    nddLeft: double;                // left raster coordinate
    nddRight: double;               // right raster coordinate
    nddBottom: double;              // bottom raster coordinate
    nddTop: double;                 // top raster coordinate

    nddClipLeft: double;
    nddClipRight: double;
    nddClipBottom: double;
    nddClipTop: double;

    nddXCharOffset: double;         // x character addressing offset
    nddYCharOffset: double;         // y character addressing offset
    nddYLineBias: double;           // 1/2 interline space as frac of line hght
    nddIpr: array[0..1] of double;  // Inches per raster; [0]=x, [1]=y
    nddAsp: double;                 // Pixel aspect ratio = ipr[1]/ipr[0]

    nddCra: array[0..1] of double;  // character size in rasters; [0]=x, [1]=y
    nddGamma: double;               // Device Gamma Correction

    nddCanResizePlot: aRBoolean;    // can the graphics surface be resized
    nddCanChangeFont: aRBoolean;    // device has multiple fonts
    nddCanRotateText: aRBoolean;    // text can be rotated
    nddCanResizeText: aRBoolean;    // text can be resized
    nddCanClip: aRBoolean;          // Hardware clipping
    nddCanChangeGamma: aRBoolean;   // can the gamma factor be modified
    nddCanHAdj: integer;            // Can do at least some horiz adjust of text 0 = none, 1 = {0,0.5, 1}, 2 = [0,1]

    nddStartPs: double;
    nddStartCol: integer;
    nddStartFill: integer;
    nddStartLty: integer;
    nddStartFont: integer;
    nddStartGamma: double;

    nddDeviceSpecific: pointer;     // pointer to device specific parameters

    nddDisplayListOn: aRBoolean;    // toggle for display list status
    nddDisplayList: pSExp;          // display list
    nddDLlastElt: pSExp;
    nddSavedSnapshot: pSExp;        // The last value of the display l

    nddcanGenMouseDown: aRBoolean;  // can the device generate mousedown events
    nddcanGenMouseMove: aRBoolean;  // can the device generate mousemove events
    nddcanGenMouseUp: aRBoolean;    // can the device generate mouseup events
    nddcanGenKeybd: aRBoolean;      // can the device generate keyboard events

    nddGettingEvent: aRBoolean;     // This is set while getGraphicsEvent is actively looking for events

    nddActivate: aProc;
    nddCircle: aProc;
    nddClip: aProc;
    nddClose: aProc;
    nddDeactivate: aProc;
    nddDot: aProc;
    nddHold: aProc;
    nddLocator: aRboolFunc;
    nddLline: aProc;
    nddMetricInfo: aProc;
    nddMode: aProc;
    nddNewPage: aProc;
    nddOpen: aRboolFunc;
    nddPolygon: aProc;
    nddPolyline: aProc;
    nddRect: aProc;
    nddSize: aProc;
    nddStrWidth: aDoubleFunc;
    nddText: aProc;
    nddOnExit: aProc;
    nddGetEvent: aSexpFunc;
  end;


{==============================================================================}
implementation


end {rhGraphicsDevice}.

unit rhGraphicsBase;

{ Pascal (Delphi) translation of the R headerfile GraphicsBase.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/GraphicsBase.h). 
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
  rhxTypesAndConsts;

{ TODO -ohp -cunfinished : Use of unit tthGraphicsBase unclear }


(*

type
{ TODO -ohp -caskRdevel : GPar is defined in Graphics.h which is not LGPL'ed }
  aGPar = pointer;

  aBaseSystemState = packed record
    bssDp: aGPar;
    bssGp: aGPar;
    bssDpSaved: aGPar;
    bssBaseDevice: aRBoolean;
  end;

procedure rhRegisterBase();

function rfBaseDevice( _dd: pDevDesc ): aRBoolean;
procedure rfSetBaseDevice( _val: aRBoolean; _dd: pDevDesc );

*)

{==============================================================================}
implementation




end {rhGraphicsBase}.

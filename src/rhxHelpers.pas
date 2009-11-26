unit rhxHelpers;

{ Helpers for the R headerfile translation.
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

{ support for records with bitfields }

type
{ TODO -ohp -cfixme : Not sure if I should declare the record(s) as packed.
  Probably it's better because I have more control of the fields alignement
  (this todo is for all records) }
  aBitSet = packed record
    Mask, Shift: Byte;
  end;

function GetWordBits( const Source: word; const Field: aBitSet): word;
procedure SetByteBits( var Dest: byte; const Field: aBitSet; Value: byte );

{==============================================================================}
implementation


function GetWordBits( const Source: word; const Field: aBitSet): word;
begin
  result:= (Source shr Field.Shift) and Field.Mask;
end;

procedure SetByteBits( var Dest: byte; const Field: aBitSet; Value: byte );
begin
  Dest:= Dest and not (Field.Mask shl Field.Shift) or
         ((Value and Field.Mask) shl Field.Shift);
end;

end {rhxHelpers}.

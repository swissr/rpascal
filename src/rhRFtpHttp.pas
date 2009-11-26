unit rhRFtpHttp;

{ Pascal (Delphi) translation of the R headerfile R-ftp-http.h
  (https://svn.r-project.org/R/trunk/src/include/R_ext/R-ftp-http.h). 
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
  rhRinternals, rhxTypesAndConsts;

  { Advertized entry points, for that part of libxml included in
    the internet module. }

function rHttpOpen( _url: pChar ): pointer; cdecl;
function rHttpRead( _ctx: pointer; _dest: pChar; _len: integer ): integer; cdecl;
procedure rHttpClose( _ctx: pointer ); cdecl;

function rFtpOpen( _url: pChar ): pointer; cdecl;
function rFtpRead( _ctx: pointer; _dest: pChar; _len: integer ): integer; cdecl;
procedure rFtpClose( _ctx: pointer ); cdecl;

{ TODO -ohp -caskRDevel : There are no entry points for rXmlNano... functions }
//function rXmlNanoHttpOpen( _url: pChar; _contentType: ppChar; _cacheOk: integer ): pointer; cdecl;
//function rXmlNanoHttpRead( _ctx: pointer; _dest: pChar; _len: integer ): integer; cdecl;
//procedure rXmlNanoHttpClose( _ctx: pointer ); cdecl;
//function rXmlNanoHttpReturnCode( _ctx: pointer ): integer; cdecl;
//function rXmlNanoHttpStatusMsg( _ctx: pointer ): pChar; cdecl;
//function rXmlNanoHttpContentLength( _ctx: pointer ): integer; cdecl;
//function rXmlNanoHttpContentType( _ctx: pointer ): pChar; cdecl;
//procedure rXmlNanoHttpTimeout( _delay: integer ); cdecl;

//function rXmlNanoFtpOpen( _url: pChar ): pointer; cdecl;
//function rXmlNanoFtpRead( _ctx: pointer; _dest: pChar; _len: integer ): integer; cdecl;
//procedure rXmlNanoFtpClose( _ctx: pointer ); cdecl;
//procedure rXmlNanoFtpTimeout( _delay: integer ); cdecl;
//function rXmlNanoFtpContentLength( _ctx: pointer ): integer; cdecl;

//procedure rXmlMessage( _level: integer; _format: pChar ); varargs; cdecl;

//procedure rXmlNanoFtpCleanup(); cdecl;
//procedure rXmlNanoHttpCleanup(); cdecl;


{==============================================================================}
implementation


function rHttpOpen; external TheRDll name 'R_HttpOpen';
function rHttpRead; external TheRDll name 'R_HttpRead';
procedure rHttpClose; external TheRDll name 'R_HttpClose';

function rFtpOpen; external TheRDll name 'R_FtpOpen';
function rFtpRead; external TheRDll name 'R_FtpRead';
procedure rFtpClose; external TheRDll name 'R_FtpClose';

//function rXmlNanoHttpOpen; external TheRDll name 'R_XmlNanoHttpOpen';
//function rXmlNanoHttpRead; external TheRDll name 'R_XmlNanoHttpRead';
//procedure rXmlNanoHttpClose; external TheRDll name 'R_XmlNanoHttpClose';
//function rXmlNanoHttpReturnCode; external TheRDll name 'R_XmlNanoHttpReturnCode';
//function rXmlNanoHttpStatusMsg; external TheRDll name 'R_XmlNanoHttpStatusMsg';
//function rXmlNanoHttpContentLength; external TheRDll name 'R_XmlNanoHttpContentLength';
//function rXmlNanoHttpContentType; external TheRDll name 'R_XmlNanoHttpContentType';
//procedure rXmlNanoHttpTimeout; external TheRDll name 'R_XmlNanoHttpTimeout';
//function rXmlNanoFtpOpen; external TheRDll name 'R_XmlNanoFtpOpen';
//function rXmlNanoFtpRead; external TheRDll name 'R_XmlNanoFtpRead';
//procedure rXmlNanoFtpClose; external TheRDll name 'R_XmlNanoFtpClose';
//procedure rXmlNanoFtpTimeout; external TheRDll name 'R_XmlNanoFtpTimeout';
//function rXmlNanoFtpContentLength; external TheRDll name 'R_XmlNanoFtpContentLength';
//procedure rXmlMessage; external TheRDll name 'R_XmlMessage';
//procedure rXmlNanoFtpCleanup(); external TheRDll name 'R_XmlNanoFtpCleanup()';
//procedure rXmlNanoHttpCleanup(); external TheRDll name 'R_XmlNanoHttpCleanup()';



end {rhRFtpHttp}.

unit rhBlas;

{ Pascal (Delphi) translation of the R headerfile BLAS.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/BLAS.h). 
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

{ TODO -ohp -caskRdevel : there are quite a lot functions in BLAS that don't
  have an entrypoint in the Rblas.dll (or any other dll)
  (listing: zdrot; zgbmv; zgeru; zhbmv; zhemm; zher; zherk; zhpmv; zhpr;
   zhpr2; zrotg; zsymm; zsyr2k; zsyrk; ztbmv; ztbsv; ztpmv; ztpsv;)
   Maybe it's because something was added in 2.3 }


{---------------------------------------------------------- double Precision Level 1 BLAS }

procedure rDasum( _n: pInteger; _dx: pDouble; _incx: pInteger ); cdecl;

procedure rDaxpy( _n: pInteger; _alpha, _dx: pDouble; _incx: pInteger;
    _dy: pdouble; _incy: pInteger ); cdecl;

procedure rDcopy( _n: pInteger; _dx: pDouble; _incx: pInteger; _dy: pdouble;
    _incy: pInteger ); cdecl;

procedure rDdot( _n: pInteger; _dx: pDouble; _incx: pInteger; _dy: pDouble;
    _incy: pInteger ); cdecl;

procedure rDnrm2( _n: pInteger; _dx: pDouble; _incx: pInteger ); cdecl;

procedure rDrot( _n: pInteger; var _dx: double; const incx: pInteger;
    var _dy: double; _incy: pInteger; _c, _s: pDouble); cdecl;

procedure rDrotg( _a, _b, _c, _s: double); cdecl;

procedure rDrotm( _n: pInteger; var _dx: double; _incx: pInteger; var _dy: double;
    _incy: pInteger; _dparam: pDouble); cdecl;

procedure rDrotmg( _dd1, _dd2, _dx1, _dy1, _param: pdouble); cdecl;

procedure rDscal( _n: pInteger; _alpha, _dx: pdouble; _incx: pInteger ); cdecl;

procedure rDswap( _n: pInteger; var _dx: double; _incx: pInteger; _dy: pdouble;
    _incy: pInteger ); cdecl;

procedure rIdamax( _n: pInteger; _dx: pDouble; _incx: pInteger ); cdecl;

{---------------------------------------------------------- double Precision Level 2 BLAS }

procedure rDgbmv( _trans: pChar; _m, _n, _kl, _ku: pInteger;
    _alpha, _a: pDouble; _lda: pInteger; _x: pDouble;
    _incx: pInteger; _beta, _y: pdouble; _incy: pInteger ); cdecl;

procedure rDgemv( _trans: pChar; _m, _n, _alpha, _a: pDouble;
    _lda: pInteger; _x: pDouble; _incx: pInteger; _beta, _y: double;
    _incy: pInteger ); cdecl;

procedure rDsbmv( _uplo: pChar; _n, _k: pInteger; _alpha, _a: pDouble;
    _lda: pInteger; _x: pDouble; _incx: pInteger; _beta, _y: double;
    _incy: pInteger ); cdecl;

procedure rDspmv( _iuplo: pChar; _n: pInteger; _alpha, _ap, _x: pDouble;
    _incx: pInteger; _beta, _y: double; _incy: pInteger ); cdecl;

procedure rDsymv( _iuplo: pChar; _n: pInteger; _alpha, _a: pDouble;
    _lda: pInteger; _x: pDouble; _incx: pInteger; _beta: pDouble; _y: double;
    _incy: pInteger ); cdecl;

procedure rDtbmv( _iuplo, _trans, _diag: pChar; _n, _k: pInteger;
    _a: pDouble; _lda: pInteger; _x: pdouble; _incx: pInteger ); cdecl;

procedure rDtpmv( _iuplo, _trans, _diag: pChar; _n: pInteger;
    _ap, _x: pdouble; _incx: pInteger ); cdecl;

procedure rDtrmv( _iuplo, _trans, _diag: pChar; _n: pInteger;
    _a: pDouble; _lda: pInteger; _x: pdouble; _incx: pInteger ); cdecl;

procedure rDtbsv( _iuplo, _trans, _diag: pChar; _n, _k: pInteger;
    _a: pDouble; _lda: pInteger; _x: pdouble; _incx: pInteger ); cdecl;

procedure rDtpsv( _iuplo, _trans, _diag: pChar; _n: pInteger;
    _ap: pDouble; _x: pdouble; _incx: pInteger ); cdecl;

procedure rDtrsv( _iuplo, _trans, _diag: pChar; _n: pInteger;
    _a: pDouble; _lda: pInteger; _x: pdouble; _incx: pInteger ); cdecl;

procedure rDger( _im, _n: pInteger; _alpha: pDouble; _x: pdouble;
    _incx: pInteger; _y: pdouble; _incy: pInteger; _a: pdouble;
    _lda: pInteger ); cdecl;

procedure rDsyr( _iuplo: pChar; _n: pInteger; _alpha: pDouble; _x: pDouble;
    _incx: pInteger; _a: pdouble; _lda: pInteger ); cdecl;

procedure rDspr( _iuplo: pChar; _n: pInteger; _alpha: pDouble; _x: pDouble;
    _incx: pInteger; _ap: pdouble); cdecl;

procedure rDsyr2( _iuplo: pChar; _n: pInteger; _alpha: pDouble; _x: pDouble;
    _incx: pInteger; _y: pDouble; _incy: pInteger; _a: pdouble; _lda: pInteger ); cdecl;

procedure rDspr2( _iuplo: pChar; _n: pInteger; _alpha, _x: pDouble;
    _incx: pInteger; _y: pDouble; _incy: pInteger; _ap: pdouble); cdecl;

{---------------------------------------------------------- double Precision Level 3 BLAS }

procedure rDgemm( _itransa, _transb: pChar; _m, _n, _k: pInteger;
    _alpha, _a: pDouble; _lda: pInteger; _b: pDouble;
    _ldb: pInteger; _beta, _c: pdouble; _ldc: pInteger ); cdecl;

procedure rDtrsm( _iside, _uplo, _transa, _diag: pChar;
    _m, _n: pInteger; _alpha, _a: pDouble; _lda: pInteger;
    _b: pdouble; _ldb: pInteger ); cdecl;

procedure rDtrmm( _iside, _uplo, _transa, _diag: pChar;
    _m, _n: pInteger; _alpha, _a: pDouble; _lda: pInteger;
    _b: pdouble; _ldb: pInteger ); cdecl;

procedure rDsymm( _iside, _uplo: pChar; _m, _n: pInteger;
    _alpha, _a: pDouble; _lda: pInteger; _b: pDouble; _ldb: pInteger;
    _beta, _c: pdouble; _ldc: pInteger ); cdecl;

procedure rDsyrk( _iuplo, _trans: pChar; _n, _k: pInteger;
    _alpha, _a: pDouble; _lda: pInteger; _beta: pDouble; _c: pdouble;
    _ldc: pInteger ); cdecl;

procedure rDsyr2k( _iuplo, _trans: pChar; _n, _k: pInteger;
    _alpha, _a: pDouble; _lda: pInteger; _b: pDouble; _ldb: pInteger;
    _beta, _c: pdouble; _ldc: pInteger ); cdecl;

{---------------------------------------------------------- LSAME is a LAPACK support
                                                            routine, not part of BLAS }

{ double complex BLAS routines added for 2.3.0 }

function rDcabs1( _z: pdouble): double cdecl;
function rDzasum( _n: pinteger; _zx: pRcomplex; _incx: pinteger ): double; cdecl;
function rDznrm2( _n: pinteger; _x: pRcomplex; _incx: pinteger ): double; cdecl;
function rIzamax( _n: pinteger; _zx: pRcomplex; _incx: pinteger ): integer; cdecl;

procedure rZaxpy( _n: pinteger; _za, _zx: pRcomplex;
    _incx: pinteger; _zy: pRcomplex; _incy: pinteger ); cdecl;

procedure rZcopy( _n: pinteger; _zx: pRcomplex; _incx: pinteger;
    _zy: pRcomplex; _incy: pinteger ); cdecl;

function rZdotc( _ret_val: pRcomplex; _n: pinteger; _zx: pRcomplex;
    _incx: pinteger; _zy: pRcomplex; _incy: pinteger ): aRcomplex; cdecl;

function rZdotu( _ret_val: pRcomplex; _n: pinteger; _zx: pRcomplex;
    _incx: pinteger; _zy: pRcomplex; _incy: pinteger ): aRcomplex; cdecl;

{ TODO -ohp -cfixme : All outcommented functions don't have entry points (see above) }

//procedure rZdrot( _n: pinteger; _zx: pRcomplex; _incx: pinteger;
//    _zy: pRcomplex; _incy: pinteger; _c: pdouble;
//    _s: pdouble); cdecl;

procedure rZdscal( _n: pinteger; _da: pdouble; _zx: pRcomplex;
    _incx: pinteger ); cdecl;

//procedure rZgbmv( _trans: pchar; _m, _n, _kl, _ku: pinteger;
//    _alpha, _a: pRcomplex; _lda: pinteger; _x: pRcomplex; _incx: pinteger;
//    _beta, _y: pRcomplex; _incy: pinteger ); cdecl;

procedure rZgemm( _itransa, _transb: pChar; _m, _n, _k: pInteger;
    _alpha, _a: pRcomplex; _lda: pInteger;
    _b: pRcomplex; _ldb: pInteger; _beta, _c: pRcomplex;
    _ldc: pInteger ); cdecl;

procedure rZgemv(trans: pChar; _m, _n: pinteger;
    _alpha, _a: pRcomplex; _lda: pinteger;
    _x: pRcomplex; _incx: pinteger; _beta: pRcomplex;
    _y: pRcomplex; _incy: pinteger ); cdecl;

procedure rZgerc( _m, _n: pinteger; _alpha: pRcomplex;
    _x: pRcomplex; _incx: pinteger; _y: pRcomplex; _incy: pinteger;
    _a: pRcomplex; _lda: pinteger ); cdecl;

//procedure rZgeru( _m, _n: pinteger; _alpha, _x: pRcomplex;
//    _incx: pinteger; _y: pRcomplex;_incy: pinteger;
//    _a: pRcomplex; _lda: pinteger ); cdecl;

//procedure rZhbmv( _uplo: pChar; _n, _k: pinteger;
//    _alpha, _a: pRcomplex; _lda: pinteger;
//    _x: pRcomplex; _incx: pinteger; _beta, _y: pRcomplex; _incy: pinteger ); cdecl;

//procedure rZhemm( _side: pChar; uplo: pChar; _m, _n: pinteger;
//    _alpha, _a: pRcomplex; _lda: pinteger;
//    _b: pRcomplex; _ldb: pinteger; _beta, _c: pRcomplex; _ldc: pinteger ); cdecl;

procedure rZhemv( _uplo: pChar; _n: pinteger; _alpha, _a: pRcomplex;
    _lda: pinteger; _x: pRcomplex; _incx: pinteger;
    _beta, _y: pRcomplex; _incy: pinteger ); cdecl;

//procedure rZher( _uplo: pChar; _n: pinteger; _alpha: pdouble;
//    _x: pRcomplex; _incx: pinteger; _a: pRcomplex; _lda: pinteger ); cdecl;

procedure rZher2( _uplo: pChar; _n: pinteger; _alpha, _x: pRcomplex;
    _incx: pinteger; _y: pRcomplex; _incy: pinteger;
    _a: pRcomplex; _lda: pinteger ); cdecl;

procedure rZher2k( _uplo: pChar; trans: pChar; _n, _k: pinteger;
    _alpha, _a: pRcomplex; _lda: pinteger;
    _b: pRcomplex; _ldb: pinteger; _beta: pdouble; _c: pRcomplex;
    _ldc: pinteger ); cdecl;

//procedure rZherk( _uplo, trans: pChar; _n, _k: pinteger;
//    _alpha: pdouble; _a: pRcomplex; _lda: pinteger; _beta: pdouble;
//    _c: pRcomplex; _ldc: pinteger ); cdecl;

//procedure rZhpmv( _uplo: pChar; _n: pinteger; _alpha, _ap, _x: pRcomplex;
//    _incx: pinteger; _beta, _y: pRcomplex; _incy: pinteger ); cdecl;

//procedure rZhpr( _uplo: pChar; _n: pinteger; _alpha: pdouble;
//    _x: pRcomplex; _incx: pinteger; _ap: pRcomplex); cdecl;

//procedure rZhpr2( _uplo: pChar; _n: pinteger; _alpha, _x: pRcomplex;
//    _incx: pinteger; _y: pRcomplex; _incy: pinteger; _ap: pRcomplex); cdecl;

//procedure rZrotg( _ca, _cb: pRcomplex; _c: pdouble; _s: pRcomplex); cdecl;

procedure rZscal( _n: pinteger; _za, _zx: pRcomplex; _incx: pinteger ); cdecl;

procedure rZswap( _n: pinteger; _zx: pRcomplex; _incx: pinteger;
    _zy: pRcomplex; _incy: pinteger ); cdecl;

//procedure rZsymm( _side, uplo: pChar; _m, _n: pinteger; _alpha, _a: pRcomplex;
//    _lda: pinteger; _b: pRcomplex; _ldb: pinteger; _beta, _c: pRcomplex;
//    _ldc: pinteger ); cdecl;

//procedure rZsyr2k( _uplo: pChar; trans: pChar; _n, _k: pinteger;
//    _alpha, _a: pRcomplex; _lda: pinteger; _b: pRcomplex;
//    _ldb: pinteger; _beta, _c: pRcomplex; _ldc: pinteger ); cdecl;

//procedure rZsyrk( _uplo, trans: pChar; _n, _k: pinteger;
//    _alpha, _a: pRcomplex; _lda: pinteger; _beta, _c: pRcomplex; _ldc: pinteger ); cdecl;

//procedure rZtbmv( _uplo, trans, diag: pChar; _n, _k: pinteger; _a: pRcomplex;
//    _lda: pinteger; _x: pRcomplex; _incx: pinteger ); cdecl;

//procedure rZtbsv( _uplo, trans, diag: pChar; _n, _k: pinteger;
//    _a: pRcomplex; _lda: pinteger; _x: pRcomplex; _incx: pinteger ); cdecl;

//procedure rZtpmv( _uplo, trans, diag: pChar; _n: pinteger;
//    _ap, _x: pRcomplex; _incx: pinteger ); cdecl;

//procedure rZtpsv( _uplo, trans, diag: pChar; _n: pinteger;
//    _ap, _x: pRcomplex; _incx: pinteger ); cdecl;

procedure rZtrmm( _side, _uplo, _transa, _diag: pChar;
    _m, _n: pinteger; _alpha, _a: pRcomplex;
    _lda: pinteger; _b: pRcomplex; _ldb: pinteger ); cdecl;

procedure rZtrmv( _uplo, trans, diag: pChar; _n: pinteger;
    _a: pRcomplex; _lda: pinteger; _x: pRcomplex; _incx: pinteger ); cdecl;

procedure rZtrsm( _side, _uplo, _transa, _diag: pChar;
   _m, _n: pinteger; _alpha, _a: pRcomplex;
    _lda: pinteger; _b: pRcomplex; _ldb: pinteger ); cdecl;

procedure rZtrsv( _uplo, trans, diag: pChar; _n: pinteger;
    _a: pRcomplex; _lda: pinteger; _x: pRcomplex; _incx: pinteger ); cdecl;


{==============================================================================}
implementation


{ double Precision Level 1 BLAS }

procedure rDasum; external TheBlasDll name 'dasum_';
procedure rDaxpy; external TheBlasDll name 'daxpy_';
procedure rDcopy; external TheBlasDll name 'dcopy_';
procedure rDdot; external TheBlasDll name 'ddot_';
procedure rDnrm2; external TheBlasDll name 'dnrm2_';
procedure rDrot; external TheBlasDll name 'drot_';
procedure rDrotg; external TheBlasDll name 'drotg_';
procedure rDrotm; external TheBlasDll name 'drotm_';
procedure rDrotmg; external TheBlasDll name 'drotmg_';
procedure rDscal; external TheBlasDll name 'dscal_';
procedure rDswap; external TheBlasDll name 'dswap_';
procedure rIdamax; external TheBlasDll name 'idamax_';

{ double Precision Level 2 BLAS }

procedure rDgbmv; external TheBlasDll name 'dgbmv_';
procedure rDgemv; external TheBlasDll name 'dgemv_';
procedure rDsbmv; external TheBlasDll name 'dsbmv_';
procedure rDspmv; external TheBlasDll name 'dspmv_';
procedure rDsymv; external TheBlasDll name 'dsymv_';
procedure rDtbmv; external TheBlasDll name 'dtbmv_';
procedure rDtpmv; external TheBlasDll name 'dtpmv_';
procedure rDtrmv; external TheBlasDll name 'dtrmv_';
procedure rDtbsv; external TheBlasDll name 'dtbsv_';
procedure rDtpsv; external TheBlasDll name 'dtpsv_';
procedure rDtrsv; external TheBlasDll name 'dtrsv_';
procedure rDger; external TheBlasDll name 'dger_';
procedure rDsyr; external TheBlasDll name 'dsyr_';
procedure rDspr; external TheBlasDll name 'dspr_';
procedure rDsyr2; external TheBlasDll name 'dsyr2_';
procedure rDspr2; external TheBlasDll name 'dspr2_';

{ double Precision Level 3 BLAS }

procedure rDgemm; external TheBlasDll name 'dgemm_';
procedure rDtrsm; external TheBlasDll name 'dtrsm_';
procedure rDtrmm; external TheBlasDll name 'dtrmm_';
procedure rDsymm; external TheBlasDll name 'dsymm_';
procedure rDsyrk; external TheBlasDll name 'dsyrk_';
procedure rDsyr2k; external TheBlasDll name 'dsyr2k_';

{ LSAME is a LAPACK support routine, not part of BLAS }

function rDcabs1; external TheBlasDll name 'dcabs1_';
function rDzasum; external TheBlasDll name 'dzasum_';
function rDznrm2; external TheBlasDll name 'dznrm2_';
function rIzamax; external TheBlasDll name 'izamax_';
procedure rZaxpy; external TheBlasDll name 'zaxpy_';
procedure rZcopy; external TheBlasDll name 'zcopy_';
function rZdotc; external TheBlasDll name 'zdotc_';
function rZdotu; external TheBlasDll name 'zdotu_';
//procedure rZdrot; external TheBlasDll name 'zdrot_';
procedure rZdscal; external TheBlasDll name 'zdscal_';
//procedure rZgbmv; external TheBlasDll name 'zgbmv_';
procedure rZgemm; external TheBlasDll name 'zgemm_';
procedure rZgemv; external TheBlasDll name 'zgem_';
procedure rZgerc; external TheBlasDll name 'zgerc_';
//procedure rZgeru; external TheBlasDll name 'zgeru_';
//procedure rZhbmv; external TheBlasDll name 'zhbmv_';
//procedure rZhemm; external TheBlasDll name 'zhemm_';
procedure rZhemv; external TheBlasDll name 'zhemv_';
//procedure rZher; external TheBlasDll name 'zher_';
procedure rZher2; external TheBlasDll name 'zher2_';
procedure rZher2k; external TheBlasDll name 'zher2k_';
//procedure rZherk; external TheBlasDll name 'zherk_';
//procedure rZhpmv; external TheBlasDll name 'zhpmv_';
//procedure rZhpr; external TheBlasDll name 'zhpr_';
//procedure rZhpr2; external TheBlasDll name 'zhpr2_';
//procedure rZrotg; external TheBlasDll name 'zrotg_';
procedure rZscal; external TheBlasDll name 'zscal_';
procedure rZswap; external TheBlasDll name 'zswap_';
//procedure rZsymm; external TheBlasDll name 'zsymm_';
//procedure rZsyr2k; external TheBlasDll name 'zsyr2k_';
//procedure rZsyrk; external TheBlasDll name 'zsyrk_';
//procedure rZtbmv; external TheBlasDll name 'ztbmv_';
//procedure rZtbsv; external TheBlasDll name 'ztbsv_';
//procedure rZtpmv; external TheBlasDll name 'ztpmv_';
//procedure rZtpsv; external TheBlasDll name 'ztpsv_';
procedure rZtrmm; external TheBlasDll name 'ztrmm_';
procedure rZtrmv; external TheBlasDll name 'ztrmv_';
procedure rZtrsm; external TheBlasDll name 'ztrsm_';
procedure rZtrsv; external TheBlasDll name 'ztrsv_';

end {rhBlas}.

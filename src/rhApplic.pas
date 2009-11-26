unit rhApplic;

{ Pascal (Delphi) translation of the R headerfile Applic.h.
  (https://svn.r-project.org/R/trunk/src/include/R_ext/Applic.h). 
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

{ -- Entry points in the R API }

type
  aIntegrFn = procedure( var _x: double; _n: integer; _ex: pointer );

{ appl/integrate.c }

procedure rRdqags( _f: aIntegrFn; _ex: pointer; _a, _b, _epsabs, _epsrel,
    _result, _abserr: pDouble; _neval, _ier, _limit, _lenw, _last, _iwork: pInteger;
    _work: pDouble ); cdecl;

procedure rRdqagi( _f: aIntegrFn; _ex: pointer; _bound: pDouble; _inf: pInteger;
    _epsabs, _epsrel, _result, _abserr: pDouble; _neval, _ier, _limit, _lenw,
    _last, _iwork: pInteger; var _work: double ); cdecl;

{ appl/rcont.c }

procedure rRcont2( var _nrow: integer; var _ncol: integer; var _nrowt: integer;
    _ncolt, _ntotal: pinteger; _fact: pdouble; _jwork, _matrix: pinteger ); cdecl;

{ main/optim.c }

type
  aOptimfn = function( _n: integer; var _p: double; _ex: pointer ): double;
  aOptimgr = procedure( _n: integer; var _p: double; var _df: double; _ex: pointer );

procedure rVmmin( _n: integer; _b, _fmin: pDouble; _fn, _gr: aOptimgr; _maxit,
    _trace: integer; _mask: pInteger; _abstol, _reltol: double; _nReport: integer;
    _ex: pointer; _fncount, _grcount, _fail: pInteger ); cdecl;

procedure rNmmin( _n: integer; _bvec, _X, _fmin: pDouble; _fn: aOptimfn;
    _fail: pInteger; _abstol: double; _intol: double; _ex: pointer; _alpha: double;
    _bet: double; _gamm: double; _trace: integer; _fncount: pInteger; _maxit: integer ); cdecl;

procedure rCgmin( _n: integer; _bvec, _X, _fmin: pDouble; _fn, _gr: aOptimgr;
    _fail: pInteger; _abstol, _intol: double; _ex: pointer; _type, _trace:
    integer; _fncount, _grcount: pInteger; _maxit: integer ); cdecl;

procedure rLbfgsb( _n, _m: integer; _x, _l, _u: pDouble; _nbd: pInteger;
    _Fmin: pDouble; _fn, _gr: aOptimgr; _fail: pInteger; _ex: pointer; _factr,
    _pgtol: pDouble; _fncount, _grcount: pInteger; _maxit: integer; _msg: PChar;
    _trace, _nReport: integer ); cdecl;

procedure rSamin( _n: integer; _pb, _yb: pDouble; _fn: aOptimfn; _maxit,
    _tmax: integer; _ti: double; _trace: integer; _ex: pointer ); cdecl;

{ -- Entry points NOT in the R API }

{ TODO -ohp -caskRdevel : I don't understand the remark
  "Entry points NOT in the R API". Why are they here? }

{ appl/approx.c }

procedure rApprox( _x, _y: pdouble; _nxy: pinteger; _xout: pdouble;
    _nout: pinteger; _method: pinteger; _yleft, _yright, _f: pdouble); cdecl;

{ appl/bakslv.c }

procedure rBakslv( _1: pDouble; _2, _3: pInteger; _4: pDouble; _5, _6: pInteger;
    _7: pDouble; _8, _9: pInteger ); cdecl;

{ appl/binning.c }

procedure rBincode( _x: pDouble; _n: pInteger; _breaks: pDouble; _nb, _code,
    _right, _includeBorder, _naok: pInteger ); cdecl;

procedure rBincount( _x: pDouble; _n: pInteger; _breaks: pDouble; _nb, _count,
    _right, _includeBorder, _naok: pInteger ); cdecl;

{ appl/ch2inv.f }

procedure rCh2inv( _x: pDouble; _ldx, _n: pInteger; _v: pDouble; _info: pInteger ); cdecl;

{ appl/chol.f }

procedure rChol( _x: pDouble; _lda, _n: pInteger; _v: pDouble; _info: pInteger ); cdecl;

{ appl/cpoly.c : }

procedure rCpolyroot( _opr, _opi: pDouble; _degree: pInteger; _zeror,
    _zeroi: pDouble; var _fail: aRBoolean ); cdecl;

{ More `Complex Polynomial Utilities' could be exported }

{ appl/cumsum.c : }

procedure rCumsum( _1: pDouble; _2: pInteger; _3, _4: pDouble ); cdecl;

{ appl/eigen.f }

function rCg( _nm, _n: pInteger; _ar, _ai, _wr, _wi: pDouble; _matz: pInteger;
    _zr, _zi, _fv1, _fv2, _fv3: pDouble; _ierr: pInteger ): integer; cdecl;

function rCh( _nm, _n: pInteger; _ar, _ai, _w: pDouble; _matz: pInteger; _zr,
    _zi, _fv1, _fv2, _fm1: pDouble; _ierr: pInteger ): integer; cdecl;

function rRg( _nm, _n: pInteger; _a, _wr, _wi: pDouble; _matz: pInteger;
    _z: pDouble; _iv1: pInteger; _fv1: pDouble; _ierr: pInteger ): integer; cdecl;

function rRs( _nm, _n: pInteger; _a, _w: pDouble; _matz: pInteger; _z, _fv1,
    _fv2: pDouble; _ierr: pInteger ): integer; cdecl;

{ appl/fft.c }

procedure rFftFactor( _n: integer; _pmaxf, _pmaxp: pInteger ); cdecl;

function rFftWork( _a, _b: pDouble; _nseg, _n, _nspn, _isn: integer;
    _work: pDouble; _iwork: pInteger ): aRBoolean; cdecl;

{ appl/fmin.c }

type
  aApplicF = function( _1: double; _2: pointer ): double;

function rBrentFmin( _ax, _bx: double; _f: aApplicF; _info: pointer;
    _tol: double ): double; cdecl;

{ appl/interv.c (was also in Utils, skipped }

function rInterv( _xt: pDouble; _n: pInteger; _x: pDouble; _rightmostClosed,
    _allInside: pRBoolean; _ilo, _mflag: pInteger ): integer; cdecl;

procedure rFindIntervVec( _xt: pDouble; _n: pInteger; _x: pDouble; _nx,
    _rightmostClosed, _allInside, _indx: pInteger ); cdecl;

function rFindInterval( _xt: pDouble; _n: integer; _x: double; _rightmostClosed,
    _allInside: aRBoolean; _ilo: integer; _mflag: pInteger ): integer; cdecl;

{ appl/lbfgsb.c }

procedure rSetulb( _n, _m: integer; _x, _l, _u: pDouble; _nbd: pInteger; _f,
    _g: pDouble; _factr: double; _pgtol, _wa: pDouble; var _iwa: integer;
    _task: PChar; _iprint: integer; _lsave, _isave: pInteger; _dsave: pDouble); cdecl;

{ appl/lminfl.c }

procedure rLminfl( _x: pDouble; _ldx, _n, _k: pInteger; _qraux, _resid, _hat,
    _coef, _sigma: pDouble); cdecl;

{ appl/loglin.c }

procedure rLoglin( _nvar, _dim, _ncon, _config, _ntab: pInteger; _table,
    _fit: pDouble; _locmar, _nmar: pInteger; _marg: pDouble; _nu: pInteger; _u,
    _maxdev: pDouble; _maxit: pInteger; _dev: pDouble; _nlast, _ifault: pInteger ); cdecl;

{ appl/lowess.c }

procedure rLowess( _x, _y: pDouble; _n: pInteger; _f: pDouble; _nsteps: pInteger;
    _delta, _ys, _rw, _res: pDouble); cdecl;

{ appl/machar.c }

procedure rMachar( _ibeta, _it, _irnd, _ngrd, _machep, _negep, _iexp, _minexp,
    _maxexp: pInteger; _eps, _epsneg, _xmin, _xmax: pDouble ); cdecl;

{ appl/massdist.c }

procedure rMassdist( _x, _xmass: pDouble; _nx: pInteger; _xlow, _xhigh,
    _y: pDouble; _ny: pInteger ); cdecl;

{ appl/maxcol.c (was also in Utils, skipped) }

procedure rMaxCol( _matrix: pDouble; _nr, _nc, _maxes, _tiesMeth: pInteger ); cdecl;

{ appl/pretty.c }

function rPretty0( _lo, _up: pDouble; _ndiv: pInteger; _minN: integer;
    _shrinkSml: double; _highUFact: pDoubleArr; _epsCorrection,
    _returnBounds: integer ): double; cdecl;

procedure rPretty( _lo, _up: pDouble; _ndiv, _minN: pInteger; _shrinkSml,
    _highUFact: pDouble; _epsCorrection: pInteger ); cdecl;

{ appl/rowsum.c }

procedure rRowsum( _dim: pInteger; _naX, _x, _group: pDouble ); cdecl;

{ appl/splines.c }

procedure rSplineCoef( _method, _n: pInteger; _x, _y, _b, _c, _d, _e: pDouble); cdecl;
procedure rSplineEval( _method, _nu: pInteger; _u, _v: pDouble; _n: pInteger;
    _x, _y, _b, _c, _d: pDouble); cdecl;

procedure rNaturalSpline( _n: integer; _x, _y, _b, _c, _d: pDouble); cdecl;
procedure rFmmSpline( _n: integer; _x, _y, _b, _c, _d: pDouble); cdecl;
procedure rPeriodicSpline( _n: integer; _x, _y, _b, _c, _d, _e: pDouble); cdecl;

{ appl/stem.c }

function rStemleaf( _x: pDouble; _n: pInteger; _scale: pDouble; _width: pInteger;
    _atom: pDouble ): aRBoolean; cdecl;

{ appl/strsignif.c }

procedure rStrSignif( _x: PChar; _n: pInteger; _type: pPChar; _width,
    _digits: pInteger; var _format: PChar; var _flag: PChar; var _result: PChar ); cdecl;

{ appl/tabulate.c }

procedure rTabulate( _x, _n, _nbin, _ans: pInteger ); cdecl;

{ appl/uncmin.c : }

{ type of pointer to the target and gradient functions }
type
  aFcn = procedure( _n: integer; _x, _g: pDouble; _state: pointer );
  aD2fcn = procedure( _nr, _n: integer; _x, _g: pDouble; _state: pointer );

procedure rFdhess( _n: integer; _x: pDouble; _fval: double; _fun: aFcn;
    _state: pointer; _h: pDouble; _nfd: integer; _step, _f: pDouble;
    _ndigit: integer; _typx: pDouble); cdecl;

procedure rOptif9( _nr, _n: integer; _x: pDouble; _fcn, _d1fcn: aFcn;
    _d2fcn: aD2fcn; _state: pointer; _typsiz: pDouble; _fscale: double;
    _method, _iexp: integer; var _msg: integer; _ndigit, _itnlim: integer;
    _iagflg, _iahflg: integer; _dlt, _gradtl, _stepmx, _steptl: double; _xpls,
    _fpls, _gpls: pDouble; _itrmcd: pInteger; _a, _wrk: pDouble; _itncnt: pInteger ); cdecl;

procedure rOptif0( _nr, _n: integer; _x: pDouble; _fcn: aFcn; _state: pointer;
    _xpls, _fpls, _gpls: pDouble; _itrmcd: pInteger; _a, _wrk: pDouble ); cdecl;

{ appl/zeroin.c }

function rZeroin( _ax, _bx: double; _f: aApplicF; _info: pointer; _tol: pDouble;
    _maxit: pInteger ): double; cdecl;


{ <Here are some routines missing who are commented out in the header file> }


{ find qr decomposition, dqrdc2() is basis of R's qr(), also used by nlme }

procedure rDqrdc2( _x: pDouble; _ldx, _n, _p: pInteger; _tol: pDouble;
    _rank: pInteger; _qraux: pDouble; _pivot: pInteger; _work: pDouble ); cdecl;

procedure rDqrls( _x: pDouble; _n, _p: pInteger; _y: pDouble; _ny: pInteger;
    _tol, _b, _rsd, _qty: pDouble; _k, _jpvt: pInteger; _qraux, _work: pDouble); cdecl;

{ appl/dqrutl.f: interfaces to dqrsl }

procedure rDqrqty( _x: pDouble; _n, _k: pInteger; _qraux, _y: pDouble;
    _ny: pInteger; _qty: pDouble ); cdecl;

procedure rDqrqy( _x: pDouble; _n, _k: pInteger; _qraux, _y: pDouble;
    _ny: pInteger; _qy: pDouble); cdecl;

procedure rDqrcf( _x: pDouble; _n, _k: pInteger; _qraux, _y: pDouble;
    _ny: pInteger; _b: pDouble; _info: pInteger ); cdecl;

procedure rDqrrsd( _x: pDouble; _n, _k: pInteger; _qraux, _y: pDouble;
    _ny: pInteger; _rsd: pDouble); cdecl;

procedure rDqrxb( _x: pDouble; _n, _k: pInteger; _qraux, _y: pDouble;
    _ny: pInteger; _xb: pDouble ); cdecl;


{==============================================================================}
implementation


{ Entry points in the R API }

procedure rRdqags; external TheRDll name 'Rdqags';
procedure rRdqagi; external TheRDll name 'Rdqagi';
procedure rRcont2; external TheRDll name 'Rcont2';
procedure rVmmin; external TheRDll name 'vmmin';
procedure rNmmin; external TheRDll name 'nmmin';
procedure rCgmin; external TheRDll name 'cgmin';
procedure rLbfgsb; external TheRDll name 'lbfgsb';
procedure rSamin; external TheRDll name 'samin';

{ Entry points NOT in the R API }

procedure rApprox; external TheRDll name 'R_approx';
procedure rBakslv; external TheRDll name 'bakslv';
procedure rBincode; external TheRDll name 'bincode';
procedure rBincount; external TheRDll name 'bincount';
procedure rCh2inv; external TheRDll name 'ch2inv_';
procedure rChol; external TheRDll name 'chol_';
procedure rCpolyroot; external TheRDll name 'R_cpolyroot';
procedure rCumsum; external TheRDll name 'R_cumsum';
function rCg; external TheRDll name 'cg_';
function rCh; external TheRDll name 'ch_';
function rRg; external TheRDll name 'rg_';
function rRs; external TheRDll name 'rs_';
procedure rFftFactor; external TheRDll name 'fft_factor';
function rFftWork; external TheRDll name 'fft_work';
function rBrentFmin; external TheRDll name 'Brent_fmin';
function rInterv; external TheRDll name 'interv_';
procedure rFindIntervVec; external TheRDll name 'find_interv_vec';
function rFindInterval; external TheRDll name 'findInterval';
procedure rSetulb; external TheRDll name 'setulb';
procedure rLminfl; external TheRDll name 'lminfl_';
procedure rLoglin; external TheRDll name 'loglin';
procedure rLowess; external TheRDll name 'lowess';
procedure rMachar; external TheRDll name 'machar';
procedure rMassdist; external TheRDll name 'massdist';
procedure rMaxCol; external TheRDll name 'R_max_col';
function rPretty0; external TheRDll name 'R_pretty0';
procedure rPretty; external TheRDll name 'R_pretty';
procedure rRowsum; external TheRDll name 'R_rowsum';
procedure rSplineCoef; external TheRDll name 'spline_coef';
procedure rSplineEval; external TheRDll name 'spline_eval';
procedure rNaturalSpline; external TheRDll name 'natural_spline';
procedure rFmmSpline; external TheRDll name 'fmm_spline';
procedure rPeriodicSpline; external TheRDll name 'periodic_spline';
function rStemleaf; external TheRDll name 'stemleaf';
procedure rStrSignif; external TheRDll name 'str_signif';
procedure rTabulate; external TheRDll name 'R_tabulate';
procedure rFdhess; external TheRDll name 'fdhess';
procedure rOptif9; external TheRDll name 'optif9';
procedure rOptif0; external TheRDll name 'optif0';
function rZeroin; external TheRDll name 'R_zeroin';
procedure rDqrdc2; external TheRDll name 'dqrdc2_';
procedure rDqrls; external TheRDll name 'dqrls_';
procedure rDqrqty; external TheRDll name 'dqrqty_';
procedure rDqrqy; external TheRDll name 'dqrqy_';
procedure rDqrcf; external TheRDll name 'dqrcf_';
procedure rDqrrsd; external TheRDll name 'dqrrsd_';
procedure rDqrxb; external TheRDll name 'dqrxb_';

end {rhApplic}.

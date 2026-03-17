$title Household accounting model


*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------


$if not set file_path $set file_path "%system.fp%/../data/household_legacy_windc.gdx"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/legacy_windc_load_data.gms"


parameter
    etaK "Capital elasticity of output" /4/;

parameter
    ta(r,g)	Counterfactual consumption taxes,
    ty(r,s)	Counterfactual production taxes
    tm(r,g)	Counterfactual import taxes,
    tk(r,s)	Counterfactual capital taxes,
    tfica(r,h)	Counterfactual FICA labor taxes,
    tl(r,h)	Counterfactual marginal labor taxes;

ty(r, s) = ty0(r, s);
ta(r, g) = ta0(r, g);
tm(r, g) = tm0(r, g);
tk(r, s) = tk0(r, s);
tfica(r, h) = tfica0(r, h);
tl(r, h) = tl0(r, h);


sets y_(r, s) 	Sectors and regions with positive production,
	x_(r, g) 	Disposition by region,
	a_(r, g) 	Absorption by region,
	pn_(g)  	National market,
	pd_(r, g)  	Local markets;

y_(r, s) = yes$(sum(g, ys0(r, s, g))>0);
x_(r, g) = yes$round(s0(r, g),6);
a_(r, g) = yes$(a0(r, g) + rx0(r, g));
pn_(g) = yes$(sum(r, xn0(r, g) + nd0(r, g) + sum(m, md0(r, m, g))));
pd_(r, g) = yes$(xd0(r, g) + dd0(r, g) + sum(m, dm0(r, g, m)));

* -----------------------------------------------------------------------------
* Static MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:static_hh_mge

$sectors:
	Y(r,s)$y_(r,s)  !	Production
	X(r,g)$x_(r,g)  !	Disposition
	A(r,g)$a_(r,g)  !	Absorption
	LS(r,h)			!	Labor supply
	KS			    !	Aggregate capital stock
	C(r,h)			!	Household consumption
	MS(r,m)         !	Margin supply

$commodities:
		PA(r,g)$a0(r,g)     !       Regional market (input)
		PY(r,g)$s0(r,g)     !       Regional market (output)
		PD(r,g)$pd_(r,g)    !       Local market price
		PN(g)$pn_(g)        !       National market price for goods
		PL(r)               !       Regional wage rate
		PK			        !     	Aggregate return to capital
		PM(r,m)             !       Margin price
		PC(r,h)		        !       Consumer price index
		PFX                 !       Foreign exchange
		RK(r,s)$kd0(r,s)	!       Sectoral rental rate
		RKS			        !		Capital stock
		PLS(r,h)	        !		Leisure price
		
		
		

$consumer:
	RA(r,h)			!	Representative agent
	NYSE			!	Aggregate capital owner
	INVEST			!	Aggregate investor
	GOVT			!	Aggregate government

$auxiliary:
	SAVRATE		!	Domestic savings rate
	TRANS		!	Budget balance rationing variable
	SSK			!	Steady-state capital stock
	CPI			!	Consumer price index

$prod:Y(r,s)$y_(r,s)  s:0 va:1
	o:PY(r,g)	q:ys0(r,s,g)            a:GOVT t:ty(r,s)       p:(1-ty0(r,s))
	i:PA(r,g)       q:id0(r,g,s)
	i:PL(r)         q:ld0(r,s)     va:
	i:RK(r,s)       q:kd0(r,s)     va:	a:GOVT t:tk(r,s)       p:(1+tk0(r, s))

$report:
	v:KD(r,s)$kd0(r,s)	i:RK(r,s)	prod:Y(r,s)

$prod:X(r,g)$x_(r,g)  t:4
	o:PFX           q:(x0(r,g)-rx0(r,g))
	o:PN(g)         q:xn0(r,g)
	o:PD(r,g)       q:xd0(r,g)
	i:PY(r,g)       q:s0(r,g)

$prod:A(r,g)$a_(r,g)  s:0 dm:2  d(dm):4
	o:PA(r,g)       q:a0(r,g)               a:GOVT t:ta(r,g)       p:(1-ta0(r,g))
	o:PFX           q:rx0(r,g)
	i:PN(g)         q:nd0(r,g)      d:
	i:PD(r,g)       q:dd0(r,g)      d:
	i:PFX           q:m0(r,g)       dm:     a:GOVT t:tm(r,g)       p:(1+tm0(r,g))
	i:PM(r,m)       q:md0(r,m,g)
    
$report:
	v:MD(r,g)$m0(r,g)	i:PFX	prod:A(r,g)

$prod:MS(r,m)
	o:PM(r,m)       q:(sum(g, md0(r,m,g)))
	i:PN(g)        q:nm0(r,g,m)
	i:PD(r,g)      q:dm0(r,g,m)

$prod:C(r,h)	  s:1
	o:PC(r,h)       q:(sum(g, cd0_h(r,g,h)))
	i:PA(r,g)       q:cd0_h(r,g,h)

$prod:LS(r,h)
	o:PL(q)		q:le0(r,q,h)	a:GOVT	t:(tl(r,h)+tfica(r,h))	p:(1-tl0(r,h)-tfica0(r,h))
	i:PLS(r,h)	q:ls0(r,h)


$prod:KS	t:etaK
	o:RK(r,s)	q:kd0(r,s)
	i:RKS		q:(sum((r,s),kd0(r,s)))

$demand:RA(r,h)	  s:esubL(r,h)
	d:PC(r,h)   q:(sum(g, cd0_h(r,g,h)))
	d:PLS(r,h)	q:lsr0(r,h)
	e:PLS(r,h)	q:(ls0(r,h)+lsr0(r,h))
	e:PFX		q:(sum(trn, hhtrn0(r,h,trn)))	r:TRANS
	e:PLS(r,h)	q:((tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))
	e:PK		q:ke0(r,h)
	e:PFX		q:(-sav0(r,h))	r:SAVRATE

$report:
	v:W(r,h)	w:RA(r,h)

$demand:NYSE
	d:PK
	e:PY(r,g)	q:yh0(r,g)
	e:RKS		q:(sum((r,s),kd0(r,s)))	r:SSK

$demand:INVEST  s:0
	d:PA(r,g)	q:i0(r,g)
	e:PFX		q:(sum((r,h), sav0(r,h)))  r:SAVRATE

$demand:GOVT
	d:PA(r,g)	q:g0(r,g)
	e:PFX           q:(-sum((r,trn,h), hhtrn0(r,h, trn)))   r:TRANS	
	e:PFX           q:govdef0
	e:PLS(r,h)	q:(-(tl(r,h) - tl_avg0(r,h))*sum(q,le0(r,q,h)))
	
$constraint:SSK
	sum((r,g),i0(r,g)*PA(r,g)) =e= sum((r,g),i0(r,g))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(r,g)*i0(r,g))*SSK;

$constraint:TRANS
	GOVT =e= sum((r,g),PA(r,g)*g0(r,g));

$constraint:CPI
	CPI =e= sum((r,g,h), PC(r,h)*cd0_h(r,g,h))/sum((r,g,h),cd0_h(r,g,h));

$offtext
$sysinclude mpsgeset static_hh_mge -mt=1

* Set the numeraire:

PFX.FX = 1;

* Starting values for other auxiliary variables:

CPI.L = 1;
TRANS.L = 1;
SAVRATE.L = 1;
SSK.L = 1;

static_hh_mge.workspace = 10000;
static_hh_mge.iterlim=0;
$include %gams.scrdir%static_hh_mge.gen
solve static_hh_mge using mcp;
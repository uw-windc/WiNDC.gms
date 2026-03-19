$title Household accounting model

$OnText
Household accounting model to verify benchmark consistency of MGE model. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `year` - Year of the data to load. Default is `2024`. Only year available is 2024.

$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "household_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/windc_load_data.gms"


parameter
    etaK "Capital elasticity of output" /4/;

parameter
    ta(g, r)	Counterfactual consumption taxes,
    ty(s, r)	Counterfactual production taxes
    tm(g, r)	Counterfactual import taxes,
    tk(s, r)	Counterfactual capital taxes,
    tfica(h, r)	Counterfactual FICA labor taxes,
    tl(h, r)	Counterfactual marginal labor taxes;

ty(s, r) = ty0(s, r);
ta(g, r) = ta0(g, r);
tm(g, r) = tm0(g, r);
tk(s, r) = tk0(s, r);
tfica(h, r) = tfica0(h, r);
tl(h, r) = tl0(h, r);


sets y_(s, r) 	Sectors and regions with positive production,
	x_(g, r) 	Disposition by region,
	a_(g, r) 	Absorption by region,
	pn_(g)  	National market,
	pd_(g, r)  	Local markets;

y_(s, r) = yes$(sum(g, ys0(g, s, r))>0);
x_(g, r) = yes$round(s0(g, r),6);
a_(g, r) = yes$(a0(g, r) + rx0(g, r));
pn_(g) = yes$(sum(r, xn0(g, r) + nd0(g, r) + sum(m, md0(g, m, r))));
pd_(g, r) = yes$(xd0(g, r) + dd0(g, r) + sum(m, dm0(g, m, r)));


* -----------------------------------------------------------------------------
* Static MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:static_hh_mge

$sectors:
	Y(s,r)$y_(s,r)  !	Production
	X(g,r)$x_(g,r)  !	Disposition
	A(g,r)$a_(g,r)  !	Absorption
	LS(h,r)			!	Labor supply
	KS			    !	Aggregate capital stock
	C(h,r)			!	Household consumption
	MS(m,r)         !	Margin supply

$commodities:
		PA(g,r)$a0(g,r)     !       Regional market (input)
		PY(g,r)$s0(g,r)     !       Regional market (output)
		PD(g,r)$pd_(g,r)    !       Local market price
		PN(g)$pn_(g)        !       National market price for goods
		PL(r)               !       Regional wage rate
		PK			        !     	Aggregate return to capital
		PM(m,r)             !       Margin price
		PC(h,r)		        !       Consumer price index
		PFX                 !       Foreign exchange
		RK(s,r)$kd0(s,r)	!       Sectoral rental rate
		RKS			        !		Capital stock
		PLS(h,r)	        !		Leisure price
	
$consumer:
	RA(h,r)			!	Representative agent
	NYSE			!	Aggregate capital owner
	INVEST			!	Aggregate investor
	GOVT			!	Aggregate government

$auxiliary:
	SAVRATE		!	Domestic savings rate
	TRANS		!	Budget balance rationing variable
	SSK			!	Steady-state capital stock
	CPI			!	Consumer price index

$prod:Y(s,r)$y_(s,r)  s:0 va:1
	o:PY(g,r)	q:ys0(g,s,r)            a:GOVT t:ty(s,r)       p:(1-ty0(s,r))
	i:PA(g,r)       q:id0(g,s,r)
	i:PL(r)         q:ld0(s,r)     va:
	i:RK(s,r)       q:kd0(s,r)     va:	a:GOVT t:tk(s,r)       p:(1+tk0(s, r))

$report:
	v:KD(s,r)$kd0(s,r)	i:RK(s,r)	prod:Y(s,r)

$prod:X(g,r)$x_(g,r)  t:4
	o:PFX           q:(x0(g,r)-rx0(g,r))
	o:PN(g)         q:xn0(g,r)
	o:PD(g,r)       q:xd0(g,r)
	i:PY(g,r)       q:s0(g,r)

$prod:A(g,r)$a_(g,r)  s:0 dm:2  d(dm):4
	o:PA(g,r)       q:a0(g,r)               a:GOVT t:ta(g,r)       p:(1-ta0(g,r))
	o:PFX           q:rx0(g,r)
	i:PN(g)         q:nd0(g,r)      d:
	i:PD(g,r)       q:dd0(g,r)      d:
	i:PFX           q:m0(g,r)       dm:     a:GOVT t:tm(g,r)       p:(1+tm0(g,r))
	i:PM(m,r)       q:md0(g,m,r)

$report:
	v:MD(g,r)$m0(g,r)	i:PFX	prod:A(g,r)

$prod:MS(m,r)
	o:PM(m,r)       q:(sum(g, md0(g,m,r)))
	i:PN(g)        q:nm0(g,m,r)
	i:PD(g,r)      q:dm0(g,m,r)

$prod:C(h,r)	  s:1
	o:PC(h,r)       q:(sum(g, cd0_h(g,h,r)))
	i:PA(g,r)       q:cd0_h(g,h,r)

$prod:LS(h,r)
	o:PL(q)		q:le0(q,h,r)	a:GOVT	t:(tl(h,r)+tfica(h,r))	p:(1-tl0(h,r)-tfica0(h,r))
	i:PLS(h,r)	q:ls0(h,r)

$prod:KS	t:etaK
	o:RK(s,r)	q:kd0(s,r)
	i:RKS		q:(sum((s,r),kd0(s,r)))

$demand:RA(h,r)	  s:esubL(h,r)
	d:PC(h,r)   q:(sum(g, cd0_h(g,h,r)))
	d:PLS(h,r)	q:lsr0(h,r)
	e:PLS(h,r)	q:(ls0(h,r)+lsr0(h,r))
	e:PFX		q:(sum(trn, hhtrn0(trn,h,r)))	r:TRANS
	e:PLS(h,r)	q:((tl(h,r) - tl_avg0(h,r))*sum(q,le0(q,h,r)))
	e:PK		q:ke0(h,r)
	e:PFX		q:(-sav0(h,r))	r:SAVRATE

$report:
	v:W(h,r)	w:RA(h,r)

$demand:NYSE
	d:PK
	e:PY(g,r)	q:yh0(g,r)
	e:RKS		q:(sum((s,r),kd0(s,r)))	r:SSK

$demand:INVEST  s:0
	d:PA(g,r)	q:i0(g,r)
	e:PFX		q:(sum((h,r), sav0(h,r)))  r:SAVRATE

$demand:GOVT
	d:PA(g,r)	q:g0(g,r)
	e:PFX           q:(-sum((r,trn,h), hhtrn0(trn,h,r)))   r:TRANS	
	e:PFX           q:govdef0
	e:PLS(h,r)	q:(-(tl(h,r) - tl_avg0(h,r))*sum(q,le0(q,h,r)))
	
$constraint:SSK
	sum((r,g),i0(g,r)*PA(g,r)) =e= sum((r,g),i0(g,r))*RKS;

$constraint:SAVRATE
	INVEST =e= sum((r,g), PA(g,r)*i0(g,r))*SSK;

$constraint:TRANS
	GOVT =e= sum((r,g),PA(g,r)*g0(g,r));

$constraint:CPI
	CPI =e= sum((r,g,h), PC(h,r)*cd0_h(g,h,r))/sum((r,g,h),cd0_h(g,h,r));

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
$title National accounting model to verify benchmark consistency of MGE model


*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------


$if not set file_path $set file_path "%system.fp%/../data/national_data.gdx"

*---------------
* End of Options 
* --------------


$include load_data.gms



    
*parameter
*    ty(yr, j)	Policy output tax rate,
*    ta(yr, i)	Policy tax net subsidy rate on intermediate demand,
*    tm(yr, i)	Policy import tariff;
*
*
*
*ta(yr,i) = ta_0(yr,i);
*ty(yr,j) = ty_0(yr,j);
*tm(yr,i) = tm_0(yr,i);




parameter
    y0(i)	Gross output,
    ys0(j,i)	Sectoral supply,
    ty0(j)	Reference output tax rate,
    fs0(i)	Household supply,
    id0(i,j)	Intermediate demand,
    fd0(i,fd)	Final demand,
    va0(va,j)	Vaue added,
    ts0(ts,i)	Taxes and subsidies,
    m0(i)	Imports,
    x0(i)	Exports of goods and services,
    mrg0(i)	Trade margins,
    trn0(i)	Transportation costs,
    duty0(i)	Import duties,
    sbd0(i)	Subsidies on products,
    tax0(i)	Taxes on products,
    ms0(i,m)	Margin supply,
    md0(m,i)	Margin demand,
    s0(i)	Aggregate supply,
    d0(i)	Sales in the domestic market,
    a0(i)	Armington supply,
    bopdef	Balance of payments deficit,
    ta0(i)	Reference tax net subsidy rate on intermediate demand,
    tm0(i)	Reference import tariff,
    ty(j)	Policy output tax rate,
    ta(i)	Policy tax net subsidy rate on intermediate demand,
    tm(i)	Policy import tariff;
    

sets
    y_(j)	Sectors with positive production,
    a_(i)	Sectors with absorption,
    py_(i)	Goods with positive supply,
    xfd(fd) 	Exogenous components of final demand;

* ----------------------------------------------------------------------
* MGE accounting model
* ----------------------------------------------------------------------

$ontext
$model:single_year

$sectors:
	Y(j)$y_(j)	!	Sectoral production
	A(i)$a_(i)	!	Armington supply
	MS(m)		!	Margin supply

$commodities:
	PA(i)$a0(i)	!	Armington price
	PY(i)$py_(i)	!	Supply
	PVA(va)		!	Value-added
	PM(m)		!	Margin
	PFX		!	Foreign exchnage

$consumer:
	RA		!	Representative agent

$prod:Y(j)$y_(j)  s:0 va:1
	o:PY(i)		q:ys0(j,i)	a:RA  t:ty(j)
	i:PA(i)		q:id0(i,j)
	i:PVA(va)	q:va0(va,j)	va:

$prod:MS(m)
	o:PM(m)		q:(sum(i,ms0(i,m)))
	i:PY(i)		q:ms0(i,m)

$prod:A(i)$a_(i)  s:0  t:2 dm:2
	o:PA(i)		q:a0(i)			a:ra	t:ta(i)	p:(1-ta0(i))
	o:PFX		q:x0(i)
	i:PY(i)		q:y0(i)		dm:
	i:PFX		q:m0(i)		dm: 	a:ra	t:tm(i)	p:(1+tm0(i))
	i:PM(m)		q:md0(m,i)

$demand:RA  s:1
	d:PA(i)		q:fd0(i,"pce")
	e:PY(i)		q:fs0(i)
	e:PFX		q:bopdef
	e:PA(i)		q:(-sum(xfd,fd0(i,xfd)))
	e:PVA(va)	q:(sum(j,va0(va,j)))

$report:
	v:C(i)		d:PA(i)		demand:RA

$offtext
$SYSINCLUDE mpsgeset single_year -mt=1




set run(yr) Sampled years for benchmark consistency;

run(yr) = yes;

loop(run(yr), 



    y0(i) = y_0(yr,i);
	ys0(j,i) = ys_0(yr,j,i);
	ty0(j) = ty_0(yr,j);
	fs0(i) = fs_0(yr,i);
	id0(i,j) = id_0(yr,i,j);
	fd0(i,fd) = fd_0(yr,i,fd);
	va0(va,j) = va_0(yr,va,j);
	m0(i) = m_0(yr,i);
	x0(i) = x_0(yr,i);
	ms0(i,m) = ms_0(yr,i,m);
	md0(m,i) = md_0(yr,m,i);
	a0(i) = a_0(yr,i);
	ta0(i) = ta_0(yr,i);
	tm0(i) = tm_0(yr,i);
	ta(i) = ta0(i);
	ty(j) = ty0(j);
	tm(i) = tm0(i);
	bopdef = bopdef_0(yr);

	y_(j) = yes$sum(i,ys0(j,i));
	a_(i) = yes$a0(i);
	py_(i) = yes$sum(j,ys0(j,i));
	xfd(fd) = yes$(not sameas(fd,'pce'));

    Y.L(j) = 1;
    A.L(i) = 1;
    MS.L(m) = 1;
    PA.L(i) = 1;
    PY.L(i) = 1;
    PVA.L(va) = 1;
    PM.L(m) = 1;
    PFX.L = 1;
    RA.LO = 0; RA.UP = +INF;
    single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
    solve single_year using mcp;
    abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

);
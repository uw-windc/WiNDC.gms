

sets
    y_(yr,j)	Sectors with positive production,
    a_(yr,i)	Sectors with absorption,
    py_(yr,i)	Goods with positive supply,
    xfd(fd) 	Exogenous components of final demand;


y_(yr,j) = yes$sum(i,ys_0(yr,j,i));
a_(yr,i) = yes$a_0(yr,i);
py_(yr,i) = yes$sum(j,ys_0(yr,j,i));
xfd(fd) = yes$(not sameas(fd,'pce'));

$ontext
$model:accounting

$sectors:
	Y(yr,j)$y_(yr,j)	!	Sectoral production
	A(yr,i)$a_(yr,i)	!	Armington supply
	MS(yr,m)		!	Margin supply

$commodities:
	PA(yr,i)$a_0(yr,i)	!	Armington price
	PY(yr,i)$py_(yr,i)	!	Supply
	PVA(yr,va)		!	Value-added
	PM(yr,m)		!	Margin
	PFX(yr)		!	Foreign exchnage

$consumer:
	RA(yr)		!	Representative agent

$prod:Y(yr,j)$y_(yr,j)  s:0 va:1
	o:PY(yr,i)		q:ys_0(yr,j,i)	a:RA(yr)  t:ty(yr,j)
	i:PA(yr,i)		q:id_0(yr,i,j)
	i:PVA(yr,va)	q:va_0(yr,va,j)	va:

$prod:MS(yr,m)
	o:PM(yr,m)		q:(sum(i,ms_0(yr,i,m)))
	i:PY(yr,i)		q:ms_0(yr,i,m)

$prod:A(yr,i)$a_(yr,i)  s:0  t:2 dm:2
	o:PA(yr,i)		q:a_0(yr,i)			a:ra(yr)	t:ta(yr,i)	p:(1-ta_0(yr,i))
	o:PFX(yr)		q:x_0(yr,i)
	i:PY(yr,i)		q:y_0(yr,i)		dm:
	i:PFX(yr)		q:m_0(yr,i)		dm: 	a:ra(yr)	t:tm(yr,i)	p:(1+tm_0(yr,i))
	i:PM(yr,m)		q:md_0(yr,m,i)

$demand:RA(yr)  s:1
	d:PA(yr,i)		q:fd_0(yr,i,"pce")
	e:PY(yr,i)		q:fs_0(yr,i)
	e:PFX(yr)		q:bopdef_0(yr)
	e:PA(yr,i)		q:(-sum(xfd,fd_0(yr,i,xfd)))
	e:PVA(yr,va)	q:(sum(j,va_0(yr,va,j)))

$report:
	v:C(yr,i)		d:PA(yr,i)		demand:RA(yr)

$offtext
$SYSINCLUDE mpsgeset accounting -mt=1
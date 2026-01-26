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


$if not set file_path $set file_path "%system.fp%/../data/national.gdx"


$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/legacy_windc_load_data.gms"

sets
    y_(j)     Sectors with positive production,
    a_(i)     Sectors with absorption,
    py_(i)    Goods with positive supply,
    xfd(fd) 	Exogenous components of final demand;

y_(j) = yes$sum(i, ys_0("2024", j, i));
a_(i) = yes$a_0("2024", i);
py_(i) = yes$sum(j, ys_0("2024", j, i));
xfd(fd) = yes$(not sameas(fd,'pce'));

parameters
    ty(yr, j)     Policy output tax rate,
    ta(yr, i)     Policy tax net subsidy rate on intermediate demand,
    tm(yr, i)     Policy import tariff;

ty(yr, j) = ty_0(yr, j);
ta(yr, i) = ta_0(yr, i);
tm(yr, i) = tm_0(yr, i);

$ontext
$model:single_year

$sectors:
    Y(j)$y_(j)      ! Sectoral production
    A(i)$a_(i)      ! Armington supply
    MS(m)           ! Margin supply

$commodities:
    PA(i)$a_(i)     ! Armington price
    PY(i)$py_(i)    ! Supply
    PVA(va)         ! Value added
    PM(m)           ! Margin
    PFX             ! Foreign exchnage

$consumer:
    RA              ! Representative agent

$prod:Y(j)$y_(j)  s:0 va:1
    o:PY(i)    q: ys_0("2024", j, i)    a:RA    t:ty("2024", j)
    i:PA(i)    q: id_0("2024", i, j)
    i:PVA(va)  q: va_0("2024", va, j)   va:
    
$prod:MS(m)
    o:PM(m)   q: (sum(i, ms_0("2024", i, m)))
    i:PY(i)   q: ms_0("2024", i, m)

$prod:A(i)$a_(i)  s:0  t:2 dm:2
    o:PA(i)   q: a_0("2024", i)          a:ra    t:ta("2024", i)   p:(1-ta_0("2024", i))
    o:PFX     q: x_0("2024", i)
    i:PY(i)   q: y_0("2024", i)     dm:
    i:PFX     q: m_0("2024", i)     dm:  a:ra    t:tm("2024", i)   p:(1+tm_0("2024", i))
    i:PM(m)   q: md_0("2024", m, i)  

$demand:RA  s:1
    d:PA(i)     q: fd_0("2024", i, "pce")
    e:PY(i)     q: fs_0("2024", i)
    e:PFX       q: bopdef_0("2024")
    e:PA(i)     q: (-sum(xfd, fd_0("2024", i, xfd)))
    e:PVA(va)   q: (sum(j, va_0("2024", va, j)))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1


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

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


$include "%system.fp%/../load/windc_load_data.gms"

sets
    y_(s)     Sectors with positive production,
    a_(g)     Sectors with absorption,
    py_(g)    Goods with positive supply;

y_(s) = yes$sum(g, ys0(g, s, "2024"));
a_(g) = yes$a0(g, "2024");
py_(g) = yes$sum(s, ys0(g, s, "2024"));


parameters
    ty(s, yr)     Policy output tax rate,
    ta(g, yr)     Policy tax net subsidy rate on intermediate demand,
    tm(g, yr)     Policy import tariff;

ty(s, yr) = ty0(s, yr);
ta(g, yr) = ta0(g, yr);
tm(g, yr) = tm0(g, yr);


$ontext
$model:single_year

$sectors:
    Y(s)$y_(s)      ! Sectoral production
    A(g)$a_(g)      ! Armington supply
    MS(m)           ! Margin supply

$commodities:
    PA(g)$a_(g)     ! Armington price
    PY(g)$py_(g)    ! Supply
    PVA(va)         ! Value added
    PM(m)           ! Margin
    PFX             ! Foreign exchnage

$consumer:
    RA              ! Representative agent

$prod:Y(s)$y_(s)  s:0 va:1
    o:PY(g)    q: ys0(g, s,  "2024")    a:RA    t:ty(s, "2024")
    i:PA(g)    q: id0(g, s,  "2024")
    i:PVA(va)  q: va0(va, s, "2024")
    
$prod:MS(m)
    o:PM(m)   q: (sum(g, ms0(g, m, "2024")))
    i:PY(g)   q: ms0(g, m, "2024")

$prod:A(g)$a_(g)  s:0  t:2 dm:2
    o:PA(g)   q: a0(g, "2024")          a:ra    t:ta(g, "2024")   p:(1-ta0(g, "2024"))
    o:PFX     q: x0(g, "2024")
    i:PY(g)   q: y0(g, "2024")     dm:
    i:PFX     q: m0(g, "2024")     dm:  a:ra    t:tm(g, "2024")   p:(1+tm0(g, "2024"))
    i:PM(m)   q: md0(g, m, "2024")  

$demand:RA  s:1
    d:PA(g)     q: pce0(g, "2024")
    e:PY(g)     q: fs0(g, "2024")
    e:PFX       q: bopdef0("2024")
    e:PA(g)     q: (-sum(xfd, fd0(g, xfd, "2024")))
    e:PVA(va)   q: (sum(s, va0(va, s, "2024")))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1


Y.L(s) = 1;
A.L(g) = 1;
MS.L(m) = 1;
PA.L(g) = 1;
PY.L(g) = 1;
PVA.L(va) = 1;
PM.L(m) = 1;
PFX.L = 1;
RA.LO = 0; RA.UP = +INF;


single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
    solve single_year using mcp;
    abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

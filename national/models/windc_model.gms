$title National accounting model to verify benchmark consistency of MGE model


$OnText
National accounting model to verify benchmark consistency of MGE model. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `year` - Year of the data to load. Default is `2024`.

$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "national_legacy_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/windc_load_data.gms"

sets
    y_(s)     Sectors with positive production,
    a_(g)     Sectors with absorption,
    py_(g)    Goods with positive supply;

y_(s) = yes$sum(g, ys0(g, s, "%year%"));
a_(g) = yes$a0(g, "%year%");
py_(g) = yes$sum(s, ys0(g, s, "%year%"));


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
    o:PY(g)    q: ys0(g, s,  "%year%")    a:RA    t:ty(s, "%year%")
    i:PA(g)    q: id0(g, s,  "%year%")
    i:PVA(va)  q: va0(va, s, "%year%")   va:
    
$prod:MS(m)
    o:PM(m)   q: (sum(g, ms0(g, m, "%year%")))
    i:PY(g)   q: ms0(g, m, "%year%")

$prod:A(g)$a_(g)  s:0  t:2 dm:2
    o:PA(g)   q: a0(g, "%year%")          a:ra    t:ta(g, "%year%")   p:(1-ta0(g, "%year%"))
    o:PFX     q: x0(g, "%year%")
    i:PY(g)   q: y0(g, "%year%")     dm:
    i:PFX     q: m0(g, "%year%")     dm:  a:ra    t:tm(g, "%year%")   p:(1+tm0(g, "%year%"))
    i:PM(m)   q: md0(g, m, "%year%")  

$demand:RA  s:1
    d:PA(g)     q: pce0(g, "%year%")
    e:PY(g)     q: fs0(g, "%year%")
    e:PFX       q: bopdef0("%year%")
    e:PA(g)     q: (-sum(xfd, fd0(g, xfd, "%year%")))
    e:PVA(va)   q: (sum(s, va0(va, s, "%year%")))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1


single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

$title Regional accounting model

$OnText
Regional accounting model to verify benchmark consistency of MGE model. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_legacy_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `year` - Year of the data to load. Default is `2024`. Only year available is 2024.

$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "regional_legacy_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/legacy_windc_load_data.gms"

sets
    y_(r,s)     sectors with positive production,
    a_(r,g)     sectors with absorption,
    py_(r,g)    Goods with positive supply;

y_(r,s) = yes$sum(g, ys0("%year%",r,s,g));
a_(r,g) = yes$a0("%year%", r, g);
py_(r,g) = yes$sum(s, ys0("%year%",r,s,g));


parameters
    ty(yr,r,s)     Policy output tax rate,
    ta(yr,r,g)     Policy tax net subsidy rate on intermediate demand,
    tm(yr,r,g)     Policy import tariff;

ty(yr,r,s) = ty0(yr,r,s);
ta(yr,r,g) = ta0(yr,r,g);
tm(yr,r,g) = tm0(yr,r,g);


* -----------------------------------------------------------------------------
* Static MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:single_year

$sectors:
    Y(r,s)$y_(r,s)            ! storal production
    X(r,g)$s0("%year%",r,g)   ! Disposition by region
    A(r,g)$a_(r,g)            ! Armington supply
    C(r)                      ! Aggregate Final Demand
    MS(r,m)                   ! Margin supply

$commodities:
    PA(r,g)$a_(r,g)           ! Armington price
    PY(r,g)$py_(r,g)          ! Supply
    PD(r,g)$xd0("%year%",r,g) ! Local market price
    PN(g)                     ! National market price
    PL(r)                     ! Labor Value Added
    PK(r,s)$kd0("%year%",r,s) ! Capital Value Added
    PM(r, m)                  ! Margin
    PC(r)                     ! Consumer price index
    PFX                       ! Foreign exchnage

$consumer:
    RA(r)  !   Representative agent

$prod:Y(r,s)$y_(r,s)  s:0 va:1
    o:PY(r, g)  q:ys0("%year%",r,s,g)       a:RA(r)    t:ty("%year%",r,s) p:(1-ty0("%year%",r,s))
    i:PA(r, g)  q:id0("%year%",r,g,s)
    i:PL(r)     q:ld0("%year%",r,s)    va:
    i:PK(r,s)   q:kd0("%year%",r,s)    va:

$prod:X(r,g)$s0("%year%",r,g)  t:4
	o:PFX        q:(x0("%year%",r,g)-rx0("%year%",r,g))
	o:PN(g)	     q:xn0("%year%",r,g)
	o:PD(r,g)    q:xd0("%year%",r,g)
	i:PY(r,g)    q:s0("%year%",r,g)

$prod:A(r,g)$a_(r,g)  s:0  t:2 dm:2 d(dm):4
    o:PA(r,g)   q:a0("%year%",r,g)             a:RA(r)    t:ta("%year%",r,g)   p:(1-ta0("%year%",r,g))
    o:PFX       q:rx0("%year%",r,g)
    i:PN(g)     q:nd0("%year%",r,g)       d:
    i:PD(r,g)   q:dd0("%year%",r,g)       d:
    i:PFX       q:m0("%year%",r,g)        dm:  a:RA(r)    t:tm("%year%",r,g)   p:(1+tm0("%year%",r,g))
    i:PM(r,m)   q:md0("%year%", r, m, g) 

$prod:MS(r,m)
    o:PM(r,m)   q:(sum(g, md0("%year%", r, m, g)))
    i:PN(g)     q:nm0("%year%", r, g, m)
    i:PD(r,g)   q:dm0("%year%", r, g, m)

$prod:C(r) s:1
    o:PC(r)     q:(sum(g, cd0("%year%",r,g)))
    i:PA(r, g)  q:cd0("%year%",r,g)

$demand:RA(r)  s:1
    d:PC(r)     q:(sum(g, cd0("%year%",r,g)))
    e:PY(r, g)  q:yh0("%year%",r,g)
    e:PFX       q:(bopdef0("%year%",r) + hhadj0("%year%",r))
    e:PA(r, g)  q:(-g0("%year%",r,g) - i0("%year%",r,g))
    e:PL(r)     q:(sum(s, ld0("%year%",r,s)))
    e:PK(r,s)   q:kd0("%year%",r,s)
$offtext
$sysinclude mpsgeset single_year -mt=1

* Set the numeraire:


single_year.workspace = 10000;
single_year.iterlim=0;
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
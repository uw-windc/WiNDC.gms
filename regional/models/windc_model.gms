$title Regional accounting model

$OnText
Regional accounting model to verify benchmark consistency of MGE model. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `year` - Year of the data to load. Default is `2024`.

$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "regional_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/windc_load_data.gms"


sets
    y_(s, r)     sectors with positive production,
    a_(g, r)     sectors with absorption,
    py_(g, r)    Goods with positive supply;

y_(s, r) = yes$sum(g, ys0(g, s, r, "%year%"));
a_(g, r) = yes$a0(g, r, "%year%");
py_(g, r) = yes$sum(s, ys0(g, s, r, "%year%"));


parameters
    ty(s, r, yr)     Policy output tax rate,
    ta(g, r, yr)     Policy tax net subsidy rate on intermediate demand,
    tm(g, r, yr)     Policy import tariff;

ty(s, r, yr) = ty0(s, r, yr);
ta(g, r, yr) = ta0(g, r, yr);
tm(g, r, yr) = tm0(g, r, yr);


* -----------------------------------------------------------------------------
* Static MGE model
* -----------------------------------------------------------------------------

$ontext 
$model:single_year

$sectors:
    Y(s, r)$y_(s, r)      ! storal production
    X(g, r)$s0(g, r, "%year%")     ! Disposition by region
    A(g, r)$a_(g, r)      ! Armington supply
    C(r)                          ! Aggregate Final Demand
    MS(m, r)                    ! Margin supply

$commodities:
    PA(g, r)$a_(g, r)       ! Armington price
    PY(g, r)$py_(g, r)      ! Supply
    PD(g, r)$xd0(g, r, "%year%")           ! Local market price
    PN(g)                             ! National market price
    P_Labor(r)                      ! Labor Value Added
    P_Capital(s, r)$kd0(s, r, "%year%")           ! Capital Value Added
    PM(m, r)                      ! Margin
    PC(r)                           ! Consumer price index
    PFX                                 ! Foreign exchnage

$consumer:
    RA(r)  !   Representative agent

$prod:Y(s, r)$y_(s, r)  s:0 va:1
    o:PY(g, r)        q:ys0(g, s, r, "%year%")    a:RA(r)    t:ty(s, r, "%year%") p:(1-ty0(s, r, "%year%"))
    i:PA(g, r)        q:id0(g, s, r, "%year%")
    i:P_Labor(r)        q:ld0(s, r, "%year%")             va:
    i:P_Capital(s, r) q:kd0(s, r, "%year%")           va:

$prod:X(g, r)$s0(g, r, "%year%")  t:4
	o:PFX               q:(x0(g, r, "%year%")-rx0(g, r, "%year%"))
	o:PN(g)	        q:xn0(g, r, "%year%")
	o:PD(g, r)    q:xd0(g, r, "%year%")
	i:PY(g, r)    q:s0(g, r, "%year%")

$prod:A(g, r)$a_(g, r)  s:0  t:2 dm:2 d(dm):4
    o:PA(g, r)    q:a0(g, r, "%year%")            a:RA(r)    t:ta(g, r, "%year%")   p:(1-ta0(g, r, "%year%"))
    o:PFX               q:rx0(g, r, "%year%")
    i:PN(g)           q:nd0(g, r, "%year%")  d:
    i:PD(g, r)    q:dd0(g, r, "%year%")     d:
    i:PFX               q:m0(g, r, "%year%")           dm:  a:RA(r)    t:tm(g, r, "%year%")   p:(1+tm0(g, r, "%year%"))
    i:PM(m, r)    q:md0(g, m, r, "%year%") 

$prod:MS(m, r)
    o:PM(m, r)   q:(sum(g, md0(g, m, r, "%year%")))
    i:PN(g)          q:nm0(g, m, r, "%year%")
    i:PD(g, r)   q:dm0(g, m, r, "%year%")

$prod:C(r) s:1
    o:PC(r)         q:(sum(g, cd0(g, r, "%year%")))
    i:PA(g, r)    q:cd0(g, r, "%year%")

$demand:RA(r)  s:1
    d:PC(r)              q:(sum(g, cd0(g, r, "%year%")))
    e:PY(g, r)         q:yh0(g, r, "%year%")
    e:PFX                    q:(bopdef0(r, "%year%") + hhadj0(r, "%year%"))
    e:PA(g, r)         q:(-g0(g, r, "%year%") - i0(g, r, "%year%"))
    e:P_Labor(r)         q:(sum(s, ld0(s, r, "%year%")))
    e:P_Capital(s, r)  q:kd0(s, r, "%year%")
$offtext
$sysinclude mpsgeset single_year -mt=1

* Set the numeraire:


single_year.workspace = 10000;
single_year.iterlim=0;
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
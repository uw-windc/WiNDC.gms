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

$if not set year $set year 2024


*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/legacy_windc_load_data.gms"

sets
    y_(j)     Sectors with positive production,
    a_(i)     Sectors with absorption,
    py_(i)    Goods with positive supply,
    xfd(fd) 	Exogenous components of final demand;

y_(j) = yes$sum(i, ys_0("%year%", j, i));
a_(i) = yes$a_0("%year%", i);
py_(i) = yes$sum(j, ys_0("%year%", j, i));
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
    o:PY(i)    q: ys_0("%year%", j, i)    a:RA    t:ty("%year%", j)
    i:PA(i)    q: id_0("%year%", i, j)
    i:PVA(va)  q: va_0("%year%", va, j)   va:
    
$prod:MS(m)
    o:PM(m)   q: (sum(i, ms_0("%year%", i, m)))
    i:PY(i)   q: ms_0("%year%", i, m)

$prod:A(i)$a_(i)  s:0  t:2 dm:2
    o:PA(i)   q: a_0("%year%", i)          a:ra    t:ta("%year%", i)   p:(1-ta_0("%year%", i))
    o:PFX     q: x_0("%year%", i)
    i:PY(i)   q: y_0("%year%", i)     dm:
    i:PFX     q: m_0("%year%", i)     dm:  a:ra    t:tm("%year%", i)   p:(1+tm_0("%year%", i))
    i:PM(m)   q: md_0("%year%", m, i)  

$demand:RA  s:1
    d:PA(i)     q: fd_0("%year%", i, "pce")
    e:PY(i)     q: fs_0("%year%", i)
    e:PFX       q: bopdef_0("%year%")
    e:PA(i)     q: (-sum(xfd, fd_0("%year%", i, xfd)))
    e:PVA(va)   q: (sum(j, va_0("%year%", va, j)))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1


single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

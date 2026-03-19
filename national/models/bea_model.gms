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
$if not set data_file $set data_file "national_bea.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/bea_load_data.gms"

sets
    y_(sec)     Sectors with positive production,
    a_(com)     Sectors with absorption,
    py_(com)    Goods with positive supply;

y_(sec) = yes$sum(com, Intermediate_Supply(com, sec, "%year%"));
a_(com) = yes$Armington_Supply(com, "%year%");
py_(com) = yes$sum(sec, Intermediate_Supply(com, sec, "%year%"));


parameters
    ty(sec, yr)     Policy output tax rate,
    ta(com, yr)     Policy tax net subsidy rate on intermediate demand,
    tm(com, yr)     Policy import tariff;

ty(sec, yr) = Output_Tax_Rate(sec, yr);
ta(com, yr) = Tax_Rate(com, yr);
tm(com, yr) = Tariff_Rate(com, yr);


$ontext
$model:single_year

$sectors:
    Y(sec)$y_(sec)      ! Sectoral production
    A(com)$a_(com)      ! Armington supply
    MS(mar)             ! Margin supply

$commodities:
    PA(com)$a_(com)     ! Armington price
    PY(com)$py_(com)    ! Supply
    P_Labor             ! Labor Value Added
    P_Capital           ! Capital Value Added
    PM(mar)             ! Margin
    PFX                 ! Foreign exchnage

$consumer:
    RA  !   Representative agent

$prod:Y(sec)$y_(sec)  s:0 va:1
    o:PY(com)    q: Intermediate_Supply(com, sec, "%year%")    a:RA    t:ty(sec, "%year%")
    i:PA(com)    q: Intermediate_Demand(com, sec, "%year%")
    i:P_Labor    q: Labor_Demand(sec, "%year%")             va:
    i:P_Capital  q: Capital_Demand(sec, "%year%")           va:

$prod:MS(mar)
    o:PM(mar)   q: (sum(com, Margin_Supply(com, mar, "%year%")))
    i:PY(com)   q: Margin_Supply(com, mar, "%year%")

$prod:A(com)$a_(com)  s:0  t:2 dm:2
    o:PA(com)   q: Armington_Supply(com, "%year%")          a:ra    t:ta(com, "%year%")   p:(1-Tax_Rate(com, "%year%"))
    o:PFX       q: Export(com, "%year%")
    i:PY(com)   q: Gross_Output(com, "%year%")         dm:
    i:PFX       q: Import(com, "%year%")               dm:  a:ra    t:tm(com, "%year%")   p:(1+Tariff_Rate(com, "%year%"))
    i:PM(mar)   q: Margin_Demand(com, mar, "%year%") 

$demand:RA  s:1
    d:PA(com)   q: Personal_Consumption(com, "%year%")
    e:PY(com)   q: Household_Supply(com, "%year%")
    e:PFX       q: Balance_Payments("%year%")
    e:PA(com)   q: (-sum(gfd, Government_Final_Demand(com, gfd, "%year%")) - sum(ifd, Investment_Final_Demand(com, ifd, "%year%")))
    e:P_Labor   q: (sum(sec, Labor_Demand(sec, "%year%")))
    e:P_Capital q: (sum(sec, Capital_Demand(sec, "%year%")))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1



single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

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


$include "%system.fp%/../load/bea_load_data.gms"

sets
    y_(sec)     Sectors with positive production,
    a_(com)     Sectors with absorption,
    py_(com)    Goods with positive supply;

y_(sec) = yes$sum(com, Intermediate_Supply(com, sec, "2024"));
a_(com) = yes$Armington_Supply(com, "2024");
py_(com) = yes$sum(sec, Intermediate_Supply(com, sec, "2024"));


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
    o:PY(com)    q: Intermediate_Supply(com, sec, "2024")    a:RA    t:ty(sec, "2024")
    i:PA(com)    q: Intermediate_Demand(com, sec, "2024")
    i:P_Labor    q: Labor_Demand(sec, "2024")             va:
    i:P_Capital  q: Capital_Demand(sec, "2024")           va:

$prod:MS(mar)
    o:PM(mar)   q: (sum(com, Margin_Supply(com, mar, "2024")))
    i:PY(com)   q: Margin_Supply(com, mar, "2024")

$prod:A(com)$a_(com)  s:0  t:2 dm:2
    o:PA(com)   q: Armington_Supply(com, "2024")          a:ra    t:ta(com, "2024")   p:(1-Tax_Rate(com, "2024"))
    o:PFX       q: Export(com, "2024")
    i:PY(com)   q: Gross_Output(com, "2024")         dm:
    i:PFX       q: Import(com, "2024")               dm:  a:ra    t:tm(com, "2024")   p:(1+Tariff_Rate(com, "2024"))
    i:PM(mar)   q: Margin_Demand(com, mar, "2024") 

$demand:RA  s:1
    d:PA(com)   q: Personal_Consumption(com, "2024")
    e:PY(com)   q: Household_Supply(com, "2024")
    e:PFX       q: Balance_Payments("2024")
    e:PA(com)   q: (-sum(gfd, Government_Final_Demand(com, gfd, "2024")) - sum(ifd, Investment_Final_Demand(com, ifd, "2024")))
    e:P_Labor   q: (sum(sec, Labor_Demand(sec, "2024")))
    e:P_Capital q: (sum(sec, Capital_Demand(sec, "2024")))
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1


Y.L(sec) = 1;
A.L(com) = 1;
MS.L(mar) = 1;
PA.L(com) = 1;
PY.L(com) = 1;
P_Labor.L = 1;
P_Capital.L = 1;
PM.L(mar) = 1;
PFX.L = 1;
RA.LO = 0; RA.UP = +INF;


single_year.iterlim = 0;
$include %gams.scrdir%single_year.gen
    solve single_year using mcp;
    abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

$title Regional accounting model to verify benchmark consistency of MGE model


*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------


*$if not set file_path $set file_path "%system.fp%/../data/regional_bea.gdx"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------


$include "%system.fp%/../load/bea_load_data.gms"

sets
    y_(sec, state)     Sectors with positive production,
    a_(com, state)     Sectors with absorption,
    py_(com, state)    Goods with positive supply;

y_(sec, state) = yes$sum(com, Intermediate_Supply(com, sec, state, "2024"));
a_(com, state) = yes$Absorption(com, state, "2024");
py_(com, state) = yes$sum(sec, Intermediate_Supply(com, sec, state, "2024"));


parameters
    ty(sec, state, yr)     Policy output tax rate,
    ta(com, state, yr)     Policy tax net subsidy rate on intermediate demand,
    tm(com, state, yr)     Policy import tariff;

ty(sec, state, yr) = Output_Tax_Rate(sec, state, yr);
ta(com, state, yr) = Tax_Rate(com, state, yr);
tm(com, state, yr) = Tariff_Rate(com, state, yr);


$ontext
$model:single_year

$sectors:
    Y(sec, state)$y_(sec, state)      ! Sectoral production
    X(com, state)$Total_Supply(com, state, "2024")     ! Disposition by region
    A(com, state)$a_(com, state)      ! Armington supply
    C(state)                          ! Aggregate Final Demand
    MS(mar, state)                    ! Margin supply

$commodities:
    PA(com, state)$a_(com, state)       ! Armington price
    PY(com, state)$py_(com, state)      ! Supply
    PD(com, state)$Regional_Local_Supply(com, state, "2024")           ! Local market price
    PN(com)                             ! National market price
    P_Labor(state)                      ! Labor Value Added
    P_Capital(sec, state)$Capital_Demand(sec, state, "2024")           ! Capital Value Added
    PM(mar, state)                      ! Margin
    PC(state)                           ! Consumer price index
    PFX                                 ! Foreign exchnage

$consumer:
    RA(state)  !   Representative agent

$prod:Y(sec, state)$y_(sec, state)  s:0 va:1
    o:PY(com, state)        q:Intermediate_Supply(com, sec, state, "2024")    a:RA(state)    t:ty(sec, state, "2024") p:(1-Output_Tax_Rate(sec, state, "2024"))
    i:PA(com, state)        q:Intermediate_Demand(com, sec, state, "2024")
    i:P_Labor(state)        q:Labor_Demand(sec, state, "2024")             va:
    i:P_Capital(sec, state) q:Capital_Demand(sec, state, "2024")           va:

$prod:X(com, state)$Total_Supply(com, state, "2024")  t:4
	o:PFX               q:(Export(com, state, "2024")-Reexport(com, state, "2024"))
	o:PN(com)	        q:Regional_National_Supply(com, state, "2024")
	o:PD(com, state)    q:Regional_Local_Supply(com, state, "2024")
	i:PY(com, state)    q:Total_Supply(com, state, "2024")

$prod:A(com, state)$a_(com, state)  s:0  t:2 dm:2 d(dm):4
    o:PA(com, state)    q:Absorption(com, state, "2024")            a:RA(state)    t:ta(com, state, "2024")   p:(1-Tax_Rate(com, state, "2024"))
    o:PFX               q:Reexport(com, state, "2024")
    i:PN(com)           q:National_Demand(com, state, "2024")  d:
    i:PD(com, state)    q:Local_Demand(com, state, "2024")     d:
    i:PFX               q:Import(com, state, "2024")           dm:  a:RA(state)    t:tm(com, state, "2024")   p:(1+Tariff_Rate(com, state, "2024"))
    i:PM(mar, state)    q:Margin_Demand(com, mar, state, "2024") 

$prod:MS(mar, state)
    o:PM(mar, state)   q:(sum(com, Margin_Demand(com, mar, state, "2024")))
    i:PN(com)          q:National_Margin_Supply(com, mar, state, "2024")
    i:PD(com, state)   q:Local_Margin_Supply(com, mar, state, "2024")

$prod:C(state) s:1
    o:PC(state)         q:(sum(com, Personal_Consumption(com, state, "2024")))
    i:PA(com, state)    q:Personal_Consumption(com, state, "2024")

$demand:RA(state)  s:1
    d:PC(state)              q:(sum(com, Personal_Consumption(com, state, "2024")))
    e:PY(com, state)         q:Household_Supply(com, state, "2024")
    e:PFX                    q:(Balance_of_Payments(state, "2024") + Household_Adjustment(state, "2024"))
    e:PA(com, state)         q:(-Government_Final_Demand(com, state, "2024") - Investment_Final_Demand(com, state, "2024"))
    e:P_Labor(state)         q:(sum(sec, Labor_Demand(sec, state, "2024")))
    e:P_Capital(sec, state)  q:Capital_Demand(sec, state, "2024")
$offtext
$SYSINCLUDE mpsgeset single_year -mt=1



single_year.iterlim = 0;
single_year.workspace=1000
$include %gams.scrdir%single_year.gen
solve single_year using mcp;
abort$round(single_year.objval,3) "Benchmark replication fails for the MGE model.";

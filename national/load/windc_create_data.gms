$title Load the WiNDC national dataset

*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------

$if not set data_dir $set data_dir "%system.fp%/../data"

$if not set file_name $set file_name "national.gdx"
$set file_path "%data_dir%/%file_name%"

$if not set output $set output "national_windc.gdx"
$set output_path "%data_dir%/%output%"


$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" windc


parameter
    id0(g, s, yr)     "Intermediate Demand",
    pce0(g, yr)       "Personal consumption expenditure",
    fd0(g, xfd, yr)   "Final demand",
    x0(g, yr)         "Exports of goods and services",
    va0(va, s, yr)    "Value added",
    ms0(g, m, yr)	  "Margin supply",

    ys0(g, s, yr)     "Intermediate Supply",
    fs0(g, yr)        "Household supply",
    m0(g, yr)         "Imports",
    md0(g, m, yr)     "Margin demand",
    duty0(g, yr)      "Import duties",
    sbd0(g, yr)       "Subsidies on products",
    tax0(g, yr)       "Taxes on products",
    
    y0(g, yr)         "Gross output",
    a0(g, yr)         "Armington supply",
    bopdef0(yr)       "Balance of payments deficit",

    ta0(g, yr)        "Tax net subsidy rate on intermediate demand",
    tm0(g, yr)        "Import tariff",
    ty0(s, yr)        "Output tax rate";



id0(g, s, yr) = sum((map_com(com, g), map_sec(sec, s)), Intermediate_Demand(com, sec, yr));
pce0(g, yr) = sum(com$map_com(com, g), Personal_Consumption(com, yr));
fd0(g, xfd, yr) = sum((map_com(com, g), map_gfd(gfd, xfd)), Government_Final_Demand(com, gfd, yr)) + sum((map_com(com, g), map_ifd(ifd, xfd)), Investment_Final_Demand(com, ifd, yr));;


x0(g, yr) = sum(com$map_com(com, g), Export(com, yr));
va0("compen", s, yr) = sum(sec$map_sec(sec, s), Labor_Demand(sec, yr));
va0("surplus", s, yr) = sum(sec$map_sec(sec, s), Capital_Demand(sec, yr));
ms0(g, m, yr) = sum((map_com(com, g), map_mar(mar, m)), Margin_Supply(com, mar, yr));

ys0(g, s, yr) = sum((map_com(com, g), map_sec(sec, s)), Intermediate_Supply(com, sec, yr));
fs0(g, yr) = sum(com$map_com(com, g), Household_Supply(com, yr));
m0(g, yr) = sum(com$map_com(com, g), Import(com, yr));
md0(g, m, yr) = sum((map_com(com, g), map_mar(mar, m)), Margin_Demand(com, mar, yr));
duty0(g, yr) = sum(com$map_com(com, g), Duty(com, yr));
sbd0(g, yr) = sum(com$map_com(com, g), Subsidy(com, yr));
tax0(g, yr) = sum(com$map_com(com, g), Tax(com, yr));

y0(g, yr) = sum(com$map_com(com, g), Gross_Output(com, yr));
a0(g, yr) = sum(com$map_com(com, g), Armington_Supply(com, yr));
bopdef0(yr) = Balance_Payments(yr);

ta0(g, yr) = sum(com$map_com(com, g), Tax_Rate(com, yr));
tm0(g, yr) = sum(com$map_com(com, g), Tariff_Rate(com, yr));
ty0(s, yr) = sum(sec$map_sec(sec, s), Output_Tax_Rate(sec, yr));


parameter 
    zero_profit(s, yr),
    market_clearance(g, yr),
    margin_balance(m, yr);


zero_profit(s, yr) = sum(g, ys0(g, s, yr))*(1 - ty0(s, yr)) - sum(g, id0(g, s, yr)) - sum(va, va0(va, s, yr));
market_clearance(g, yr) = a0(g, yr)*(1-ta0(g, yr)) + x0(g, yr) - y0(g, yr) - m0(g, yr)*(1+tm0(g, yr)) - sum(m, md0(g, m, yr));
margin_balance(m, yr) = sum(g, ms0(g, m, yr)) - sum(g, md0(g, m, yr));


display zero_profit, market_clearance, margin_balance;

execute_unload '%output_path%' 
    g, s, m, yr, va, xfd,

    id0, pce0, fd0, x0, va0, ms0,

    ys0, fs0, m0, md0, duty0, sbd0, tax0,

    y0, a0, bopdef0,

    ta0, tm0, ty0;
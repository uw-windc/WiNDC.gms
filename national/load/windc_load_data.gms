$title Load the WiNDC national dataset

$OnText
    Currently hard coded to load from %data_dir%/national_windc.gdx
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"

*$if not set file_name $set file_name "national.gdx"
*$set file_path "%data_dir%/%file_name%"
*
*$if not set output $set output "national_windc.gdx"
*$set output_path "%data_dir%/%output%"

*---------------
* End of Options 
* --------------

set
    g     "Goods/Commodities", 
    s     "Sectors", 
    m     "Marginal Categories", 
    yr    "Years", 
    va    "Value added categories", 
    xfd   "Final demand categories"

$gdxin '%data_dir%/national_windc.gdx'
$load g, s, m, yr, va, xfd


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


$gdxin '%data_dir%/national_windc.gdx'
$loaddc id0, pce0, fd0, x0, va0, ms0, ys0, fs0, m0, md0, duty0, sbd0, tax0, y0, a0, bopdef0, ta0, tm0, ty0
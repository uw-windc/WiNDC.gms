$title Load the WiNDC national dataset

$OnText
Load the National dataset with sets and parameters that match classic 
WiNDC notation, but with domain orders that matches the WiNDCNational.jl 
dataset. 

For example, the Intermediate_Demand(com, sec) parameter from the BEA 
dataset becomes id0(g, s) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "national_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"


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

$gdxin '%data_path%'
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


$gdxin '%data_path%'
$loaddc id0, pce0, fd0, x0, va0, ms0, ys0, fs0, m0, md0, duty0, sbd0, tax0, y0, a0, bopdef0, ta0, tm0, ty0
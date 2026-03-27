$title Load the WiNDC Regional dataset

$OnText
Load the Regional dataset with sets and parameters that match classic 
WiNDC notation, but with domain orders that matches the WiNDCRegional.jl 
dataset. 

For example, the Intermediate_Demand(com, sec, state) parameter from the BEA 
dataset becomes id0(g, s, r) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "regional_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"


*---------------
* End of Options
* --------------

set
    g       "Commodities", 
    s       "Sectors",
    m       "Margins (trade or transport)", 
    r       "Regions",
    yr      "Years";

$gdxin '%data_path%'
$load g, s, m, r, yr


parameters
    a0(g,r,yr)    "Absorption",
    bopdef0(r,yr) "Balance_of_Payments",
    cd0(g,r,yr)   "Personal_Consumption",
    dd0(g,r,yr)   "Local_Demand",
    dm0(g,m,r,yr) "Local_Margin_Supply",
    g0(g,r,yr)    "Government_Final_Demand",
    hhadj0(r,yr)  "Household_Adjustment",
    i0(g,r,yr)    "Investment_Final_Demand",
    id0(g,s,r,yr) "Intermediate_Demand",
    kd0(s,r,yr)   "Capital_Demand",
    ld0(s,r,yr)   "Labor_Demand",
    m0(g,r,yr)    "Import",
    md0(g,m,r,yr) "Margin_Demand",
    nd0(g,r,yr)   "National_Demand",
    nm0(g,m,r,yr) "National_Margin_Supply",
    rx0(g,r,yr)   "Reexport",
    s0(g,r,yr)    "Total_Supply",
    ta0(g,r,yr)   "Tax_Rate",
    tm0(g,r,yr)   "Tariff_Rate",
    ty0(s,r,yr)   "Output_Tax_Rate",
    x0(g,r,yr)    "Export",
    xd0(g,r,yr)   "Regional_Local_Supply",
    xn0(g,r,yr)   "Regional_National_Supply",
    yh0(g,r,yr)   "Household_Supply",
    ys0(g,s,r,yr) "Intermediate_Supply";


$gdxin '%data_path%'
$loaddc a0, bopdef0, cd0, dd0, dm0, g0
$loaddc hhadj0, i0, id0, kd0, ld0, m0
$loaddc md0, nd0, nm0, rx0, s0, ta0, tm0 
$loaddc ty0, x0, xd0, xn0, yh0, ys0


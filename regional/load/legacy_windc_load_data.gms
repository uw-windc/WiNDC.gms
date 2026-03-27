$title Load the WiNDC Regional dataset

$OnText
Load the Regional dataset with sets and parameters that match classic 
WiNDC notation. This data matches that provided by windc_build.

For example, the Intermediate_Demand(com, sec, state) parameter from the BEA 
dataset becomes id0(r, g, s) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "regional_legacy_windc.gdx"

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
    a0(yr,r,g)    "Absorption",
    bopdef0(yr,r) "Balance_of_Payments",
    cd0(yr,r,g)   "Personal_Consumption",
    dd0(yr,r,g)   "Local_Demand",
    dm0(yr,r,g,m) "Local_Margin_Supply",
    g0(yr,r,g)    "Government_Final_Demand",
    hhadj0(yr,r)  "Household_Adjustment",
    i0(yr,r,g)    "Investment_Final_Demand",
    id0(yr,r,g,s) "Intermediate_Demand",
    kd0(yr,r,s)   "Capital_Demand",
    ld0(yr,r,s)   "Labor_Demand",
    m0(yr,r,g)    "Import",
    md0(yr,r,m,g) "Margin_Demand",
    nd0(yr,r,g)   "National_Demand",
    nm0(yr,r,g,m) "National_Margin_Supply",
    rx0(yr,r,g)   "Reexport",
    rx0(yr,r,g)   "Reexport",
    s0(yr,r,g)    "Total_Supply",
    ta0(yr,r,g)   "Tax_Rate",
    tm0(yr,r,g)   "Tariff_Rate",
    ty0(yr,r,s)   "Output_Tax_Rate",
    x0(yr,r,g)    "Export",
    xd0(yr,r,g)   "Regional_Local_Supply",
    xn0(yr,r,g)   "Regional_National_Supply",
    yh0(yr,r,g)   "Household_Supply",
    ys0(yr,r,s,g) "Intermediate_Supply";


$gdxin '%data_path%'
$loaddc a0, bopdef0, cd0, dd0, dm0, g0
$loaddc hhadj0, i0, id0, kd0, ld0, m0
$loaddc md0, nd0, nm0, rx0, s0, ta0, tm0 
$loaddc ty0, x0, xd0, xn0, yh0, ys0


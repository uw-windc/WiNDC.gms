$title Load the WiNDC National dataset

$OnText
Load the National Legacy dataset with sets and parameters that match classic 
WiNDC notation. This data matches that provided by windc_build.

For example, the Intermediate_Demand(com, sec) parameter from the BEA 
dataset becomes id0(g, s) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_legacy_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText


$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "national_legacy_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"


*---------------
* End of Options 
* --------------

set
    i     "Goods/Commodities", 
    j     "Sectors", 
    m     "Marginal Categories", 
    yr    "Years", 
    va    "Value added categories", 
    fd   "Final demand categories"

$gdxin '%data_path%'
$load i, j, m, yr, va, fd

parameter
    id_0(yr, i, j)  "Intermediate Demand",
    fd_0(yr,i,fd)	"Final demand",
    x_0(yr,i)		"Exports of goods and services",
    va_0(yr,va,j)	"Value added",
    ty_0(yr,j)		"Output tax rate",

    ys_0(yr,j,i)	"Sectoral supply",
    fs_0(yr,i)		"Household supply",
    m_0(yr,i)		"Imports",
    ms_0(yr,i,m)	"Margin supply",
    md_0(yr,m,i)	"Margin demand",
    ta_0(yr,i)		"Tax net subsidy rate on intermediate demand",
    tm_0(yr,i)		"Import tariff",

    y_0(yr,i)		"Gross output",
    a_0(yr,i)		"Armington supply",
    bopdef_0(yr)	"Balance of payments deficit";


$gdxin '%data_path%'
$loaddc id_0, fd_0, x_0, va_0, ms_0, ys_0, fs_0, m_0, md_0, y_0, a_0, bopdef_0, ta_0, tm_0, ty_0
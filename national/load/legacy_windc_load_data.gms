$title Load the WiNDC national dataset

$OnText
    Currently hard coded to load from %data_dir%/national_legacy_windc.gdx
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
    i     "Goods/Commodities", 
    j     "Sectors", 
    m     "Marginal Categories", 
    yr    "Years", 
    va    "Value added categories", 
    fd   "Final demand categories"

$gdxin '%data_dir%/national_legacy_windc.gdx'
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


$gdxin '%data_dir%/national_legacy_windc.gdx'
$loaddc id_0, fd_0, x_0, va_0, ms_0, ys_0, fs_0, m_0, md_0, y_0, a_0, bopdef_0, ta_0, tm_0, ty_0
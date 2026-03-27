$title Create the WiNDC Legacy National dataset

$OnText
Create the Legacy National dataset with sets and parameters that match classic 
WiNDC notation.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `output` - Name of the output GDX file. Default is `national_legacy_windc.gdx`.

Example:

    gams load_data --data_dir "path/to/data" --data_file "my_data.gdx"

$OffText


$if not set data_dir $set data_dir "%system.fp%../data"

$if not set data_file $set data_file "national_bea.gdx"
$set data_path "%data_dir%/%data_file%"

$if not set output $set output "national_legacy_windc.gdx"
$set output_path "%data_dir%/%output%"



$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" legacy_windc




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


id_0(yr, i, j) = sum((map_com(com, i), map_sec(sec, j)), Intermediate_Demand(com, sec, yr));

fd_0(yr, i, fd) = sum((map_com(com, i), map_gfd(gfd, fd)), Government_Final_Demand(com, gfd, yr)) + sum((map_com(com, i), map_ifd(ifd, fd)), Investment_Final_Demand(com, ifd, yr));;
fd_0(yr, i, "pce") = sum(map_com(com, i), Personal_Consumption(com, yr));

x_0(yr, i) = sum(com$map_com(com, i), Export(com, yr));
va_0(yr, "compen", j) = sum(sec$map_sec(sec, j), Labor_Demand(sec, yr));
va_0(yr, "surplus", j) = sum(sec$map_sec(sec, j), Capital_Demand(sec, yr));
ms_0(yr, i, m) = sum((map_com(com, i), map_mar(mar, m)), Margin_Supply(com, mar, yr));


ys_0(yr, j, i) = sum((map_com(com, i), map_sec(sec, j)), Intermediate_Supply(com, sec, yr));
fs_0(yr, i) = sum(com$map_com(com, i), Household_Supply(com, yr));
m_0(yr, i) = sum(com$map_com(com, i), Import(com, yr));
md_0(yr, m, i) = sum((map_com(com, i), map_mar(mar, m)), Margin_Demand(com, mar, yr));

y_0(yr, i) = sum(com$map_com(com, i), Gross_Output(com, yr));
a_0(yr, i) = sum(com$map_com(com, i), Armington_Supply(com, yr));
bopdef_0(yr) = Balance_Payments(yr);

ta_0(yr, i) = sum(com$map_com(com, i), Tax_Rate(com, yr));
tm_0(yr, i) = sum(com$map_com(com, i), Tariff_Rate(com, yr));
ty_0(yr, j) = sum(sec$map_sec(sec, j), Output_Tax_Rate(sec, yr));


parameter 
    zero_profit(yr, j),
    market_clearance(yr, i),
    margin_balance(yr, m);


zero_profit(yr, j) = sum(i, ys_0(yr, j, i))*(1 - ty_0(yr, j)) - sum(i, id_0(yr, i, j)) - sum(va, va_0(yr, va, j));
market_clearance(yr, i) = a_0(yr, i)*(1-ta_0(yr, i)) + x_0(yr, i) - y_0(yr, i) - m_0(yr, i)*(1+tm_0(yr, i)) - sum(m, md_0(yr, m, i));
margin_balance(yr, m) = sum(i, ms_0(yr, i, m)) - sum(i, md_0(yr, m, i));


display zero_profit, market_clearance, margin_balance;


execute_unload '%output_path%' 
    i, j, m, fd, va, yr,

    id_0, fd_0, x_0, va_0, ms_0,

    ys_0, fs_0, m_0, md_0, 

    y_0, a_0, bopdef_0,
    ta_0, tm_0, ty_0;
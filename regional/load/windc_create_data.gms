$title Create the WiNDC Regional dataset

$OnText
Create the Regional dataset with sets and parameters that match classic 
WiNDC notation, but with domain orders that matches the WiNDCRegional.jl 
dataset. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `output` - Name of the output GDX file. Default is `regional_windc.gdx`.

Example:

    gams load_data --data_dir "path/to/data" --data_file "my_data.gdx"

$OffText

$if not set data_dir $set data_dir "%system.fp%../data"

$if not set data_file $set data_file "regional_bea.gdx"
$set data_path "%data_dir%/%data_file%"

$if not set output $set output "regional_windc.gdx"
$set output_path "%data_dir%/%output%"



$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" windc

Parameter
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


a0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Absorption(com, state, yr));
bopdef0(r,yr) = sum(map_state(state,r), Balance_of_Payments(state, yr));
cd0(g,r,yr) = sum((map_com(com,g), map_state(state,r)), Personal_Consumption(com, state, yr));
dd0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Local_Demand(com, state, yr));
dm0(g,m,r,yr) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), Local_Margin_Supply(com, mar, state, yr));
g0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Government_Final_Demand(com, state, yr));
hhadj0(r,yr)  = sum(map_state(state,r), Household_Adjustment(state, yr));
i0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Investment_Final_Demand(com, state, yr));
id0(g,s,r,yr) = sum((map_com(com,g), map_state(state,r), map_sec(sec,s)), Intermediate_Demand(com, sec, state, yr));
kd0(s,r,yr)   = sum((map_sec(sec,s), map_state(state,r)), Capital_Demand(sec, state, yr));
ld0(s,r,yr)   = sum((map_sec(sec,s), map_state(state,r)), Labor_Demand(sec, state, yr));
m0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Import(com, state, yr));
md0(g,m,r,yr) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), Margin_Demand(com, mar, state, yr));
nd0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), National_Demand(com, state, yr));
nm0(g,m,r,yr) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), National_Margin_Supply(com, mar, state, yr));
rx0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Reexport(com, state, yr));
s0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Total_Supply(com, state, yr));
ta0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Tax_Rate(com, state, yr));
tm0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Tariff_Rate(com, state, yr));
ty0(s,r,yr)   = sum((map_sec(sec,s), map_state(state,r)), Output_Tax_Rate(sec, state, yr));
x0(g,r,yr)    = sum((map_com(com,g), map_state(state,r)), Export(com, state, yr));
xd0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Regional_Local_Supply(com, state, yr));
xn0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Regional_National_Supply(com, state, yr));
yh0(g,r,yr)   = sum((map_com(com,g), map_state(state,r)), Household_Supply(com, state, yr));
ys0(g,s,r,yr) = sum((map_com(com,g), map_state(state,r), map_sec(sec,s)), Intermediate_Supply(com, sec, state, yr));



execute_unload '%output_path%' 
    g, s, m, r, yr,
    a0, bopdef0, cd0, dd0, dm0, g0, 
    hhadj0, i0, id0, kd0, ld0, m0, 
    md0, nd0, nm0, rx0, s0, ta0, tm0, 
    ty0, x0, xd0, xn0, yh0, ys0;


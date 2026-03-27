$title Load the WiNDC Household dataset

*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------

$if not set data_dir $set data_dir "%system.fp%../data"

$if not set file_name $set file_name "regional_bea.gdx"
$set file_path "%data_dir%/%file_name%"

$if not set output $set output "regional_legacy_windc.gdx"
$set output_path "%data_dir%/%output%"


$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" legacy_windc

Parameter
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


a0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Absorption(com, state, yr));
bopdef0(yr,r) = sum(map_state(state,r), Balance_of_Payments(state, yr));
cd0(yr,r,g) = sum((map_com(com,g), map_state(state,r)), Personal_Consumption(com, state, yr));
dd0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Local_Demand(com, state, yr));
dm0(yr,r,g,m) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), Local_Margin_Supply(com, mar, state, yr));
g0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Government_Final_Demand(com, state, yr));
hhadj0(yr,r)  = sum(map_state(state,r), Household_Adjustment(state, yr));
i0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Investment_Final_Demand(com, state, yr));
id0(yr,r,g,s) = sum((map_com(com,g), map_state(state,r), map_sec(sec,s)), Intermediate_Demand(com, sec, state, yr));
kd0(yr,r,s)   = sum((map_sec(sec,s), map_state(state,r)), Capital_Demand(sec, state, yr));
ld0(yr,r,s)   = sum((map_sec(sec,s), map_state(state,r)), Labor_Demand(sec, state, yr));
m0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Import(com, state, yr));
md0(yr,r,m,g) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), Margin_Demand(com, mar, state, yr));
nd0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), National_Demand(com, state, yr));
nm0(yr,r,g,m) = sum((map_com(com,g), map_state(state,r), map_mar(mar,m)), National_Margin_Supply(com, mar, state, yr));
rx0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Reexport(com, state, yr));
s0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Total_Supply(com, state, yr));
ta0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Tax_Rate(com, state, yr));
tm0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Tariff_Rate(com, state, yr));
ty0(yr,r,s)   = sum((map_sec(sec,s), map_state(state,r)), Output_Tax_Rate(sec, state, yr));
x0(yr,r,g)    = sum((map_com(com,g), map_state(state,r)), Export(com, state, yr));
xd0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Regional_Local_Supply(com, state, yr));
xn0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Regional_National_Supply(com, state, yr));
yh0(yr,r,g)   = sum((map_com(com,g), map_state(state,r)), Household_Supply(com, state, yr));
ys0(yr,r,s,g) = sum((map_com(com,g), map_state(state,r), map_sec(sec,s)), Intermediate_Supply(com, sec, state, yr));



execute_unload '%output_path%' 
    g, s, m, r, yr,
    a0, bopdef0, cd0, dd0, dm0, g0, 
    hhadj0, i0, id0, kd0, ld0, m0, 
    md0, nd0, nm0, rx0, s0, ta0, tm0, 
    ty0, x0, xd0, xn0, yh0, ys0;


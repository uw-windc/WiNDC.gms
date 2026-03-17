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

$if not set file_name $set file_name "household_bea.gdx"
$set file_path "%data_dir%/%file_name%"

$if not set output $set output "household_windc.gdx"
$set output_path "%data_dir%/%output%"



$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" windc

Parameter
    a0(r,g)         Armington supply,
    cd0_h(r,g,h)    Household level expenditures,
    dd0(r,g)        Regional demand from local  market,
    dm0(r,g,m)      Margin supply from local market,
    g0(r,g)         Government demand,
    govdef0         Government deficit,
    hhtrn0(r,h,trn) Disaggregate transfer payments,
    i0(r,g)         Investment demand,
    id0(r,g,s)      Intermediate demand,
    kd0(r,s)        Capital demand,
    ke0(r,h)        Household interest payments,
    ld0(r,s)        Labor demand,
    le0(r,q,h)      Household labor endowment,
    m0(r,s)         Imports,
    md0(r,m,s)      Total margin demand,
    nd0(r,g)        Regional demand from national market,
    nm0(r,g,m)      Margin demand from national market,
    rx0(r,s)        Re-exports of goods and services,
    s0(r,s)         Aggregate supply,
    sav0(r,h)       Household saving,
    ta0(r,s)        Tax net subsidy rate on intermediate demand,
    tfica0(r,h)     Household FICA labor tax rate,
    tk0(r,s)          Capital tax rate,
    tl_avg0(r,h)    Household average labor tax rate,
    tl0(r,h)        Household marginal labor tax rate,
    tm0(r,g)        Import tariff,
    ty0(r,g)        Output tax on production,
    x0(r,g)         Exports of goods and services,
    xd0(r,g)        Regional supply to local market,
    xn0(r,g)        Regional supply to national market,
    yh0(r,g)        Household production,
    ys0(r,s,g)      Sectoral supply;



a0(r,g)         = sum((map_com(com, g), map_state(state, r)), Absorption(com, state));
cd0_h(r,g,h)    = sum((map_com(com, g), map_state(state, r)), Personal_Consumption(com, h, state));
dd0(r,g)        = sum((map_com(com, g), map_state(state, r)), Local_Demand(com, state));
dm0(r,g,m)      = sum((map_com(com, g), map_state(state, r), map_mar(mar, m)), Local_Margin_Supply(com, mar, state));
g0(r,g)         = sum((map_com(com, g), map_state(state, r)), Government_Final_Demand(com, state));
govdef0         = Government_Deficit;
hhtrn0(r,h,trn) = sum(map_state(state, r), Transfer_Payment(trn, h, state));
i0(r,g)         = sum((map_com(com, g), map_state(state, r)), Investment_Final_Demand(com, state));
id0(r,g,s)      = sum((map_com(com, g), map_state(state, r), map_sec(sec, s)), Intermediate_Demand(com, sec, state));
kd0(r,s)        = sum((map_sec(sec, s), map_state(state, r)), Capital_Demand(sec, state));
ke0(r,h)        = sum(map_state(state, r), Household_Interest(h, state));
ld0(r,s)        = sum((map_sec(sec, s), map_state(state, r)), Labor_Demand(sec, state));
le0(r,q,h)      = sum((map_state(state, r), map_dest(dest, q), map_com(com, g)), Labor_Endowment(dest, h, state));
m0(r,s)         = sum((map_state(state, r), map_com(com, g)), Import(com, state));
md0(r,m,s)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), Margin_Demand(com, mar, state));
nd0(r,g)        = sum((map_state(state, r), map_com(com, g)), National_Demand(com, state));
nm0(r,g,m)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), National_Margin_Supply(com, mar, state));
rx0(r,s)        = sum((map_state(state, r), map_com(com, g)), Reexport(com, state));
s0(r,s)         = sum((map_state(state, r), map_com(com, g)), Total_Supply(com, state));
sav0(r,h)       = sum((map_state(state, r)), Savings(h, state));
ta0(r,s)        = sum((map_state(state, r), map_com(com, g)), Tax_Rate(com, state));
tfica0(r,h)     = sum((map_state(state, r)), FICA_Tax_Rate(h, state));
tk0(r, s)       = sum((map_state(state, r), map_sec(sec, s)), Capital_Tax_Rate(sec, state));
tl_avg0(r,h)    = sum((map_state(state, r)), Average_Labor_Tax_Rate(h, state));
tl0(r,h)        = sum((map_state(state, r)), Marginal_Labor_Tax_Rate(h, state));
tm0(r,g)        = sum((map_state(state, r), map_com(com, g)), Duty_Rate(com, state));
ty0(r,g)        = sum((map_state(state, r), map_sec(sec, s)), Output_Tax_Rate(sec, state));
x0(r,g)         = sum((map_state(state, r), map_com(com, g)), Export(com, state));
xd0(r,g)        = sum((map_state(state, r), map_com(com, g)), Regional_Local_Supply(com, state));
xn0(r,g)        = sum((map_state(state, r), map_com(com, g)), Regional_National_Supply(com, state));
yh0(r,g)        = sum((map_state(state, r), map_com(com, g)), Household_Supply(com, state));
ys0(r,s,g)      = sum((map_state(state, r), map_com(com, g), map_sec(sec, s)), Intermediate_Supply(com, sec, state));



execute_unload '%output_path%' 
    g, s, m, trn, h, q, r,
    a0, cd0_h, dd0, dm0, g0, govdef0, 
    hhtrn0, i0, id0, kd0, ke0, ld0, le0, 
    m0, md0, nd0, nm0, rx0, s0, sav0, ta0, 
    tfica0, tk0, tl_avg0, tl0, tm0, ty0, 
    x0, xd0, xn0, yh0, ys0; 

$exit

    id0, pce0, fd0, x0, va0, ms0,

    ys0, fs0, m0, md0, duty0, sbd0, tax0,

    y0, a0, bopdef0,

    ta0, tm0, ty0;
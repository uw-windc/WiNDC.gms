$title Create the WiNDC Legacy Household dataset

$OnText
Create the Legacy Household dataset with sets and parameters that match classic 
WiNDC notation.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `output` - Name of the output GDX file. Default is `household_legacy_windc.gdx`.

Example:

    gams load_data --data_dir "path/to/data" --data_file "my_data.gdx"

$OffText


$if not set data_dir $set data_dir "%system.fp%../data"

$if not set data_file $set data_file "household_bea.gdx"
$set data_path "%data_dir%/%data_file%"

$if not set output $set output "household_legacy_windc.gdx"
$set output_path "%data_dir%/%output%"



$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" legacy_windc

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
    m0(r,g)         Imports,
    md0(r,m,g)      Total margin demand,
    nd0(r,g)        Regional demand from national market,
    nm0(r,g,m)      Margin demand from national market,
    rx0(r,g)        Re-exports of goods and services,
    s0(r,g)         Aggregate supply,
    sav0(r,h)       Household saving,
    ta0(r,g)        Tax net subsidy rate on intermediate demand,
    tfica0(r,h)     Household FICA labor tax rate,
    tk0(r,s)        Capital tax rate,
    tl_avg0(r,h)    Household average labor tax rate,
    tl0(r,h)        Household marginal labor tax rate,
    tm0(r,g)        Import tariff,
    ty0(r,s)        Output tax on production,
    x0(r,g)         Exports of goods and services,
    xd0(r,g)        Regional supply to local market,
    xn0(r,g)        Regional supply to national market,
    yh0(r,g)        Household production,
    ys0(r,s,g)      Sectoral supply,
    ls0(r,h)	Labor supply (net),
    lsr0(r,h)	Leisure demand,
    esubL(r,h)	Leisure-consumption elasticity;



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
le0(r,q,h)      = sum((map_state(state, r), map_dest(dest, q)), Labor_Endowment(dest, h, state));
m0(r,g)         = sum((map_state(state, r), map_com(com, g)), Import(com, state));
md0(r,m,g)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), Margin_Demand(com, mar, state));
nd0(r,g)        = sum((map_state(state, r), map_com(com, g)), National_Demand(com, state));
nm0(r,g,m)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), National_Margin_Supply(com, mar, state));
rx0(r,g)        = sum((map_state(state, r), map_com(com, g)), Reexport(com, state));
s0(r,g)         = sum((map_state(state, r), map_com(com, g)), Total_Supply(com, state));
sav0(r,h)       = sum((map_state(state, r)), Savings(h, state));
ta0(r,g)        = sum((map_state(state, r), map_com(com, g)), Tax_Rate(com, state));
tfica0(r,h)     = sum((map_state(state, r)), FICA_Tax_Rate(h, state));
tk0(r, s)       = sum((map_state(state, r), map_sec(sec, s)), Capital_Tax_Rate(sec, state));
tl_avg0(r,h)    = sum((map_state(state, r)), Average_Labor_Tax_Rate(h, state));
tl0(r,h)        = sum((map_state(state, r)), Marginal_Labor_Tax_Rate(h, state));
tm0(r,g)        = sum((map_state(state, r), map_com(com, g)), Duty_Rate(com, state));
ty0(r,s)        = sum((map_state(state, r), map_sec(sec, s)), Output_Tax_Rate(sec, state));
x0(r,g)         = sum((map_state(state, r), map_com(com, g)), Export(com, state));
xd0(r,g)        = sum((map_state(state, r), map_com(com, g)), Regional_Local_Supply(com, state));
xn0(r,g)        = sum((map_state(state, r), map_com(com, g)), Regional_National_Supply(com, state));
yh0(r,g)        = sum((map_state(state, r), map_com(com, g)), Household_Supply(com, state));
ys0(r,s,g)      = sum((map_state(state, r), map_com(com, g), map_sec(sec, s)), Intermediate_Supply(com, sec, state));

ls0(r,h) = sum(map_state(state, r), Labor_Supply(h, state));
lsr0(r,h) = sum(map_state(state, r), Leisure_Demand(h, state));
esubL(r,h) = sum(map_state(state, r), Leisure_Consumption_Elas(h, state));

execute_unload '%output_path%' 
    g, s, m, trn, h, q, r,
    a0, cd0_h, dd0, dm0, g0, govdef0, 
    hhtrn0, i0, id0, kd0, ke0, ld0, le0, 
    m0, md0, nd0, nm0, rx0, s0, sav0, ta0, 
    tfica0, tk0, tl_avg0, tl0, tm0, ty0, 
    x0, xd0, xn0, yh0, ys0, ls0, lsr0, esubL; 


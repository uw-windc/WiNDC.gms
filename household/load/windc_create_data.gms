$title Create the WiNDC Household dataset

$OnText
Create the Houshold dataset with sets and parameters that match classic 
WiNDC notation, but with domain orders that matches the WiNDCHousehold.jl 
dataset. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `output` - Name of the output GDX file. Default is `household_windc.gdx`.

Example:

    gams load_data --data_dir "path/to/data" --data_file "my_data.gdx"

$OffText


$if not set data_dir $set data_dir "%system.fp%../data"

$if not set data_file $set data_file "household_bea.gdx"
$set data_path "%data_dir%/%data_file%"

$if not set output $set output "household_windc.gdx"
$set output_path "%data_dir%/%output%"



$include "%system.fp%/bea_load_data.gms"


$batinclude "%system.fp%/mappings.gms" windc

Parameter
    a0(g, r)         Armington supply,
    cd0_h(g, h, r)    Household level expenditures,
    dd0(g, r)        Regional demand from local  market,
    dm0(g, m, r)      Margin supply from local market,
    g0(g, r)         Government demand,
    govdef0         Government deficit,
    hhtrn0(trn, h, r) Disaggregate transfer payments,
    i0(g, r)         Investment demand,
    id0(g, s, r)      Intermediate demand,
    kd0(s, r)        Capital demand,
    ke0(h, r)        Household interest payments,
    ld0(s, r)        Labor demand,
    le0(q, h, r)      Household labor endowment,
    m0(g, r)         Imports,
    md0(g, m, r)      Total margin demand,
    nd0(g, r)        Regional demand from national market,
    nm0(g, m, r)      Margin demand from national market,
    rx0(g, r)        Re-exports of goods and services,
    s0(g, r)         Aggregate supply,
    sav0(h, r)       Household saving,
    ta0(g, r)        Tax net subsidy rate on intermediate demand,
    tfica0(h, r)     Household FICA labor tax rate,
    tk0(s, r)        Capital tax rate,
    tl_avg0(h, r)    Household average labor tax rate,
    tl0(h, r)        Household marginal labor tax rate,
    tm0(g, r)        Import tariff,
    ty0(s, r)        Output tax on production,
    x0(g, r)         Exports of goods and services,
    xd0(g, r)        Regional supply to local market,
    xn0(g, r)        Regional supply to national market,
    yh0(g, r)        Household production,
    ys0(g, s, r)      Sectoral supply,
    ls0(h, r)	Labor supply (net),
    lsr0(h, r)	Leisure demand,
    esubL(h, r)	Leisure-consumption elasticity;



a0(g, r)         = sum((map_com(com, g), map_state(state, r)), Absorption(com, state));
cd0_h(g, h, r)    = sum((map_com(com, g), map_state(state, r)), Personal_Consumption(com, h, state));
dd0(g, r)        = sum((map_com(com, g), map_state(state, r)), Local_Demand(com, state));
dm0(g, m, r)      = sum((map_com(com, g), map_state(state, r), map_mar(mar, m)), Local_Margin_Supply(com, mar, state));
g0(g, r)         = sum((map_com(com, g), map_state(state, r)), Government_Final_Demand(com, state));
govdef0         = Government_Deficit;
hhtrn0(trn, h, r) = sum(map_state(state, r), Transfer_Payment(trn, h, state));
i0(g, r)         = sum((map_com(com, g), map_state(state, r)), Investment_Final_Demand(com, state));
id0(g, s, r)      = sum((map_com(com, g), map_state(state, r), map_sec(sec, s)), Intermediate_Demand(com, sec, state));
kd0(s, r)        = sum((map_sec(sec, s), map_state(state, r)), Capital_Demand(sec, state));
ke0(h, r)        = sum(map_state(state, r), Household_Interest(h, state));
ld0(s, r)        = sum((map_sec(sec, s), map_state(state, r)), Labor_Demand(sec, state));
le0(q, h, r)      = sum((map_state(state, r), map_dest(dest, q)), Labor_Endowment(dest, h, state));
m0(g, r)         = sum((map_state(state, r), map_com(com, g)), Import(com, state));
md0(g, m, r)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), Margin_Demand(com, mar, state));
nd0(g, r)        = sum((map_state(state, r), map_com(com, g)), National_Demand(com, state));
nm0(g, m, r)      = sum((map_state(state, r), map_com(com, g), map_mar(mar, m)), National_Margin_Supply(com, mar, state));
rx0(g, r)        = sum((map_state(state, r), map_com(com, g)), Reexport(com, state));
s0(g, r)         = sum((map_state(state, r), map_com(com, g)), Total_Supply(com, state));
sav0(h, r)       = sum((map_state(state, r)), Savings(h, state));
ta0(g, r)        = sum((map_state(state, r), map_com(com, g)), Tax_Rate(com, state));
tfica0(h, r)     = sum((map_state(state, r)), FICA_Tax_Rate(h, state));
tk0(s, r)       = sum((map_state(state, r), map_sec(sec, s)), Capital_Tax_Rate(sec, state));
tl_avg0(h, r)    = sum((map_state(state, r)), Average_Labor_Tax_Rate(h, state));
tl0(h, r)        = sum((map_state(state, r)), Marginal_Labor_Tax_Rate(h, state));
tm0(g, r)        = sum((map_state(state, r), map_com(com, g)), Duty_Rate(com, state));
ty0(s, r)        = sum((map_state(state, r), map_sec(sec, s)), Output_Tax_Rate(sec, state));
x0(g, r)         = sum((map_state(state, r), map_com(com, g)), Export(com, state));
xd0(g, r)        = sum((map_state(state, r), map_com(com, g)), Regional_Local_Supply(com, state));
xn0(g, r)        = sum((map_state(state, r), map_com(com, g)), Regional_National_Supply(com, state));
yh0(g, r)        = sum((map_state(state, r), map_com(com, g)), Household_Supply(com, state));
ys0(g, s, r)      = sum((map_state(state, r), map_com(com, g), map_sec(sec, s)), Intermediate_Supply(com, sec, state));

ls0(h, r) = sum(map_state(state, r), Labor_Supply(h, state));
lsr0(h, r) = sum(map_state(state, r), Leisure_Demand(h, state));
esubL(h, r) = sum(map_state(state, r), Leisure_Consumption_Elas(h, state));

execute_unload '%output_path%' 
    g, s, m, trn, h, q, r,
    a0, cd0_h, dd0, dm0, g0, govdef0, 
    hhtrn0, i0, id0, kd0, ke0, ld0, le0, 
    m0, md0, nd0, nm0, rx0, s0, sav0, ta0, 
    tfica0, tk0, tl_avg0, tl0, tm0, ty0, 
    x0, xd0, xn0, yh0, ys0, ls0, lsr0, esubL; 


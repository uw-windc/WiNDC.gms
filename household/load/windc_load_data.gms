$title Load the WiNDC Household dataset

$OnText
Load the Household dataset with sets and parameters that match classic 
WiNDC notation, but with domain orders that matches the WiNDCHousehold.jl 
dataset. 

For example, the Intermediate_Demand(com, sec, state) parameter from the BEA 
dataset becomes id0(g, s, r) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "household_windc.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"


*---------------
* End of Options
* --------------

set
    g       "Commodities", 
    s       "Sectors",
    m       "Margins (trade or transport)", 
    trn     "Transfer types", 
    h       "Households (h1, h2, h3, h4, h5)",
    r       "Regions";

$gdxin '%data_path%'
$load g, s, m, trn, h, r


alias(r, q);



parameters
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
    ls0(h, r)	    Labor supply (net),
    lsr0(h, r)	    Leisure demand,
    esubL(h, r)	    Leisure-consumption elasticity;


$gdxin '%data_path%'
$loaddc a0, cd0_h, dd0, dm0, g0, govdef0, hhtrn0, i0, id0, kd0, ke0, ld0 
$loaddc le0, m0, md0, nd0, nm0, rx0, s0, sav0, ta0, tfica0, tk0, tl_avg0 
$loaddc tl0, tm0, ty0, x0, xd0, xn0, yh0, ys0, ls0, lsr0, esubL

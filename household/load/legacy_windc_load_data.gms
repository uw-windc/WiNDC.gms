$title Load the WiNDC Household dataset

$OnText
Load the Household dataset with sets and parameters that match classic 
WiNDC notation. This data matches that provided by windc_build.

For example, the Intermediate_Demand(com, sec, state) parameter from the BEA 
dataset becomes id0(r, g, s) in the WiNDC dataset.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_legacy_windc.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "household_legacy_windc.gdx"

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
    ls0(r,h)	    Labor supply (net),
    lsr0(r,h)	    Leisure demand,
    esubL(r,h)	    Leisure-consumption elasticity;


$gdxin '%data_path%'
$loaddc a0, cd0_h, dd0, dm0, g0, govdef0, hhtrn0, i0, id0, kd0, ke0, ld0 
$loaddc le0, m0, md0, nd0, nm0, rx0, s0, sav0, ta0, tfica0, tk0, tl_avg0 
$loaddc tl0, tm0, ty0, x0, xd0, xn0, yh0, ys0, ls0, lsr0, esubL

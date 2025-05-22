$title Load the WiNDC national dataset

*-------------------
* Options
* 
* These can be set at the command line by calling
* 
*     gams load_data --file_path "path/to/file.gdx"
* 
* and so on.
* ------------------


$if not set file_path $set file_path "%system.fp%/../data/national_data.gdx"

*---------------
* End of Options 
* --------------


* --------------
* Define Sets 
* --------------
set
    yr		Years in WiNDC Database,
    i		BEA Goods and sectors categories,
    fd		BEA Final demand categories,
    ts		BEA Taxes and subsidies categories,
    va		BEA Value added categories excluding othtax,
    m		Margins (trade or transport);

$gdxin %file_path%
$loaddc yr i va fd ts m

alias (i,j);


* ---------------
* Load Parameters
* ---------------

parameter

    ys_0(yr,j,i)	Sectoral supply,
    ty_0(yr,j)		Output tax rate,
    fs_0(yr,i)		Household supply,
    id_0(yr,i,j)	Intermediate demand,
    fd_0(yr,i,fd)	Final demand,
    va_0(yr,va,j)	Value added,
    ts_0(yr,ts,i)	Taxes and subsidies,
    m_0(yr,i)		Imports,
    x_0(yr,i)		Exports of goods and services,
    mrg_0(yr,i)		Trade margins,
    trn_0(yr,i)		Transportation costs,
    duty_0(yr,i)	Import duties,
    sbd_0(yr,i)		Subsidies on products,
    tax_0(yr,i)		Taxes on products,
    ms_0(yr,i,m)	Margin supply,
    md_0(yr,m,i)	Margin demand,
    ta_0(yr,i)		Tax net subsidy rate on intermediate demand,
    tm_0(yr,i)		Import tariff;

$loaddc ys_0 ty_0 fs_0 id_0 fd_0 va_0 m_0
$loaddc x_0 ms_0 md_0 ta_0 tm_0
$gdxin

* --------------------
* Generated Parameters
* --------------------

parameter 
    y_0(yr,i)		Gross output,
    a_0(yr,i)		Armington supply,
    bopdef_0(yr)    balance of payments;

y_0(yr,i)= sum(j, ys_0(yr,j,i)) + fs_0(yr,i) - sum(m, ms_0(yr,i,m));
a_0(yr,i) = sum(fd, fd_0(yr,i,fd)) + sum(j, id_0(yr,i,j));
bopdef_0(yr) = sum(i, m_0(yr,i)-x_0(yr,i));
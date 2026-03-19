$title Household accounting model to verify benchmark consistency of MGE model


$OnText
Household accounting model to verify benchmark consistency of MGE model. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `year` - Year of the data to load. Default is `2024`. Only year available is 2024.

$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "household_bea.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

$if not set year $set year "2024"

*---------------
* End of Options 
* --------------

$include "%system.fp%/../load/bea_load_data.gms"

parameter
    etaK "Capital elasticity of output" /4/;

parameter
    OTR(sec, state) "Output tax rate"
    TR(com, state)  "Tax rate"
    DR(com, state)  "Duty rate"
    TK(sec, state)  "Capital tax rate"
    FICA(h, state)  "FICA tax rate"
    LTR(h, state)   "Labor tax rate";

OTR(sec, state) = Output_Tax_Rate(sec, state);

TR(com, state) = Tax_Rate(com, state);
DR(com, state) = Duty_Rate(com, state);
TK(sec, state) = Capital_Tax_Rate(sec, state);
FICA(h, state) = FICA_Tax_Rate(h, state);
LTR(h, state) = Marginal_Labor_Tax_Rate(h, state);


sets y_(sec, state) 	Sectors and regions with positive production,
	x_(com, state) 	Disposition by region,
	a_(com, state) 	Absorption by region,
	pn_(com)  	National market,
	pd_(com, state)  	Local markets;

y_(sec, state) = yes$(sum(com, Intermediate_Supply(com, sec, state))>0);
x_(com, state) = yes$round(Total_Supply(com, state),6);
a_(com, state) = yes$(Absorption(com, state) + Reexport(com, state));
pn_(com) = yes$(sum(state, Regional_National_Supply(com, state) + National_Demand(com, state) + sum(mar, Margin_Demand(com, mar, state))));
pd_(com, state) = yes$(Regional_Local_Supply(com, state) + Local_Demand(com, state) + sum(mar, Local_Margin_Supply(com, mar, state)));


*parameter report(*, *);
*
*report("IS", "1") = sum(com, Intermediate_Supply(com, "624", "Alabama"));
*report("ID", "1") = sum(com, Intermediate_Demand(com, "624", "Alabama"));
*report("LD", "1") = Labor_Demand("624", "Alabama");
*report("CD", "1") = Capital_Demand("624", "Alabama");
*report("OT", "1") = Output_Tax("624", "Alabama");
*report("OTR", "1") = Output_Tax_Rate("624", "Alabama");
*report("CT", "1") = Capital_Tax("624", "Alabama");
*report("CTR", "1") = Capital_Tax_Rate("624", "Alabama");
*
*display report;


$ontext 
$model:static_hh_mge

$sectors:
    Y(sec, state)$y_(sec, state)    !   Production
    X(com, state)$x_(com, state)    !   Disposition
    A(com, state)$a_(com, state)    !   Absorption
    LS(h, state)                    !   Labor supply
    KS                              !   Aggregate capital stock
    C(h, state)	                    !   Household consumption
    MS(mar, state)                  !   Margin supply

$commodities:
    PA(com, state)$Absorption(com, state)        !  Regional market (input)
    PC(h, state)                                 !  Consumer price index
    PD(com, state)$pd_(com, state)               !  Local market price
    PFX                                          !  Foreign exchange
    PK                                           !  Aggregate return to capital
    PL(state)                                    !  Regional wage rate
    PLS(h, state)                                !  Leisure price
    PM(mar, state)                               !  Margin price
    PN(com)$pn_(com)                             !  National market price for goods
    PY(com, state)$Total_Supply(com, state)      !  Regional market (output)
    RK(sec, state)$Capital_Demand(sec, state)    !  Sectoral rental rate
    RKS                                          !  Capital stock
		
		

$consumer:
	RA(h, state)    !   Representative agent
	NYSE            !   Aggregate capital owner
	INVEST          !   Aggregate investor
	GOVT            !   Aggregate government

$auxiliary:
	SAVRATE		!	Domestic savings rate
	TRANS		!	Budget balance rationing variable
	SSK			!	Steady-state capital stock
	CPI			!	Consumer price index

$prod:Y(sec, state)$y_(sec, state)  s:0 va:1
	o:PY(com, state)	q:Intermediate_Supply(com, sec, state)  a:GOVT t:OTR(sec, state)       p:(1-Output_Tax_rate(sec, state))
	i:PA(com, state)    q:Intermediate_Demand(com, sec, state)
	i:PL(state)         q:Labor_Demand(sec, state)       va:
	i:RK(sec, state)    q:Capital_Demand(sec, state)     va:	a:GOVT t:tk(sec, state)       p:(1+Capital_Tax_Rate(sec, state))

$prod:X(com, state)$x_(com, state)  t:4
	o:PFX                  q:(Export(com, state)-Reexport(com, state))
	o:PN(com)              q:Regional_National_Supply(com, state)
	o:PD(com, state)       q:Regional_Local_Supply(com, state)
	i:PY(com, state)       q:Total_Supply(com, state)

$prod:A(com, state)$a_(com, state)  s:0 dm:2  d(dm):4
	o:PA(com, state)   q:Absorption(com, state)                a:GOVT t:TR(com, state)  p:(1-Tax_Rate(com, state))
	o:PFX              q:Reexport(com, state)
	i:PN(com)          q:National_Demand(com, state)    d:
	i:PD(com, state)   q:Local_Demand(com, state)       d:
	i:PFX              q:Import(com, state)             dm:    a:GOVT t:DR(com, state)  p:(1+Duty_Rate(com, state))
	i:PM(mar, state)   q:Margin_Demand(com, mar, state)

$prod:MS(mar, state)
	o:PM(mar, state)   q:(sum(com, Margin_Demand(com, mar, state)))
	i:PN(com)          q:National_Margin_Supply(com, mar, state)
	i:PD(com, state)   q:Local_Margin_Supply(com, mar, state)

$prod:C(h, state)   s:1
	o:PC(h, state)      q:(sum(com, Personal_Consumption(com, h, state)))
	i:PA(com, state)    q:Personal_Consumption(com, h, state)

$prod:LS(h, state)
	o:PL(dest)       q:Labor_Endowment(dest, h, state)	a:GOVT	t:(LTR(h, state)+FICA(h, state))	p:(1-Marginal_Labor_Tax_Rate(h, state)-FICA_Tax_Rate(h, state))
	i:PLS(h, state)	        q:Labor_Supply(h, state)


$prod:KS	t:etaK
	o:RK(sec, state)	q:Capital_Demand(sec, state)
	i:RKS		q:(sum((sec, state), Capital_Demand(sec, state)))

$demand:RA(h, state)  s:Leisure_Consumption_Elas(h, state)
	d:PC(h, state)      q:(sum(com, Personal_Consumption(com, h, state)))
	d:PLS(h, state)	    q:Leisure_Demand(h, state)
	e:PLS(h, state)	    q:(Labor_Supply(h, state)+Leisure_Demand(h, state))
	e:PFX		        q:(sum(trn, Transfer_Payment(trn, h, state)))   r:TRANS
	e:PLS(h, state)	    q:((LTR(h, state) - Average_Labor_Tax_Rate(h, state))*sum(dest,Labor_Endowment(dest,h, state)))
	e:PK		        q:Household_Interest(h, state)
	e:PFX		        q:(-Savings(h, state))   r:SAVRATE

$demand:NYSE
	d:PK
	e:PY(com, state)    q:Household_Supply(com, state)
	e:RKS		        q:(sum((sec, state),Capital_Demand(sec, state)))  r:SSK

$demand:INVEST  s:0
	d:PA(com, state)    q:Investment_Final_Demand(com, state)
	e:PFX		        q:(sum((h,state), Savings(h, state)))     r:SAVRATE

$demand:GOVT
	d:PA(com, state)    q:Government_Final_Demand(com, state)
	e:PFX           q:(-sum((trn, h, state), Transfer_Payment(trn, h, state)))  r:TRANS	
	e:PFX           q:Government_Deficit
	e:PLS(h, state)	q:(-(LTR(h, state) - Average_Labor_Tax_Rate(h, state))*sum(dest,Labor_Endowment(dest, h, state)))

	
$constraint:SSK
	sum((com, state), Investment_Final_Demand(com, state)*(PA(com, state) - RKS)) =e= 0;

$constraint:SAVRATE
	INVEST =e= sum((com, state), PA(com, state)*Investment_Final_Demand(com, state))*SSK;

$constraint:TRANS
	GOVT =e= sum((com, state),PA(com, state)*Government_Final_Demand(com, state));

$constraint:CPI
	CPI =e= sum((com, h, state), PC(h, state)*Personal_Consumption(com, h, state))/sum((com, h, state),Personal_Consumption(com, h, state));

$offtext
$sysinclude mpsgeset static_hh_mge -mt=1


* Set the numeraire:

PFX.FX = 1;

* Starting values for other auxiliary variables:

CPI.L = 1;
TRANS.L = 1;
SAVRATE.L = 1;
SSK.L = 1;

static_hh_mge.workspace = 10000;
static_hh_mge.iterlim=0;
$include %gams.scrdir%static_hh_mge.gen
solve static_hh_mge using mcp;
abort$round(static_hh_mge.objval,3) "Benchmark calibration of static_hh_mge fails.";

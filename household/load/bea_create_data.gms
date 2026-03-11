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
$if not set file_name $set file_name "household.gdx"
$if not set output $set output "household_bea.gdx"
$set file_path "%data_dir%/%file_name%"
$set output_path "%data_dir%/%output%"



* --------------
* Define Sets 
* --------------
set
    com   "Commodities",
    h     "Household categories",
    mar   "Margin sectors",
    sec   "Sectors",
    state "States",
    trn "Transfer types";

$gdxin %file_path%
$loaddc com, h, mar, sec, state, trn

alias(state, dest);

parameter
    Average_Labor_Tax(h, state)             "",
    Capital_Demand(sec, state)              "",
    Capital_Tax(sec, state)                 "",
    Duty(com, state)                        "",
    Export(com, state)                      "",
    FICA_Tax(h, state)                      "",
    Government_Final_Demand(com, state)     "",
    Household_Interest(h, state)            "",
    Household_Supply(com, state)            "",
    Import(com, state)                      "",
    Intermediate_Demand(com, sec, state)    "",
    Intermediate_Supply(com, sec, state)    "",
    Investment_Final_Demand(com, state)     "",
    Labor_Demand(sec, state)                "",
    Labor_Endowment(dest, h, state)         "",
    Local_Demand(com, state)                "",
    Local_Margin_Supply(com, mar, state)    "",
    Margin_Demand(com, mar, state)          "",
    Marginal_Labor_Tax(h, state)            "",
    National_Demand(com, state)             "",
    National_Margin_Supply(com, mar, state) "",
    Output_Tax(sec, state)                  "",
    Personal_Consumption(com, h, state)     "",
    Reexport(com, state)                    "",
    Savings(h, state)                       "",
    Tax(com, state)                         "",
    Transfer_Payment(trn, h, state)       "";

$gdxin %file_path%
$loaddc Average_Labor_Tax, Capital_Demand, Capital_Tax, Duty
$loaddc Export, FICA_Tax, Government_Final_Demand, Household_Interest
$loaddc Household_Supply, Import, Intermediate_Demand, Intermediate_Supply
$loaddc Investment_Final_Demand, Labor_Demand, Labor_Endowment
$loaddc Local_Demand, Local_Margin_Supply, Margin_Demand
$loaddc Marginal_Labor_Tax, National_Demand, National_Margin_Supply
$loaddc Output_Tax, Personal_Consumption, Reexport, Savings
$loaddc Tax, Transfer_Payment


*Average_Labor_Tax(h, state)$(Average_Labor_Tax(h, state)<1e-6) = 0;
*Capital_Demand(sec, state)$(Capital_Demand(sec, state)<1e-6) = 0;
*Capital_Tax(sec, state)$(Capital_Tax(sec, state)<1e-6) = 0;
*Duty(com, state)$(Duty(com, state)<1e-6) = 0;
*Export(com, state)$(Export(com, state)<1e-6) = 0;
*FICA_Tax(h, state)$(FICA_Tax(h, state)<1e-6) = 0;
*Government_Final_Demand(com, state)$(Government_Final_Demand(com, state)<1e-6) = 0;
*Household_Interest(h, state)$(Household_Interest(h, state)<1e-6) = 0;
*Household_Supply(com, state)$(Household_Supply(com, state)<1e-6) = 0;
*Import(com, state)$(Import(com, state)<1e-6) = 0;
*Intermediate_Demand(com, sec, state)$(Intermediate_Demand(com, sec, state)<1e-6) = 0;
Intermediate_Supply(com, sec, state)$(Intermediate_Supply(com, sec, state)<1e-6) = 0;
*Investment_Final_Demand(com, state)$(Investment_Final_Demand(com, state)<1e-6) = 0;
*Labor_Demand(sec, state)$(Labor_Demand(sec, state)<1e-6) = 0;
*Labor_Endowment(dest, h, state)$(Labor_Endowment(dest, h, state)<1e-6) = 0;
*Margin_Demand(com, mar, state)$(Margin_Demand(com, mar, state)<1e-6) = 0;
*Marginal_Labor_Tax(h, state)$(Marginal_Labor_Tax(h, state)<1e-6) = 0;
*National_Demand(com, state)$(National_Demand(com, state)<1e-6) = 0;
*National_Margin_Supply(com, mar, state)$(National_Margin_Supply(com, mar, state)<1e-6) = 0;
*Output_Tax(sec, state)$(Output_Tax(sec, state)<1e-6) = 0;
*Personal_Consumption(com, h, state)$(Personal_Consumption(com, h, state)<1e-6) = 0;
*Reexport(com, state)$(Reexport(com, state)<1e-6) = 0;
*Savings(h, state)$(Savings(h, state)<1e-6) = 0;
*Tax(com, state)$(Tax(com, state)<1e-6) = 0;
*Transfer_Payment(trn, h, state)$(Transfer_Payment(trn, h, state)<1e-6) = 0;

Local_Demand(com, state)$(Local_Demand(com, state)<1e-6) = 0;
Local_Margin_Supply(com, mar, state)$(Local_Margin_Supply(com, mar, state)<1e-6) = 0;



* --------------------
* Generated Parameters
* --------------------

parameters
    Regional_National_Supply(com, state) "",
    Regional_Local_Supply(com, state)    "",
    Total_Supply(com, state)             "",
    Absorption(com, state)               "",
    Labor_Supply(h, state)               "",
    Leisure_Consumption_Elas(h, state)   "",
    Leisure_Demand(h, state)             "",
    Government_Deficit                   "",
    Labor_Supply_Income_Elas             "" /.05/,
    Leisure_Income_Elas                  "" /.2/ ;



*{\rm Total\_Supply} = \sum_{sectors} {\rm Intermediate\_Supply}} + {{\rm Household\_Supply}}
Total_Supply(com, state) = sum(sec, Intermediate_Supply(com, sec, state)) + Household_Supply(com, state);

*{\rm Regional\_Local\_Supply} = \sum (Local\_Margin\_Supply + Local\_Demand)
Regional_Local_Supply(com, state) = sum(mar, Local_Margin_Supply(com, mar, state)) + Local_Demand(com, state);

*{\rm Regional\_National\_Supply} = {\rm Total\_Supply} - {\rm Netports} - {\rm Regional\_Local\_Supply}
Regional_National_Supply(com, state) = Total_Supply(com, state) + Reexport(com, state) - Export(com, state) - Regional_Local_Supply(com, state);


*{\rm Absorption} = \sum_{\rm sectors} {\rm Intermediate\_Demand}} + \sum_{\rm other\_final\_demand}{{\rm Other\_Final\_Demand}}
Absorption(com, state) = sum(sec, Intermediate_Demand(com, sec, state)) + Investment_Final_Demand(com, state) + Government_Final_Demand(com, state) + sum(h, Personal_Consumption(com, h, state));

*{\rm Labor\_Supply} = \sum (Labor\_Endowment - Marginal\_Labor\_Tax - FICA\_Tax)
Labor_Supply(h, state) = sum(dest, Labor_Endowment(dest, h, state)) - Marginal_Labor_Tax(h, state) - FICA_Tax(h, state);


*{\rm Leisure\_Demand} = \epsilon \cdot {\rm Leisure\_Supply}
*     where ( \epsilon ) is the labor supply income elasticity (0.05).
Leisure_Demand(h, state) = Labor_Supply_Income_Elas * Labor_Supply(h, state);


*{\rm Leisure\_Consumption\_Elasticity} = \epsilon \cdot \frac{(PCE + LD)}{PCE} \cdot \frac{LS}{LD}
*    •  ( \epsilon ) is the leisure income elasticity (0.2),
*    •  PCE is Personal Consumption Expenditure
*    •  LD is Leisure Demand
*    •  LS is Labor Supply
Leisure_Consumption_Elas(h, state) = Leisure_Income_Elas * (sum(com, Personal_Consumption(com, h, state)) + Leisure_Demand(h, state)) / sum(com, Personal_Consumption(com, h, state)) * Labor_Supply(h, state) / Leisure_Demand(h, state);


*{\rm Government\_Deficit} = - \sum (Government\_Final\_Demand - Transfer\_Payment - Average\_Labor\_Tax - FICA\_Tax - Capital\_Tax - Output\_Tax - Tax - Duty)
Government_Deficit = 
    sum((state,com), Government_Final_Demand(com, state)) + 
    sum((state,h, trn), Transfer_Payment(trn, h, state)) -
    sum((state,h), Average_Labor_Tax(h, state)) -
    sum((state,h), FICA_Tax(h, state)) -
    sum((state,sec), Capital_Tax(sec, state)) -
    sum((state,sec), Output_Tax(sec, state)) -
    sum((state,com), Tax(com, state)) -
    sum((state,com), Duty(com, state));


* -------------------
* Tax Rates
* -------------------

parameter
    Output_Tax_Rate(sec, state)            "Policy output tax rate",
    Tax_Rate(com, state)                   "Policy tax net subsidy rate on intermediate demand",
    Duty_Rate(com, state)                  "Policy import tariff",
    Capital_Tax_Rate(sec, state)           "Policy capital tax rate",
    FICA_Tax_Rate(h, state)                "Policy FICA tax rate",
    Marginal_Labor_Tax_Rate(h, state)      "Policy labor tax rate",
    Average_Labor_Tax_Rate(h, state)       "Policy average labor tax rate";


*{\\rm Output\\_Tax\\_Rate} = \\frac{\\rm Output\\_Tax}{\\sum_{\\rm commodity} \\rm Intermediate\\_Supply}
Output_Tax_Rate(sec, state)$sum(com, Intermediate_Supply(com, sec, state)) = 
    Output_Tax(sec, state) / sum(com, Intermediate_Supply(com, sec, state));

*{\\rm Tax\\_Rate} = \\frac{\\rm Tax}{\\rm Absorption}
Tax_Rate(com, state)$Absorption(com, state) = 
    Tax(com, state) / Absorption(com, state);

*{\\rm Duty\\_Rate} = \\frac{\\rm Duty}{\\rm Import}
Duty_Rate(com, state)$Import(com, state) = 
    Duty(com, state) / Import(com, state);

*{\\rm Capital\\_Tax\\_Rate} = \\frac{\\rm Capital\\_Tax}{\\rm Capital\\_Demand}
Capital_Tax_Rate(sec, state)$Capital_Demand(sec, state) = 
    Capital_Tax(sec, state) / Capital_Demand(sec, state);

*{\\rm FICA\\_Tax\\_Rate} = \\frac{\\rm FICA\\_Tax}{\\sum_{\\rm Destinations} \\rm Labor\\_Endowment}
FICA_Tax_Rate(h, state)$sum(dest, Labor_Endowment(dest, h, state)) = 
    FICA_Tax(h, state) / sum(dest, Labor_Endowment(dest, h, state));

*{\\rm Marginal\\_Labor\\_Tax\\_Rate} = \\frac{\\rm Marginal\\_Labor\\_Tax}{\\sum_{\\rm Destinations} \\rm Labor\\_Endowment}
Marginal_Labor_Tax_Rate(h, state)$sum(dest, Labor_Endowment(dest, h, state)) = 
    Marginal_Labor_Tax(h, state) / sum(dest, Labor_Endowment(dest, h, state));

*{\\rm Average\\_Labor\\_Tax\\_Rate} = \\frac{\\rm Average\\_Labor\\_Tax}{\\sum_{\\rm Destinations} \\rm Labor\\_Endowment}
Average_Labor_Tax_Rate(h, state)$sum(dest, Labor_Endowment(dest, h, state)) = 
    Average_Labor_Tax(h, state) / sum(dest, Labor_Endowment(dest, h, state));





*Absorption(com, state)$(Absorption(com, state)<1e-6) = 0;
*Average_Labor_Tax_Rate(h, state)$(Average_Labor_Tax_Rate(h, state)<1e-6) = 0;
*Capital_Tax_Rate(sec, state)$(Capital_Tax_Rate(sec, state)<1e-6) = 0;
*Duty_Rate(com, state)$(Duty_Rate(com, state)<1e-6) = 0;
*FICA_Tax_Rate(h, state)$(FICA_Tax_Rate(h, state)<1e-6) = 0;
Labor_Supply(h, state)$(Labor_Supply(h, state)<1e-6) = 0;
Leisure_Consumption_Elas(h, state)$(Leisure_Consumption_Elas(h, state)<1e-6) = 0;
Leisure_Demand(h, state)$(Leisure_Demand(h, state)<1e-6) = 0;

*Marginal_Labor_Tax_Rate(h, state)$(Marginal_Labor_Tax_Rate(h, state)<1e-6) = 0;
*Output_Tax_Rate(sec, state)$(Output_Tax_Rate(sec, state)<1e-6) = 0;
Regional_Local_Supply(com, state)$(Regional_Local_Supply(com, state)<1e-6) = 0;
Regional_National_Supply(com, state)$(Regional_National_Supply(com, state)<1e-6) = 0;
*Tax_Rate(com, state)$(Tax_Rate(com, state)<1e-6) = 0;
Total_Supply(com, state)$(Total_Supply(com, state)<1e-6) = 0;


display Local_Demand, Local_Margin_Supply, Absorption;

* -------------------
* Balance Conditions
* -------------------

parameter zero_profit(sec, state);

zero_profit(sec, state) = sum(com, Intermediate_Supply(com, sec, state)) - (
    sum(com, Intermediate_Demand(com, sec, state)) + 
    Labor_Demand(sec, state) + 
    Capital_Demand(sec, state) +
    Output_Tax(sec, state) + 
    Capital_Tax(sec, state)
    );

display zero_profit;


parameter market_clearence(com, state);


market_clearence(com, state) = -sum(sec, Intermediate_Demand(com, sec, state)) -
    Investment_Final_Demand(com, state) -
    Government_Final_Demand(com, state) -
    sum(h, Personal_Consumption(com, h, state)) -
    Reexport(com, state) +
    National_Demand(com, state) +
    Local_Demand(com, state) +
    Import(com, state) +
    sum(mar, Margin_Demand(com, mar, state)) +
    Tax(com, state) +
    Duty(com, state);


display market_clearence;

parameter margin_balance(mar, state);

margin_balance(mar, state) = 
    sum(com, Margin_Demand(com, mar, state)) - 
    sum(com, Local_Margin_Supply(com, mar, state)) - 
    sum(com, National_Margin_Supply(com, mar, state));

display margin_balance;





execute_unload '%output_path%'
    com, dest, h, mar, sec, state, trn,

    Absorption,
    Average_Labor_Tax_Rate,
    Average_Labor_Tax,
    Capital_Demand,
    Capital_Demand,
    Capital_Tax_Rate,
    Capital_Tax,
    Duty_Rate,
    Duty,
    Export,
    FICA_Tax_Rate,
    FICA_Tax,
    Government_Deficit,
    Government_Final_Demand,
    Household_Interest,
    Household_Supply,
    Import,
    Intermediate_Demand,
    Intermediate_Supply,
    Investment_Final_Demand,
    Labor_Demand,
    Labor_Endowment,
    Labor_Supply_Income_Elas,
    Labor_Supply,
    Leisure_Consumption_Elas,
    Leisure_Demand,
    Leisure_Income_Elas,
    Local_Demand,
    Local_Margin_Supply,
    Margin_Demand,
    Marginal_Labor_Tax_Rate,
    Marginal_Labor_Tax,
    National_Demand,
    National_Margin_Supply,
    Output_Tax_Rate,
    Output_Tax,
    Personal_Consumption,
    Reexport,
    Regional_Local_Supply,
    Regional_National_Supply,
    Savings,
    Tax_Rate,
    Tax,
    Total_Supply,
    Transfer_Payment;
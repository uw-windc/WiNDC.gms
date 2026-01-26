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


$if not set file_path $set file_path "%system.fp%/data/national.gdx"

*---------------
* End of Options 
* --------------


* --------------
* Define Sets 
* --------------
set
    gfd  "Government portions of final demand",
    yr   "years",
    sec  "Sectors",
    com  "Commodities",
    ifd  "Investment portions of final demand",
    mar  "Margin sectors";

$gdxin %file_path%
$loaddc yr, gfd, sec, com, ifd, mar



parameter
    Duty(com, yr)                      "",
    Intermediate_Demand(com, sec, yr)  "",
    Subsidy(com, yr)                   "",
    Margin_Supply(com, mar, yr)        "Negative values in marginal categories",
    Investment_Final_Demand(com, ifd, yr) "",
    Tax(com, yr)                       "",
    Intermediate_Supply(com, sec, yr)  "",
    Government_Final_Demand(com, gfd, yr) "",
    Personal_Consumption(com, yr)      "Negative values in PCE (positive in USE table)",
    Sector_Subsidy(sec, yr)            "",
    Labor_Demand(sec, yr)              "",
    Capital_Demand(sec, yr)            "",
    Import(com, yr)                    "",
    Margin_Demand(com, mar, yr)        "Positive values in marginal categories",
    Household_Supply(com, yr)          "Positive values in PCE (negative in USE table)",
    Output_Tax(sec, yr)                "",
    Export(com, yr)                    "";

$gdxin %file_path%
$loaddc Duty, Intermediate_Demand, Subsidy, Margin_Supply, Investment_Final_Demand, Tax, Intermediate_Supply, Government_Final_Demand, Personal_Consumption, Sector_Subsidy, Labor_Demand, Capital_Demand, Import, Margin_Demand, Household_Supply, Output_Tax, Export




* --------------------
* Generated Parameters
* --------------------

parameter 
    Gross_Output(com, yr)		    Gross output,
    Armington_Supply(com, yr)		Armington supply,
    Balance_Payments(yr)    balance of payments,

	ty_0(sec, yr)	Policy output tax rate,
	ta_0(com, yr)	Policy tax net subsidy rate on intermediate demand,
    tm_0(com, yr)	Policy import tariff;


Gross_Output(com, yr) = 
    sum(sec, Intermediate_Supply(com, sec, yr)) +
    Household_Supply(com, yr) -
    sum(mar, Margin_Supply(com, mar, yr));

Armington_Supply(com, yr) =
    sum(gfd, Government_Final_Demand(com, gfd, yr)) +
    sum(ifd, Investment_Final_Demand(com, ifd, yr)) +
    Personal_Consumption(com, yr) +
    sum(sec, Intermediate_Demand(com, sec, yr));

Balance_Payments(yr) = 
    sum(com, Import(com, yr)) -
    sum(com, Export(com, yr));

ty_0(sec, yr)$sum(com, Intermediate_Supply(com, sec, yr)) = 
    (
        Output_Tax(sec, yr) +
        Sector_Subsidy(sec, yr)
    ) / 
    sum(com, Intermediate_Supply(com, sec, yr));

ta_0(com, yr)$Armington_Supply(com, yr) = 
    (
        Tax(com, yr) + 
        Subsidy(com, yr)
    ) /
    Armington_Supply(com, yr);

tm_0(com, yr)$Import(com, yr) = Duty(com, yr) / Import(com, yr);




* -------------------
* Balance Conditions
* -------------------

parameter 
    zero_profit(sec, yr)        "Zero profit condition for each sector and year",
    market_clearance(com, yr)   "Market clearance condition for each commodity and year",
    margin_balance(mar, yr)     "Margin balance condition for each margin sector and year";


zero_profit(sec, yr) = 
    sum(com, Intermediate_Demand(com, sec, yr)) +
    Labor_Demand(sec, yr) +
    Capital_Demand(sec, yr) +
    Output_Tax(sec, yr) +
    Sector_Subsidy(sec, yr) -
    sum(com, Intermediate_Supply(com, sec, yr));

market_clearance(com, yr) = 
    sum(sec, Intermediate_Demand(com, sec, yr)) +
    sum(gfd, Government_Final_Demand(com, gfd, yr)) +
    sum(ifd, Investment_Final_Demand(com, ifd, yr)) +
    Personal_Consumption(com, yr) +
    Export(com, yr) +
    sum(mar, Margin_Supply(com, mar, yr)) -
    sum(mar, Margin_Demand(com, mar, yr)) -
    sum(sec, Intermediate_Supply(com, sec, yr)) -
    Household_Supply(com, yr) -
    Import(com, yr) -
    Duty(com, yr) -
    Subsidy(com, yr) -
    Tax(com, yr);


margin_balance(mar, yr) = 
    sum(com, Margin_Supply(com, mar, yr)) -
    sum(com, Margin_Demand(com, mar, yr));

display zero_profit;
display market_clearance;
display margin_balance;
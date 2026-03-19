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

$if not set data_dir $set data_dir "%system.fp%../data"
$if not set file_name $set file_name "national.gdx"
$if not set output $set output "national_bea.gdx"
$set file_path "%data_dir%/%file_name%"
$set output_path "%data_dir%/%output%"

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
    Intermediate_Demand(com, sec, yr)       "Intermediate Demand portion of the Use table",
    Personal_Consumption(com, yr)           "Negative values in PCE (positive values in Use table)",
    Government_Final_Demand(com, gfd, yr)   "Government portions of final demand",
    Investment_Final_Demand(com, ifd, yr)   "Investment portions of final demand",
    Export(com, yr)                         "Exports",
    Labor_Demand(sec, yr)                   "Labor demand - NAICS code V001",
    Capital_Demand(sec, yr)                 "Capital demand - NAICS code V003",
    Output_Tax(sec, yr)                     "Output tax - NAICS code T00OTOP",
    Sector_Subsidy(sec, yr)                 "Sectoral subsidies - NAICS code T00SUB",
    Intermediate_Supply(com, sec, yr)       "Intermediate Supply portion of the Supply table",
    Household_Supply(com, yr)               "Positive values in PCE (negative in USE table)",
    Import(com, yr)                         "Imports",
    Duty(com, yr)                           "Import Duties",
    Subsidy(com, yr)                        "Subsidies",
    Tax(com, yr)                            "Taxes",
    Margin_Supply(com, mar, yr)             "Negative values in marginal categories",
    Margin_Demand(com, mar, yr)             "Positive values in marginal categories";
    
    
    

$gdxin %file_path%
$loaddc Duty, Intermediate_Demand, Subsidy, Margin_Supply, Investment_Final_Demand 
$loaddc Tax, Intermediate_Supply, Government_Final_Demand, Personal_Consumption 
$loaddc Sector_Subsidy, Labor_Demand, Capital_Demand, Import, Margin_Demand 
$loaddc Household_Supply, Output_Tax, Export




* --------------------
* Generated Parameters
* --------------------

parameter 
    Armington_Supply(com, yr)               "WiNDC-specific Armington supply",
    Gross_Output(com, yr)                   "WiNDC-specific Gross Output",
    Balance_Payments(yr)                    "WiNDC-specific Balance of Payments deficit",

    Output_Tax_Rate(sec, yr)                "Output tax rate",
    Tax_Rate(com, yr)                       "Tax rate",
    Tariff_Rate(com, yr)                    "Tariff rate";


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

Output_Tax_Rate(sec, yr)$sum(com, Intermediate_Supply(com, sec, yr)) = 
    (
        Output_Tax(sec, yr) +
        Sector_Subsidy(sec, yr)
    ) / 
    sum(com, Intermediate_Supply(com, sec, yr));

Tax_Rate(com, yr)$Armington_Supply(com, yr) = 
    (
        Tax(com, yr) + 
        Subsidy(com, yr)
    ) /
    Armington_Supply(com, yr);

Tariff_Rate(com, yr)$Import(com, yr) = Duty(com, yr) / Import(com, yr);




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


execute_unload '%output_path%' 
* Sets
    yr, gfd, sec, com,  ifd, mar,
    
    Intermediate_Demand,
    Personal_Consumption,
    Government_Final_Demand,
    Investment_Final_Demand,
    Export,
    Labor_Demand,
    Capital_Demand,
    Output_Tax,
    Sector_Subsidy,
    Intermediate_Supply,
    Household_Supply,
    Import,
    Duty,
    Subsidy,
    Tax,
    Margin_Supply,
    Margin_Demand,
    Gross_Output,
    Armington_Supply,
    Balance_Payments,
    Output_Tax_Rate,
    Tax_Rate,
    Tariff_Rate;
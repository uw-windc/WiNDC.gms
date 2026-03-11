$title Load the WiNDC national dataset

$OnText
    Currently hard coded to load from %data_dir%/household_bea.gdx
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"

*$if not set file_name $set file_name "national.gdx"
*$set file_path "%data_dir%/%file_name%"
*
*$if not set output $set output "national_windc.gdx"
*$set output_path "%data_dir%/%output%"

set
    com   "Commodities",
    dest  "Destinations",
    h     "Household categories",
    mar   "Margin sectors",
    sec   "Sectors",
    state "States",
    trn "Transfer types";

$gdxin '%data_dir%/household_bea.gdx'
$load  com, dest, h, mar, sec, state, trn


parameters
    Absorption(com, state)                  "",       
    Average_Labor_Tax(h, state)             "",
    Average_Labor_Tax_Rate(h, state)       "Policy average labor tax rate",
    Capital_Demand(sec, state)              "",
    Capital_Tax_Rate(sec, state)            "Policy capital tax rate",
    Capital_Tax(sec, state)                 "",
    Duty_Rate(com, state)                   "Policy import tariff",
    Duty(com, state)                        "",
    Export(com, state)                      "",
    FICA_Tax_Rate(h, state)                 "Policy FICA tax rate",
    FICA_Tax(h, state)                      "",
    Government_Deficit                      "",   
    Government_Final_Demand(com, state)     "",
    Household_Interest(h, state)            "",
    Household_Supply(com, state)            "",
    Import(com, state)                      "",
    Intermediate_Demand(com, sec, state)    "",
    Intermediate_Supply(com, sec, state)    "",
    Investment_Final_Demand(com, state)     "",
    Labor_Demand(sec, state)                "",
    Labor_Endowment(dest, h, state)         "",
    Labor_Supply_Income_Elas                "",           
    Labor_Supply(h, state)                  "",       
    Leisure_Consumption_Elas(h, state)      "",                   
    Leisure_Demand(h, state)                "",           
    Leisure_Income_Elas                     "",
    Local_Demand(com, state)                "",
    Local_Margin_Supply(com, mar, state)    "",
    Margin_Demand(com, mar, state)          "",
    Marginal_Labor_Tax_Rate(h, state)       "Policy labor tax rate",
    Marginal_Labor_Tax(h, state)            "",
    National_Demand(com, state)             "",
    National_Margin_Supply(com, mar, state) "",
    Output_Tax_Rate(sec, state)             "Policy output tax rate",
    Output_Tax(sec, state)                  "",
    Personal_Consumption(com, h, state)     "",
    Reexport(com, state)                    "",
    Regional_Local_Supply(com, state)       "",                   
    Regional_National_Supply(com, state)    "",                       
    Savings(h, state)                       "",
    Tax_Rate(com, state)                    "Policy tax net subsidy rate on intermediate demand",
    Tax(com, state)                         "",
    Total_Supply(com, state)                "",           
    Transfer_Payment(trn, h, state)       "";

$gdxin '%data_dir%/household_bea.gdx'
$loaddc Absorption, Average_Labor_Tax, Average_Labor_Tax_Rate, Capital_Demand, Capital_Tax
$loaddc Capital_Tax_Rate, Duty, Duty_Rate, Export, FICA_Tax, FICA_Tax_Rate
$loaddc Government_Deficit, Government_Final_Demand, Household_Interest
$loaddc Household_Supply, Import, Intermediate_Demand, Intermediate_Supply
$loaddc Investment_Final_Demand, Labor_Demand, Labor_Endowment, Labor_Supply
$loaddc Labor_Supply_Income_Elas, Leisure_Consumption_Elas, Leisure_Demand
$loaddc Leisure_Income_Elas, Local_Demand, Local_Margin_Supply, Margin_Demand
$loaddc Marginal_Labor_Tax, Marginal_Labor_Tax_Rate, National_Demand
$loaddc National_Margin_Supply, Output_Tax, Output_Tax_Rate, Personal_Consumption
$loaddc Reexport, Regional_Local_Supply, Regional_National_Supply, Savings, Tax
$loaddc Tax_Rate, Total_Supply, Transfer_Payment      


parameter report(*, *);

report("1", "RNS") = Regional_National_Supply("113FF", "Alaska");

display report;
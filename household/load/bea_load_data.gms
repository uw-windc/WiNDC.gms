$title Load the WiNDC Household dataset

$OnText
Load the Household dataset with BEA sets and parameters. This dataset matches
the WiNDCHousehold.jl dataset. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `household_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "household_bea.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

set
    com   "Commodities",
    dest  "Destinations",
    h     "Household categories",
    mar   "Margin sectors",
    sec   "Sectors",
    state "States",
    trn   "Transfer types";

$gdxin '%data_path%'
$load  com, dest, h, mar, sec, state, trn


parameters
    Average_Labor_Tax(h, state)             "Average Labor Tax ",
    Capital_Demand(sec, state)              "Capital Demand",
    Capital_Tax(sec, state)                 "Capital Tax",
    Duty(com, state)                        "Import Duty",
    Export(com, state)                      "Export",
    FICA_Tax(h, state)                      "FICA Tax",
    Government_Final_Demand(com, state)     "Government Final Demand",
    Household_Interest(h, state)            "Household Interest",
    Household_Supply(com, state)            "Household Supply",
    Import(com, state)                      "Import",
    Intermediate_Demand(com, sec, state)    "Intermediate Demand",
    Intermediate_Supply(com, sec, state)    "Intermediate Supply",
    Investment_Final_Demand(com, state)     "Investment Final Demand",
    Labor_Demand(sec, state)                "Labor Demand",
    Labor_Endowment(dest, h, state)         "Labor Endowment",
    Local_Demand(com, state)                "Local Demand",
    Local_Margin_Supply(com, mar, state)    "Local Margin Supply",
    Margin_Demand(com, mar, state)          "Margin Demand",
    Marginal_Labor_Tax(h, state)            "Marginal Labor Tax",
    National_Demand(com, state)             "National Demand",
    National_Margin_Supply(com, mar, state) "National Margin Supply",
    Output_Tax(sec, state)                  "Output Tax",
    Personal_Consumption(com, h, state)     "Personal Consumption",
    Reexport(com, state)                    "Reexport",
    Savings(h, state)                       "Savings",
    Tax(com, state)                         "Tax",
    Transfer_Payment(trn, h, state)         "Transfer Payment",

    Regional_National_Supply(com, state)    "Regional National Supply",
    Regional_Local_Supply(com, state)       "Regional Local Supply",
    Total_Supply(com, state)                "Total Supply",
    Absorption(com, state)                  "Absorption",
    Labor_Supply(h, state)                  "Labor Supply",
    Leisure_Consumption_Elas(h, state)      "Leisure Consumption Elasticity",
    Leisure_Demand(h, state)                "Leisure Demand",
    Government_Deficit                      "Government Deficit",

    Labor_Supply_Income_Elas                "Labor Supply Income Elasticity - Default 0.05",
    Leisure_Income_Elas                     "Leisure Income Elasticity - Default 0.2",

    Output_Tax_Rate(sec, state)            "Policy output tax rate",
    Tax_Rate(com, state)                   "Policy tax net subsidy rate on intermediate demand",
    Duty_Rate(com, state)                  "Policy import tariff",
    Capital_Tax_Rate(sec, state)           "Policy capital tax rate",
    FICA_Tax_Rate(h, state)                "Policy FICA tax rate",
    Marginal_Labor_Tax_Rate(h, state)      "Policy labor tax rate",
    Average_Labor_Tax_Rate(h, state)       "Policy average labor tax rate";


$gdxin '%data_path%'
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

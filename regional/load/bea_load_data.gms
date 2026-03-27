$title Load the WiNDC Regional dataset

$OnText
Load the Regional dataset with BEA sets and parameters. This dataset matches
the WiNDCRegional.jl dataset. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "regional_bea.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

*---------------
* End of Options 
* --------------

set
    yr    "years",
    sec   "Sectors",
    com   "Commodities",
    state "States",
    mar   "Margin sectors";

$gdxin '%data_dir%/regional_bea.gdx'
$load yr, state, sec, com, mar

 
parameters
    Capital_Demand(sec, state, yr)              "",
    Export(com, state, yr)                      "",
    Government_Final_Demand(com, state, yr)     "",
    Household_Supply(com, state, yr)            "",
    Import(com, state, yr)                      "",
    Intermediate_Demand(com, sec, state, yr)    "",
    Intermediate_Supply(com, sec, state, yr)    "",
    Investment_Final_Demand(com, state, yr)     "",
    Labor_Demand(sec, state, yr)                "",
    Local_Demand(com, state, yr)                "",
    Local_Margin_Supply(com, mar, state, yr)    "",
    Margin_Demand(com, mar, state, yr)          "",
    Margin_Supply(com, mar, state, yr)          "",
    National_Demand(com, state, yr)             "",
    National_Margin_Supply(com, mar, state, yr) "",
    Personal_Consumption(com, state, yr)        "",
    Reexport(com, state, yr)                    "",
    Regional_Local_Supply(com, state, yr)       "",
    Netports(com, state, yr)                    "",
    Total_Supply(com, state, yr)                "",
    Regional_National_Supply(com, state, yr)    "",
    Absorption(com, state, yr)                  "",
    Balance_of_Payments(state, yr)              "",
    Household_Adjustment(state, yr)             "",
    Output_Tax_Rate(sec, state, yr)             "",
    Tax_Rate(com, state, yr)                    "",
    Tariff_Rate(com, state, yr)                 "";

$gdxin '%data_dir%/regional_bea.gdx'
$loaddc Capital_Demand, Export, Government_Final_Demand, Household_Supply, Import,
$loaddc Intermediate_Demand, Intermediate_Supply, Investment_Final_Demand, Labor_Demand,
$loaddc Local_Demand, Local_Margin_Supply, Margin_Demand, Margin_Supply, National_Demand,
$loaddc National_Margin_Supply, Personal_Consumption, Reexport, Regional_Local_Supply,
$loaddc Netports, Total_Supply, Regional_National_Supply, Absorption, Balance_of_Payments,
$loaddc Household_Adjustment, Output_Tax_Rate, Tax_Rate, Tariff_Rate


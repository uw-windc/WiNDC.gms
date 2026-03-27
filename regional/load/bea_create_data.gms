$title Create the WiNDC Regional dataset

$OnText
Create the Regional dataset with sets and parameters that match WiNDCRegional.jl 
dataset. Uses NAICS codes for sectors and commodities.

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `regional.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
    - `output` - Name of the output GDX file. Default is `regional_bea.gdx`.

Example:

    gams load_data --data_dir "path/to/data" --data_file "my_data.gdx"

$OffText

$if not set data_dir $set data_dir "%system.fp%../data"

$if not set data_file $set data_file "regional.gdx"
$set data_path "%data_dir%/%data_file%"

$if not set output $set output "regional_bea.gdx"
$set output_path "%data_dir%/%output%"


* --------------
* Define Sets 
* --------------
set
    yr    "years",
    sec   "Sectors",
    com   "Commodities",
    state "States",
    mar   "Margin sectors";

$gdxin %data_path%
$loaddc yr, sec, com, state, mar

parameter
    Capital_Demand(sec, state, yr)              "",
    Duty(com, state, yr)                        "",
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
    Output_Tax(sec, state, yr)                  "",
    Personal_Consumption(com, state, yr)        "",
    Reexport(com, state, yr)                    "",
    Tax(com, state, yr)                         "";

$gdxin %data_path%
$loaddc Capital_Demand, Duty, Export, Government_Final_Demand, Household_Supply
$loaddc Import, Intermediate_Demand, Intermediate_Supply, Investment_Final_Demand
$loaddc Labor_Demand, Local_Demand, Local_Margin_Supply, Margin_Demand
$loaddc Margin_Supply, National_Demand, National_Margin_Supply, Output_Tax
$loaddc Personal_Consumption, Reexport, Tax




* --------------------
* Aggregate Parameters
* --------------------

parameters
    Regional_Local_Supply(com, state, yr)       "",
    Netports(com, state, yr)                    "",
    Total_Supply(com, state, yr)                "",
    Regional_National_Supply(com, state, yr)    "",
    Absorption(com, state, yr)                  "",
    Balance_of_Payments(state, yr)              "",
    Household_Adjustment(state, yr)        "";
    


Regional_Local_Supply(com, state, yr) = sum(mar, Local_Margin_Supply(com, mar, state, yr)) + Local_Demand(com, state, yr);
Netports(com, state, yr) = Export(com, state, yr) - Reexport(com, state, yr);
Total_Supply(com, state, yr) = sum(sec, Intermediate_Supply(com, sec, state, yr)) + Household_Supply(com, state, yr);
Regional_National_Supply(com, state, yr) = Total_Supply(com, state, yr) - Netports(com, state, yr) - Regional_Local_Supply(com, state, yr);
Absorption(com, state, yr) = sum(sec, Intermediate_Demand(com, sec, state, yr)) + Personal_Consumption(com, state, yr) + Investment_Final_Demand(com, state, yr) + Government_Final_Demand(com, state, yr);
Balance_of_Payments(state, yr) = sum(com, Import(com, state, yr) - Export(com, state, yr));

Household_Adjustment(state, yr) = sum(com, Personal_Consumption(com, state, yr)) +
    sum(com, Investment_Final_Demand(com, state, yr)) + 
    sum(com, Government_Final_Demand(com, state, yr)) -
    Balance_of_Payments(state, yr) -
    sum(com, Household_Supply(com, state, yr)) -
    sum(com, Tax(com, state, yr)) -
    sum(com, Duty(com, state, yr)) -
    sum(sec, Labor_Demand(sec, state, yr)) -
    sum(sec, Capital_Demand(sec, state, yr))  -
    sum(sec, Output_Tax(sec, state, yr));


* ------------
* Tax Rates
* ------------

parameter
    Output_Tax_Rate(sec, state, yr) "",
    Tax_Rate(com, state, yr)        "",
    Tariff_Rate(com, state, yr)       "";

Output_Tax_Rate(sec, state, yr)$(sum(com, Intermediate_Supply(com, sec, state, yr))) = Output_Tax(sec, state, yr) / sum(com, Intermediate_Supply(com, sec, state, yr));
Tax_Rate(com, state, yr)$(Absorption(com, state, yr)) = Tax(com, state, yr) / Absorption(com, state, yr);
Tariff_Rate(com, state, yr)$(Import(com, state, yr)) = Duty(com, state, yr) / Import(com, state, yr);

execute_unload "%output_path%" 
* Sets
    yr, sec, com, state, mar,

* Parameters
    Capital_Demand,
    Export,
    Government_Final_Demand,
    Household_Supply,
    Import,
    Intermediate_Demand,
    Intermediate_Supply,
    Investment_Final_Demand,
    Labor_Demand,
    Local_Demand,
    Local_Margin_Supply,
    Margin_Demand,
    Margin_Supply,
    National_Demand,
    National_Margin_Supply,
    Personal_Consumption,
    Reexport,
    Regional_Local_Supply,
    Netports,
    Total_Supply,
    Regional_National_Supply,
    Absorption,
    Balance_of_Payments,
    Household_Adjustment,
    Output_Tax_Rate,
    Tax_Rate,
    Tariff_Rate;
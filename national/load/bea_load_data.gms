$title Load the WiNDC National dataset

$OnText
Load the National dataset with BEA sets and parameters. This dataset matches
the WiNDCNational.jl dataset. 

Options:

    - `data_dir` - Directory where the data file is located. Default is 
                    `../data/` relative to the GAMS file.
    - `data_file` - Name of the GDX file containing the data. Default is 
                    `national_bea.gdx`.
    - `data_path` - Full path to the GDX file. If not set, it will be 
                    constructed from `data_dir` and `data_file`.
$OffText

$if not set data_dir $set data_dir "%system.fp%/../data"
$if not set data_file $set data_file "national_bea.gdx"

$if not set data_path $set data_path "%data_dir%/%data_file%"

*---------------
* End of Options 
* --------------

set
    gfd  "Government portions of final demand",
    yr   "Years",
    sec  "Sectors",
    com  "Commodities",
    ifd  "Investment portions of final demand",
    mar  "Margin sectors";

$gdxin '%data_path%'
$load yr, gfd, sec, com, ifd, mar


parameters
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
    Margin_Demand(com, mar, yr)             "Positive values in marginal categories",

    Armington_Supply(com, yr)               "WiNDC-specific Armington supply",
    Gross_Output(com, yr)                   "WiNDC-specific Gross Output",
    Balance_Payments(yr)                    "WiNDC-specific Balance of Payments deficit",

    Output_Tax_Rate(sec, yr)                "Output tax rate",
    Tax_Rate(com, yr)                       "Tax rate",
    Tariff_Rate(com, yr)                    "Tariff rate";

$gdxin '%data_path%'
$loaddc Intermediate_Demand, Personal_Consumption, Government_Final_Demand, 
$loaddc Investment_Final_Demand, Export, Labor_Demand, Capital_Demand, 
$loaddc Output_Tax, Sector_Subsidy, Intermediate_Supply, Household_Supply, Import, 
$loaddc Duty, Subsidy, Tax, Margin_Supply, Margin_Demand, Output_Tax_Rate, 
$loaddc Tax_Rate, Tariff_Rate, Armington_Supply, Gross_Output, Balance_Payments

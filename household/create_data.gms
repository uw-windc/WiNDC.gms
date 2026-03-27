$title Create the WiNDC Household datasets

$ontext
Run each `create` file in the `load` directory to create the GDX files for 
the WiNDC Household datasets. The data will be loaded from the `data` directory 
and the log files will be saved to the `lst` directory.

Options:

    - `data_dir` - Directory where the input data files are located. Default is `data/`.
    - `lst_dir` - Directory where the log files will be saved. Default is `lst/`.
    - `notation` - Which dataset to create. Options are "BEA", "WiNDC", and "legacy_windc". 
                If this is not set, create all datasets.
$offtext

$if not set data_dir $set data_dir "%system.fp%data"
$if not set lst_dir  $set lst_dir "%system.fp%lst"

$if not dexist %lst_dir%   $call mkdir %lst_dir%

$if set notation $goto %notation%

* ==============
* BEA dataset
* ==============
$label BEA

$if not set output $set output "household_bea.gdx"
$set output_path "%data_dir%/%output%"

$if not exist %output_path% $call 'gams load/bea_create_data.gms o="%lst_dir%bea_create_data.lst" --data_dir=%data_dir%'

$if set notation $exit

* ==============
* WiNDC dataset
* ==============
$label WiNDC

$set output "household_windc.gdx"
$set output_path "%data_dir%/%output%"

$if not exist "%data_dir%/household_bea.gdx" $call 'gams load/bea_create_data.gms o="%lst_dir%bea_create_data.lst" --data_dir=%data_dir%'
$if not exist %output_path% $call 'gams load/windc_create_data.gms o="%lst_dir%windc_create_data.lst" --data_dir=%data_dir%'

$if set notation $exit

* ==============
* Legacy WiNDC dataset
* ==============
$label legacy_windc

$set output "household_legacy_windc.gdx"
$set output_path "%data_dir%/%output%"

$if not exist "%data_dir%/household_bea.gdx" $call 'gams load/bea_create_data.gms o="%lst_dir%bea_create_data.lst" --data_dir=%data_dir%'
$if not exist %output_path% $call 'gams load/legacy_windc_create_data.gms o="%lst_dir%legacy_windc_create_data.lst" --data_dir=%data_dir%'

$if set notation $exit
$title Load the WiNDC Regional dataset

$ontext



$offtext

* First, ensure the BEA data is loaded

$if not set data_dir $set data_dir "%system.fp%data"
$if not set lst_dir  $set lst_dir "%system.fp%lst"

$if not dexist %lst_dir%   $call mkdir %lst_dir%

$if not set file_name $set file_name "regional.gdx"
$set file_path "%data_dir%/%file_name%"

$if not set output $set output "regional_bea.gdx"
$set output_path "%data_dir%/%output%"

* Step 1: Download the data if it does not exist (To Do)

* Step 2: Create the BEA data file if it does not exist

$if not exist %output_path% $call 'gams load/bea_create_data.gms o="%lst_dir%bea_create_data.lst" --data_dir=%data_dir%'


$exit

$set output "regional_windc.gdx"
$set output_path "%data_dir%/%output%"

$if not exist %output_path% $call 'gams load/windc_create_data.gms o="%lst_dir%windc_create_data.lst" --data_dir=%data_dir%'


$set output "regional_legacy_windc.gdx"
$set output_path "%data_dir%/%output%"

$if not exist %output_path% $call 'gams load/legacy_windc_create_data.gms o="%lst_dir%legacy_windc_create_data.lst" --data_dir=%data_dir%'
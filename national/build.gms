
$ONTEXT

Options:

    1. BEA - Use BEA NAICS codes
    2. WiNDC - Use WiNDC aggregated codes

$OFFTEXT



$if not set notation $set notation "BEA"
$if not set data_dir $set data_dir "data/"
$if not set lst_dir  $set lst_dir "lst/"

$if not dexist data   $call mkdir data
$if not dexist lst    $call mkdir lst



* Step 1: Download the data if it does not exist

$call 'gams get_data.gms --data_dir=%data_dir% --module=national --version=4.2.0'


* Step 2: Create the data files if they do not exist

$call 'gams create_data.gms --lst_dir=%lst_dir% --data_dir=%data_dir% o="%lst_dir%create_data.lst"'


* Step 3: Verify benchmark national model

*--notation=%notation%
$call 'gams model.gms --data_dir=%data_dir% --lst_dir=%lst_dir% o="%lst_dir%model_%notation%.lst"'
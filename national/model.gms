$title Load the WiNDC national dataset

$ontext



$offtext

*$if not set notation  $set notation "BEA"
$if not set data_dir  $set data_dir "%system.fp%/data/"
$if not set lst_dir   $set lst_dir "%system.fp%/lst/"
$if not set model_dir $set model_dir "%system.fp%/models/"

$if set notation $goto %notation%

$label BEA
$set script "bea_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'

$if set notation $exit


$label WiNDC
$set script "windc_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'

$if set notation $exit
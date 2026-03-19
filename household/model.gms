$title Load the WiNDC national dataset

$ontext
Download data from the WiNDC website. If the data already exists in the specified data directory,
no download is performed.

Command Line Arguments:

- data_dir: Directory to store downloaded data files. Default is "data/".
- lst_dir: Where to store GAMS lst files. Default is "lst/".
- model_dir: The directory where the model files are located. Default is "models/".

Example usage:

    gams model.gms --notation=BEA
$offtext

*$if not set notation  $set notation "legacy_windc"
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


$label legacy_windc
$set script "legacy_windc_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'
$if set notation $exit
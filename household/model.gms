$title Run the Household models for the WiNDC datasets

$ontext
Command Line Arguments:

- data_dir - Data Directory. Default is "data/".
- lst_dir - Where to store GAMS lst files. Default is "lst/".
- model_dir - The directory where the model files are located. Default is "models/".
- notation - Which dataset to use. Options are "BEA", "WiNDC", and "legacy_windc"
            If this is not set, run all models.
Example usage:

    gams model.gms --notation=BEA
$offtext

$if not set data_dir  $set data_dir "%system.fp%/data/"
$if not set lst_dir   $set lst_dir "%system.fp%/lst/"
$if not set model_dir $set model_dir "%system.fp%/models/"

$if set notation $goto %notation%

* ==============
* BEA dataset
* ==============

$label BEA
$set script "bea_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'

$if set notation $exit

* ==============
* WiNDC dataset
* ==============

$label WiNDC
$set script "windc_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'

$if set notation $exit

* ==============
* Legacy WiNDC dataset
* ==============

$label legacy_windc
$set script "legacy_windc_model"

$call 'gams %model_dir%%script%.gms o="%lst_dir%%script%.lst"'
$if set notation $exit
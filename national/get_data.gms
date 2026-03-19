$title Download data, if necessary

$OnText
Download data from the WiNDC website. If the data already exists in the specified data directory,
no download is performed.

Command Line Arguments:

- data_dir: Directory to store downloaded data files. Default is "data/".
- module: Module name to download. Default is "national".
- version: Version of the data to download. Default is "4.2.0".

Example usage:

    gams get_data.gms --data_dir=data/ --module=national --version=4.2.0
$OffText


$if not set module $set module national
$if not set version $set version 4.2.0

$set url "https://beta.windc.wisc.edu/data/%module%/%version%/gdx"
$set data_dir "data"

$if not dexist %data_dir%   $call mkdir %data_dir%

$set output_path "%data_dir%/%module%.gdx"

$if not exist %output_path% $call 'curl -L -o %output_path% %url%'

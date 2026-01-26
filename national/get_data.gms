$title Download data, if necessary

* Bug on sever side. Will fix soon.

$if not set output $set output "national.gdx"
$if not set version $set version "4.2.0"

$set url "https://beta.windc.wisc.edu/data/4.2.0/national/gdx"
$set base_dir "data"

$if not dexist %base_dir%   $call mkdir %base_dir%


$set output_path "%base_dir%/%output%"

$call 'curl -o %output_path% -L %url%'

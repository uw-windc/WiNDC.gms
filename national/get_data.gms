$title Download data, if necessary

$if not set O $set O "national_data.gdx"


$set url "http://phillipsonhome.com/data/national"
$set base_dir "%system.fp%/../data"


$set output_path "%base_dir%/%O%"

$call 'powershell.exe -command "wget -O %output_path% %url%"'
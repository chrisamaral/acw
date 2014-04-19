<?php
exec("rm -R public/js/build/*");
chdir(realpath(dirname(__FILE__)));
function compile_js($path){
    $output = str_replace('client/', 'public/js/build/', $path);
    $file = pathinfo($output);
    if(!file_exists($file['dirname'])){
    mkdir($file['dirname'], 0777, true);
    }
    $cmd = "closure --js={$path} --js_output_file={$output}";
    echo "$cmd\n";
    system($cmd);
}

$jsFiles = explode("\n", trim(shell_exec("find client/ -name '*.js'")));
foreach($jsFiles as $path){
    compile_js($path);
}
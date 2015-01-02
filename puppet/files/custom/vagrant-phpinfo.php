
<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Laravel Vagrant LAMP Box</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- 
        <link href="./css/bootstrap.min.css" rel="stylesheet" />
        <link href="./css/font-awesome.min.css" rel="stylesheet">
        -->
        <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
        <link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet" />
        <style type="text/css">
            html, body {
                height: 100%;
            }
            #wrap {
                min-height: 100%;
                height: auto !important;
                height: 100%;
                margin: 0 auto -60px;
            }
            #push, #footer {
                height: 60px;
            }
            #footer {
                background-color: #f5f5f5;
            }
            @media (max-width: 767px) {
                #footer {
                    margin-left: -20px;
                    margin-right: -20px;
                    padding-left: 20px;
                    padding-right: 20px;
                }
            }
            .container {
                width: auto;
                max-width: 680px;
            }
            .container .credit {
                margin: 20px 0;
            }
            .page-header i {
                float: left;
                margin-top: -5px;
                margin-right: 12px;
            }
            table td:first-child {
                width: 300px;
            }
            .fa-icon-color-green {
                color: green;
            }
            .fa-icon-color-red {
                color: red;
            }
        </style>
    </head>
    <body>
        <div id="wrap">
            <div class="container">
                <div class="page-header">
                    <div class="jumbotron">
                        <i class="fa fa-lightbulb-o fa-3x"></i>
                        <div class="info">
                            <h2>Congratulations!</h2>
                            <p class="lead">Your Laravel Vagrant LAMP box is working!</p>
                        </div> 
                   </div>
                </div>
                <h3>Basic Configuration Information</h3>                
                <div class="row">
                    <div class="col-md-4">PHP Version</div>
                    <div class="col-md-8"><?php echo phpversion(); ?></div>
                </div>
                <div class="row">
                    <div class="col-md-4">MySQL Version</div>
                    <div class="col-md-8">
                        <?php 
                            $mysql = mysql_connect('localhost', 'root', '');
                            if (!$mysql) {
                                echo "<p class='error'><i class='fa fa-exclamation-circle'></i>";
                                echo "&nbsp;Error connecting to MySQL!" . PHP_EOL;
                                echo mysql_error();
                                echo "</p>";
                            } else {
                                
                                echo mysql_get_server_info();
                            }
                        ?>
                    </div>
                </div>
                <h3>PHP Environment Information</h3>
                <div class="row">
                    <div class="col-md-4">PHP Modules</div>
                    <div class="col-md-8">
                        <i class="fa fa-<?php echo (class_exists('mysqli') ? 'check fa-icon-color-green' : 'times fa-icon-color-red'); ?>"></i>&nbsp;MySQL<br />
                        <i class="fa fa-<?php echo (function_exists('curl_init') ? 'check fa-icon-color-green' : 'times fa-icon-color-red'); ?>"></i>&nbsp;CURL<br />
                        <i class="fa fa-<?php echo (function_exists('mcrypt_encrypt') ? 'check fa-icon-color-green' : 'times fa-icon-color-red'); ?>"></i>&nbsp;mcrypt<br />
                        <i class="fa fa-<?php echo (function_exists('xdebug_get_code_coverage') ? 'check fa-icon-color-green' : 'times fa-icon-color-red'); ?>"></i>&nbsp;XDebug<br />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-4">PHP .ini Files</div>
                    <div class="col-md-8">
                        <?php echo php_ini_loaded_file() . '<br />'; echo php_ini_scanned_files() . '<br />'; ?>
                    </div>
                </div>
            </div>
        </div>
                <div id="footer" class="footer">
                    <div class="container">
                        <p class="muted pull-right"><strong><a href="https://github.com/TimothyDJones/laravel-precise32-php5.4">Laravel Vagrant LAMP Box</a></strong></p>
                    </div>
                    
                </div>        
    </body>
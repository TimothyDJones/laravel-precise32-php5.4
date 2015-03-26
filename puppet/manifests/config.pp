class config {

	# Database settings
	$root_password = ""	# Leave 'root' password blank.  We set up PHPMyAdmin (later) to work with no 'root' password.  :)
	$laravel_db_user = ""	# Specify user name for 'laravel' database.  If not specified, will use 'root'.
	$laravel_db_pw = ""	# Specify the password to use for 'laravel' database, if desired.
	
	# Installation flags
	$phpmyadmin = true	# PHPMyAdmin - http://phpmyadmin.net/
	$xdebug = true		# PHP XDebug module - http://xdebug.org/
	$composer = true	# PHP Composer utility - http://getcomposer.org/
	$laravel = true		# Laravel framework - http://laravel.com/
	$php_version = "5.4"	# Or use "5.5", if desired.
	$laravel_version = "4.2"	# Other valid values: "4.1", "5.0"
	
	$filepath = "/vagrant/puppet/files"
	
	# PHP settings
	$extra_php_packages = [
		
	]
	
	# Include any additional packages that you'd like to install.
	# These will be installed by the 'addons' class.
	$extra_packages = [
		"mc",		# Example:  "Midnight Commander" file manager
	]

	
}
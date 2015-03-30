
# Set paths for Linux commands on virtual machine
Exec {
	path => ["/usr/bin", "/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin"]
}

# Load settings (configuration parameters) from file ('config.pp' in same directory as this file).
include config


# Include (add) the other modules in sequence to execute them.
include bootstrap
include addons
if $config::php_version == "5.4" {
	include php54	# Specific process to add PHP 5.4 third-party repository.
}

if $config::php_version == "5.5" {
	include php55	# Or use third-party repository for PHP 5.5.
}
include php
include apache
include mysql
if $config::xdebug == true {
	include xdebug
}
if $config::phpmyadmin == true {
	include phpmyadmin
}

# Install Laravel and its dependencies, such as Composer.
if $config::composer == true {
	include composer
	
	if $config::laravel == true {
		include laravel
	}
}


#include default
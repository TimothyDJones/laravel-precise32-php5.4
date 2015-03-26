class php {
	$packages = [
		"php5",
		"php5-cli",
		"php5-curl",
		"php5-mysql",
		"php5-mcrypt",
		"libapache2-mod-php5",
		"php5-mcrypt",
		"php5-xdebug"
	]
	
	# Add any other packages specified by user.
	$packages += $config::extra_php_packages
	
	package {
		$packages:
			ensure => latest,
			require => [
				Exec["apt-get-update"],
				Package["python-software-properties"]
			]
	}
}
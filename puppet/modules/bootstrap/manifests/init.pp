class bootstrap {
	group {
		"puppet":
			ensure => "present",
	}
	
	# Upgrade base packages on virtual machine
	if $config::upgrade_packages == true {
		exec { "apt-get-upgrade":
			require => Exec["apt-get-update"],
			command => "/usr/bin/sudo /usr/bin/apt-get upgrade -y",
			timeout => 1800,	# Command time out of 30 ***minutes***, because upgrades can take significant amount of time!
		}
	}
}
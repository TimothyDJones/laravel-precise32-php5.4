class bootstrap {
	group {
		"puppet":
			ensure => "present",
	}
	
	
	
	# Upgrade base packages on virtual machine
	if $config::upgrade_packages == true {
		exec { "upgrade-packages":
			command => "/usr/bin/sudo /usr/bin/apt-mark hold grub-pc ; /usr/bin/sudo /usr/bin/apt-get update ; /usr/bin/sudo /usr/bin/apt-get -f -y install ; /usr/bin/sudo /usr/bin/apt-get upgrade -y",
			timeout => 1800,	# Command time out of 30 ***minutes***, because upgrades can take significant amount of time!
		}
	}
	
	# Otherwise, do ***NOT*** upgrade, but update packages.
	if $config::upgrade_packages == false {
		exec { "upgrade-packages":
			command => "/usr/bin/sudo /usr/bin/apt-mark hold grub-pc ; /usr/bin/sudo /usr/bin/apt-get update ; /usr/bin/sudo /usr/bin/apt-get -f -y install",
		}
			
	}
	
	# Update repository lists on virtual machine
	exec { "apt-get-update":
		require => Exec["upgrade-packages"],
		command => "/usr/bin/sudo /usr/bin/apt-get update ; /usr/bin/sudo /usr/bin/apt-get -f -y install",
	}	
}
This is a basic LAMP setup for [Laravel](http://laravel.com) 4 PHP framework using [Vagrant](http://vagrantup.com) and [Puppet](http://puppetlabs.com/).

## Prerequisites
This repository provides a Vagrant box (virtual machine or VM) with Linux, Apache 2, MySQL 5.5, and PHP 5.4 (so-called **LAMP**) for web development, along with the basic Laravel framework.  It requires that you have two other applications already installed.
* [Virtualbox](http://virtualbox.org/) - An application that acts like a computer completely in software.
* [Vagrant](http://vagrantup.org/) - A system of creating and managing Virtualbox VM instances for development.  (This configuration should run on any version of Vagrant numbered 1.3 or greater.)

Both Virtualbox and Vagrant are open-source (free) and available for the three most common platforms:  Windows, Mac OS X, and Linux.  See their web sites for information about downloading and installing them for your particular platform and configuration.

Also, since Windows does *not* come with a built-in [SSH](https://en.wikipedia.org/wiki/Secure_Shell) client, you will need to obtain a separate SSH client, such as [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/), which is free/open-source.  To connect to your Vagrant box (once it's running!) from an external SSH client, use these settings:
* hostname: `localhost`
* port: `2222`  (By default, Vagrant forwards port 22, the default SSH port, to port 2222 on the host.)
* username: `vagrant`
* password: `vagrant`

On Mac OS X and Linux, you can connect to the Vagrant box using the `vagrant ssh` command, which will automatically log you in with the `vagrant` username.

## Vagrantfile
This file contains the basic setup for Vagrant.  This configuration uses the ["precise32" box](https://vagrantcloud.com/hashicorp/boxes/precise32) based on Ubuntu 12.04 LTS.

There are two sections in this file that are of primary importance to us.

### Port Forwarding
The first one is the port fowarding section. It allows us to access our Vagrant box from **outside** the box. For this example, we've opened up two ports: 80 and 3306.

    config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :forwarded_port, guest: 3306, host: 33060

* **Port 80** is the Apache web server porton the VM (virtual machine), but to access it from outside of Vagrant (i.e., via web browser on the host machine), you will have to use the forwarded port: **8080**. Load up a web browser and put in http://127.0.0.1:8080/ (or http://localhost:8080/) to interact with the website on the Vagrant box.  [Alternately, you can define an alias, such as **laravel.dev**, for the web server on the Vagrant VM, so that you don't have to use a special port to access the web server.]
* **Port 3306** is for MySQL on the VM (virtual machine). We forward it to **33060** so we can access the Vagrant MySQL instance using external MySQL applications (i.e., on the host machine), such as [DBeaver](http://dbeaver.jkiss.org/).

### Synced (Shared) Folders
The next section synced (previously called 'shared') folders section.  As you are probably recall, [the Laravel `apps/storage` folder must have full read-write permissions](http://laravel.com/docs/installation#configuration) so that the application can save files, such as logs, session cookies, etc.  Likewise, the Laravel `public` folder must be owned by the account that the Apache web server runs under, which is `www-data`	in Ubuntu.

Thus, we have three entries in the synced folder sections to enable the appropriate permissions.  The "base" setting is to synchronize between the directory (folder) where `Vagrantfile` is located.  This includes all of the sub-directories.  In addition, the other two sections set the permissions of the "special" directories for Laravel to function properly.

### Puppet
The final section we care about in the Vagrantfile is the Puppet configuration. Puppet allows us to automatically provision our Vagrant box with different packages and configurations for Apache, MySQL, PHP, etc.

This section tells Vagrant that the Puppet configuration file is called `default.pp` and can be found in `/puppet/manifests` folder.

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file  = "default.pp"
    end

For a more complete description how the Vagrantfile works or to customize your box, go to http://docs.vagrantup.com/v2/getting-started/index.html.

## puppet/manifests/default.pp
This file contains the default manifest for Puppet, which lets it know how to configure the Vagrant box.

This Vagrant box uses PHP 5.4, which is the most commonly version of PHP available on shared hosting platforms (and the lowest version supported by Laravel 4.x), from the [PHP 5.4 PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php5-oldstable).  You can replace PHP 5.4 with PHP **5.5** by using the [PHP 5.5 PPA](https://launchpad.net/~ondrej/+archive/ubuntu/php5) instead.

There are a few things going on in here, first of which is the package listings. Since we are setting up a LAMP environment, we need to install a few things. Thankfully, Puppet makes this very easy. Whenever the Vagrant box is started or provisioned, Puppet ensures the following packages are installed.

### Puppet Packages
* mysql-client
* mysql-server
* php5
* php5-curl
* php5-mysql
* php5-cli
* apache2
* libapache2-mod-php5
* php5-mcrypt (required for Laravel)
* php5-xdebug (using default port of 9000)
* vim
* [Composer](http://getcomposer.org/)
* [Laravel 4.2](http://laravel.com/docs/4.2/)

### Configuration File Management
After these packages are installed, we need to ensure the configurations are consistent and usable. Using the `file` parameter, we can tell Puppet to ensure that our MySQL and Apache configuration files are always the same as the local versions of those files. In this case `puppet/files/mysql/my.cnf` and `puppet/files/apache/default` respectively.
```puppet
    file { "/etc/mysql/my.cnf":
        notify => Service["mysql"],
        mode => 644,
        owner => "root",
        group => "root",
        require => Package["mysql-server"],
        source => "/vagrant/puppet/files/mysql/my.cnf"
    }
```

### Process Management
Puppet also ensures that Apache and MySQL are always running, using the `exec` parameter:
```puppet
    service { "mysql":
        ensure => running, 
        require => Package["mysql-server"]
    }
```

### MySQL User Provisioning
In the case of MySQL, Puppet also has to run a shell command to ensure there is a root user with no password that can be accessed from **outside** Vagrant (in the case of DBeaver, or other MySQL clients).
```puppet
    exec { "create-db-schema-and-user":
        command => "/usr/bin/mysql -uroot -e \"CREATE DATABASE IF NOT EXISTS laravel; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '' WITH GRANT OPTION; FLUSH PRIVILEGES;\"",
        require => Service["mysql"]
    }
```

### Laravel Provisioning
The final portions of the Puppet provisioning configuration installs Composer and Laravel framework itself.  Laravel is installed on the Vagrant box to the `/vagrant/laravel` directory, which is automatically synced with the `laravel` folder in the Vagrant box folder of the host machine.  This allows you to edit your Laravel-based web site using the files in the `laravel`.

For more information on Puppet, check out their documentation at http://docs.puppetlabs.com/.

### XDebug Configuration
The Vagrant configuration includes [XDebug](http://xdebug.org/), the *de facto* debugging standard for PHP.  Configuring [remote debugging using XDebug](http://xdebug.org/docs/remote) can be a little tricky, so here are some basic instructions on getting it going.  Basically, there are two steps in the process:  configuration on the Vagrant box and configuration on the host machine and the IDE on the host machine.

#### Vagrant Box Configuration
As noted above, this Vagrant box configuration includes XDebug installation. You can confirm that XDebug is enabled for PHP, by creating a simple PHP script named `phpinfo.php` in the `/vagrant/laravel` directory with the following:
```php
<?php
	echo phpinfo();
?>
```
Open this file in your web browser on the **host** machine by navigating to (http://localhost:8080/phpinfo.php).  You should see a section toward the bottom of the page that has **xdebug** heading that indicates XDebug is enabled and the details of the default configuration.  

When XDebug is installed during the provisioning of the Vagrant box (the first time that you run `vagrant up`), an XDebug configuration file will be created on the Vagrant box in `/etc/php5/apache2/conf.d/20-xdebug.ini`. (At the top of the `phpinfo.php` page noted above, the **Additional .ini files parsed** should include `/etc/php5/apache2/conf.d/20-xdebug.ini`.) By default, this file will be empty, since it is configured for *local* debugging.  Open this file for editing by running `sudo vi /etc/php5/apache2/conf.d/20-xdebug.ini` and add these lines to the file.
```ini
zend_extension=/usr/lib/php5/20100525+lfs/xdebug.so
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_host=192.168.33.1
xdebug.remote_port=9000
xdebug.remote_autostart=0
xdebug.remote_log=/tmp/php5-xdebug.log
```

Most of these lines should be self-explanatory (or you can check the [XDebug **basic** documentation](http://xdebug.org/docs/basic) for details!).  However, a couple of specific notes are in order.
* **`xdebug.remote_host`** - This is the IP address of the **host** with respect to the Vagrant box.  In our `Vagrantfile`, we specify that the Vagrant box has IP address **192.168.33.10** via this line:
```
config.vm.network :private_network, ip: "192.168.33.10"
```
You can find the IP address (range!) for the **host** (again, with respect to the Vagrant box) by running `netstat -rn` on the Vagrant box (i.e., after running `vagrant ssh` to connect to Vagrant box from the host).  You should see something like:
```
vagrant@development:/etc/php5/apache2/conf.d$ netstat -rn
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
0.0.0.0         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 eth0
192.168.33.0    0.0.0.0         255.255.255.0   U         0 0          0 eth1
```
The last line (`eth1`) is the one we are interested in and it shows that the `localhost` gateway (0.0.0.0) is routed to 192.168.33.0, so we can use any IP address (except 192.168.33.**10**!) in this subnet, so let's choose the lowest one:  192.168.33.**1**.
* **`xdebug.remote_log`** - This specifies that the XDebug logging will be done on the **host** machine in `/tmp/php5-xdebug.log`, which allows us to easily check the log file if we run into any problems.

#### Host Machine and IDE/Editor Configuration
Now that we have everything set up for remote debugging on the Vagrant box (Remember that we are thinking of the Vagrant box as being a "remote" server with respect to the **host** machine where we do our development work.), we can set up our development environment on the **host**.  Much of this work is specific to your IDE or editor that you use.  Let's look at how to do this for [Aptana Studio](http://www.aptana.org) (the same process applies to [Eclipse](http://www.eclipse.org/), since Aptana is based on Eclipse) and [Netbeans](http://www.netbeans.org).

##### Aptana Studio

##### Netbeans

### Checking the Installation
After you have launched the Vagrant box by running `vagrant up`, you can check that the box is working by opening http://localhost:8080/ on the **host** machine.  The standard Laravel "You have arrived." page should be displayed.  Congratulations!

For reference, this means that the Laravel `public` folder corresponds to the root or ("home") directory for the Apache web server on the Vagrant box.  Thus, all Laravel URLs are based on this URL.

### To Do
The following additional features are planned:
* Add [PHPMyAdmin](http://phpmyadmin.net/) to the VM, with access from the host machine.
* Add some additional frequently-used Laravel packages to the provisioning (installation) script.
* Add support for Apache virtual host alias.

### Credits
Special thanks to [Zachary Flower](https://github.com/zachflower/basic-vagrant-lamp).  This configuration is based on his [Basic Vagrant LAMP](https://github.com/zachflower/basic-vagrant-lamp).

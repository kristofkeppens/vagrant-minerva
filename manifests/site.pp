node "default" {
    Exec { path => "/bin:/sbin:/usr/bin:/usr/sbin" }
    $packagelist = ['php5-mysql', 'php5-curl', 'php5-ldap', 'php5-xsl', 'php-html-common', 'php-html-quickform-advmultiselect', 'php-html-quickform', 'php-html-table', 'php-mail-mime',
    'php-pager', 'php-phing', 'php-versioncontrol-svn', 'php5-pecl-http', 'php5-memcache', 'xtrabackup']

    include apt
    include apache
    include php
    include php::apache
    include minerva

    apt::key { "FC41D778":
        source => "http://aeolus.ugent.be/debian/aeolus.gpg";
    }

    apt::sources_list { "aeolus":
        ensure => present,
        content => "deb http://aeolus.ugent.be/debian/ squeeze main";
    }

    package { $packagelist:
        ensure => present;
    }
    
    class { 'memcached': }
    
    class { 'percona': server => true; }

    percona::database { 'minerva':
        ensure => present;    
    }

    percona::user { 'minerva':
        ensure => present,
        password => 'minerva',
        database => 'minerva';
    }

    percona::conf {
        "innodb_additional_mem_pool_size": content => "[mysqld]\ninnodb_additional_mem_pool_size = 16M";
        "innodb_buffer_pool_size": content => "[mysqld]\ninnodb_buffer_pool_size = 256M";
        "innodb_log_buffer_size": content => "[mysqld]\ninnodb_log_buffer_size = 8M";
        "innodb_file_per_table": content => "[mysqld]\ninnodb_file_per_table";
    }

    exec { "Mysql set root password":
        command => "mysql --defaults-file=/etc/mysql/debian.cnf --execute \"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');\"";
    }

    cron { "db backup":
        command => "sudo innobackupex --user root --password root /var/www/mysqlbackups",
        user => vagrant,
        hour => 1,
        minute => 0;
    }
}

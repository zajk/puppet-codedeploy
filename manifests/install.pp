# == Class codedeploy::install
#
# This class is called from codedeploy for install.
#
class codedeploy::install {

  case $::osfamily {
    'RedHat', 'Amazon': {
      package { $::codedeploy::package_name:
        ensure => present,
        source => $::codedeploy::package_url,
      }
    }
    'Debian': {
      if ! defined(Package['awscli']) {
        package { 'awscli':
          ensure => present,
        }
      }
      if ! defined(Package['ruby2.0']) {
        package { 'ruby2.0':
          ensure => present,
        }
      }
      exec { 'download_codedeploy_installer':
        path    => [ '/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin:/bin' ],
        command => "aws s3 cp s3://${codedeploy::region_bucket}/latest/install . --region ${codedeploy::region}",
        cwd     => '/tmp',
        creates => '/tmp/install'
      }
      file { '/tmp/install':
        ensure    => present,
        owner     => 'root',
        group     => 'root',
        mode      => '0740',
        subscribe => Exec['download_codedeploy_installer'],
        notify    => Exec['install_codedeploy_agent'],
      }
      exec { 'install_codedeploy_agent':
        command     => '/tmp/install --sanity-check auto',
        cwd         => '/tmp',
        refreshonly => true,
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}

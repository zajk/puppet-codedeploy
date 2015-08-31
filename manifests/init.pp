# == Class: codedeploy
#
# Full description of class codedeploy here.
#
# === Parameters
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#
class codedeploy (
  $package_url   = $::codedeploy::params::package_url,
  $package_name  = $::codedeploy::params::package_name,
  $service_name  = $::codedeploy::params::service_name,
  $region        = $::codedeploy::params::region,
  $region_bucket = $::codedeploy::params::region_bucket
) inherits ::codedeploy::params {

  # validate parameters here
  validate_re($region_bucket, 'aws-codedeploy-(us|eu)-(east|west)-[1-4]', 'Region bucket is not correct format')
  validate_re($region, '(us|eu)-(east|west)-[1-4]', 'Region is not in correct format.')

  class { '::codedeploy::install': } ->
  class { '::codedeploy::service': } ->
  Class['::codedeploy']
}

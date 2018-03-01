class ec2_tag {
  package {'aws-sdk':
    ensure => present,
    provider => puppet_gem,
  }
}

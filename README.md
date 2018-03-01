## Overview:
The ec2_tag module exposes a custom type used to manage ec2 tags in AWS.

## Usage:
```
ec2_tag { "title":
  ensure => present, # absent to remove a tag
  name => "name", # optional - defaults to $title
  value => "value",
}
```

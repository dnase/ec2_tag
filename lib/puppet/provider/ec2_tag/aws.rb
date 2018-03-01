require 'aws-sdk'
require 'yaml'

Puppet::Type.type(:ec2_tag).provide :aws do
  desc "Provider to set EC2 tags on AWS"

  def create
    ec2.create_tags({
      resources: [
        instance_id,
      ],
      tags: [
        {
          key: @resource[:name],
          value: @resource[:value],
        },
      ],
    })
  end

  def destroy
    ec2.delete_tags({
      resources: [
        instance_id,
      ],
      tags: [
        {
          key: @resource[:name],
          value: @resource[:value],
        },
      ],
    })
  end

  def exists?
    ec2.describe_tags({
      filters: [
        {
          name: "resource-id",
          values: [
            instance_id,
          ],
        },
        {
          name: "key",
          values: [
            @resource[:name]
          ],
        },
      ],
    })['tags'] != []
  end

  def value
    ec2.describe_tags({
      filters: [
        {
          name: "resource-id",
          values: [
            instance_id,
          ],
        },
        {
          name: "key",
          values: [
            @resource[:name]
          ],
        },
      ],
    })['tags'][0].value
  end

  def value=(tag_value)
    ec2.create_tags({
      resources: [
        instance_id,
      ],
      tags: [
        {
          key: @resource[:name],
          value: tag_value,
        },
      ],
    })
  end

  def instance_id
    Facter.value(:ec2_metadata)['instance-id']
  end

  def ec2
    Aws::EC2::Client.new(region: Facter.value(:ec2_metadata)['placement']['availability-zone'][0..-2])
  end

end

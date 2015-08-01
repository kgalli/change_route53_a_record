include_recipe 'route53'

#require 'net/http'
#public_ip     = Net::HTTP.get(URI.parse('http://169.254.169.254/latest/meta-data/public-ipv4'))
instance_name = node[:opsworks][:instance][:hostname]
stack_name    = node[:opsworks][:stack][:name]
instance_name = node[:opsworks][:instance][:hostname]
public_ip     = node[:opsworks][:instance][:ip]
domain        = node[:custom_domain]

route53_record "create a record" do
  name  [instance_name, stack_name, domain].join('.')
  value public_ip
  type  "A"
  ttl   300
  zone_id               node[:dns_zone_id]
  aws_access_key_id     node[:custom_access_key]
  aws_secret_access_key node[:custom_secret_key]
  overwrite true
  action :create
end


include_recipe 'route53'

instance_name = node[:opsworks][:instance][:hostname]
stack_name    = node[:opsworks][:stack][:name].downcase
instance_name = node[:opsworks][:instance][:hostname]
public_ip     = node[:opsworks][:instance][:ip]
domain        = node[:custom_domain]

route53_record "delete a record" do
  name  [instance_name, stack_name, domain].join('.')
  value public_ip
  ttl 300
  zone_id               node[:dns_zone_id]
  aws_access_key_id     node[:custom_access_key]
  aws_secret_access_key node[:custom_secret_key]
  action :delete
end


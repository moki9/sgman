#!/usr/bin/env ruby

#required packages for this script
require "rubygems"
require "aws-sdk"

#check arguments
if ARGV.lenght != 3
	puts "Usage:"
	puts "ruby sgman <ec2 security group name> <current ip rule> <new ip rule>"
	puts "eg: ruby sgman.rb apache-sg 0.0.0.0/8080 0.0.0.0/80"
	exit
end

# assign arguments to variables
sg_name, curr_ip, new_ip = ARGV

#create ec2 instance
ec2 = AWS::EC2.new

#search for group name from ec2 security groups
sg = ec2.security_groups.filter("group-name", sg_name).first

#abort further execution if the group is not found
abort("#{sg_name} does not exist!") if sg == nil

#updated rules
updated = 0

#extract inbound rules
ip_rules = sg.ip_permissions


ip_rules.each do |current_rule|	
	#skip if rule is not matched
	next if current_rule.ip_ranges.include? curr_ip

	#extract ip ranges
	new_ip_ranges = current_rule.ip_ranges.map { |ip| ip == curr_ip ? new_ip : ip  }

	#instantiate a new IpPermission since we cannot just modify IpPermission which is mutable
	new_rule = AWS::EC2::SecurityGroup::IpPermission.new(
		current_rule.security_group,
		current_rule.protocol,
		current_rule.port_range, 
		{
			:ip_ranges => new_ip_ranges,
			:groups => current_rule.groups
		}
	)

	#revoke existing rule before authorizing the new one
	current_rule.revoke
	new_rule.authorize	
	updated += 1
end

puts "#{updated} rules updated"
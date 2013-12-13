sgman
=====

A simple tool for updating AWS security group rules.

Set your AWS security credentials in your environment before running the script.
eg:
    export AWS_ACCESS_KEY_ID='my-aws-id'
    export AWS_SECRET_ACCESS_KEY='kjfejfwekflkwe'
    export AWS_REGION='us-east-1'

Clone repository to your computer
	git clone https://github.com/moki9/sgman.git
	cd sgman
	bundle install

Usage:
	ruby sgman.rb <group-name> <current-rule> <new-rule>
	
	eg: ruby sgman.rb  websrvs 0.0.0.0/8080 0.0.0.0/80




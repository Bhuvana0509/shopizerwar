#
# Cookbook:: shopizer
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

include_recipe 'shopizer::tomcat8'
include_recipe 'shopizer::mysql'
include_recipe 'shopizer::shopizer'

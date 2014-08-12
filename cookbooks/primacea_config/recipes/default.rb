#
# Cookbook Name:: primacea_config
# Recipe:: default
#
include_recipe "primacea_config::mongodb"
include_recipe "primacea_config::winston"
include_recipe "primacea_config::egnyte"
include_recipe "primacea_config::redis"
include_recipe "primacea_config::pdfcrowd"
include_recipe "primacea_config::mailer"



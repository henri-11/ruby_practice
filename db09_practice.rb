require 'mysql2'
require 'dotenv/load'
require 'digest'
#require_relative 'methods.rb'
#require_relative 'new_assignment.rb'
require_relative 'dev_test.rb'

client = Mysql2::Client.new(host: "db09.blockshopper.com", username: ENV['DB09_LGN'], password: ENV['DB09_PWD'], database: "applicant_tests")

#get_teacher(2, client)
#get_subject(3, client)
#get_class(1, client)
#get_teachers_list_by_letter("a", client)
#set_md5(client)
#get_class_info(1, client)
#get_teachers_by_year(1999, client)
#random_last_names(10000, client)
#people_gen(10000, client)
#new_clean_table(client)
dev_test(client)
client.close
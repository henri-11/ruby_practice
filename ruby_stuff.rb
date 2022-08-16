require "mysql2"

client = Mysql2::Client.new(:host =>"localhost", 
                        :username => "root",
                        :database => "class_db")

def clean(client)
  res = client.query("SELECT * FROM people_henri;").to_a
  res.each do |row|
    lastname = (row['lastname'] + " edited").gsub(/( edited)\1*/,'\1')
    email  = row['email'].downcase
    email2 = row['email2'].downcase
    profession = row['profession'].strip
    client.query("UPDATE people_henri SET lastname = lastname, email = email, email2 = email2, profession = profession")

  end
end

client.close

puts res
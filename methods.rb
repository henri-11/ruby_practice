def get_teacher(id, client)
  f = <<~SQL
    select first_name, middle_name, 
    last_name, birth_date 
    from teachers_henri 
    where ID = #{id}
  SQL

  results = client.query(f).to_a
  if results.count.zero?
    puts "Teacher with ID #{id} was not found."
  else
    puts "Teacher #{results[0]['first_name']} #{results[0]['middle_name']} #{results[0]['last_name']} was born on #{(results[0]['birth_date']).strftime("%d %b %Y (%A)")}"
  end
end

def get_subject(id, client)

f = <<~SQL
   SELECT s.name, t.first_name, t.middle_name, t.last_name
   FROM subjects_henri s
      JOIN  teachers_henri t ON s.id=t.subject_id
      where s.id = #{id};
SQL

results = client.query(f).to_a 

if results.count.zero? 
  "Subject: Not found"
else
  res = "Subject: #{results[0]['name']}\nTeacher(s):"
  results.each do |row| 
    res+="\n#{row['first_name']} #{row['middle_name']} #{row['last_name']}"
  end
end
puts res if res
end
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

def get_class(id, client)

f = <<~SQL
SELECT c.name class, s.name subject, t.first_name, t.middle_name, t.last_name
from subjects_henri s 
join teachers_henri t ON t.subject_id= s.id
     JOIN teachers_classes_henri tc ON tc.teacher_id = t.id
     JOIN classes_henri c ON tc.class_id = c.id where c.id =#{id}
SQL

results = client.query(f).to_a 

if results.count.zero? 
  "Class: Not found"
else
  res = "Class: #{results[0]['class']}\nSubjects:"
  results.each do |row| 
    res+="\n#{row['subject']} (#{row['first_name']} #{row['middle_name'][0]}" + "." + " #{row['last_name']})" 
  end
end
puts res if res
end
  
def get_teachers_list_by_letter(letter, client)

f = <<~SQL
   SELECT s.name subject, t.first_name, t.middle_name, t.last_name
from subjects_henri s 
join teachers_henri t ON t.subject_id= s.id
      where (t.first_name like "%#{letter}%" or t.last_name like "%#{letter}%") 
SQL

results = client.query(f).to_a

if results.count.zero?
  puts  "Match not found!"
  else
    res = ""
  results.each do |row| 
    res += "#{row['first_name'][0]}. #{row['middle_name'][0]}. #{row['last_name']} (#{row['subject']})\n"
  end
 
 end
puts res.strip if res
end

def set_md5(client)

  f = <<~SQL
   SELECT id, first_name, middle_name, last_name, birth_date, subject_id
  from teachers_henri
  SQL

  src = client.query(f)
  src.each do |row|
    x = Digest::MD5.hexdigest "#{row['first_name']}#{row['middle_name']}#{row['last_name']} #{row['birth_date']} #{row['subject_id']}"

    u = <<~SQL
      UPDATE teachers_henri SET md5 = "#{x}" where id = #{row['id']}
    SQL
    client.query(u)
  end
end

def get_class_info(id, client)

  c = <<~SQL
  SELECT c.name class, t.first_name, t.middle_name, t.last_name, c.responisble_teacher_id r_id, t.id
  from subjects_henri s 
  join teachers_henri t ON t.subject_id= s.id
       JOIN teachers_classes_henri tc ON tc.teacher_id = t.id
       JOIN classes_henri c ON tc.class_id = c.id where c.id =#{id};
  SQL

   results = client.query(c).to_a

   if results.count.zero?
    puts "Couldn't find any info about the selected class."
  else
    res = "Class name: #{results[0]['class']}\nResponsible teacher:"
    responsible_teaher = results.find { |el| el['id']==el['r_id'] }
    res += " #{responsible_teaher['first_name']} #{responsible_teaher['middle_name']} #{responsible_teaher['last_name']}\nInvolved teacher(s): "
    results.each do |row|
      res+="#{row['first_name']} #{row['middle_name']} #{row['last_name']}, "
    end
    puts res.strip.chop!
  end
end

def get_teachers_by_year(year, client)

  t = <<~SQL
  SELECT first_name, middle_name, last_name FROM teachers_henri WHERE year(birth_date) = #{year}
  SQL

  results = client.query(t).to_a

  if results.count.zero?
    puts "Couldn't find any teachers born in that year."
  else 
    res = "Teachers born in #{year}:"
    results.each do |row|
      res += " #{row['first_name']} #{row['middle_name']} #{row['last_name']},"
    end
    puts res.chop! + "."
  end
end

#Methods for Radom_people assignment:

#Random dates.

def random_date(date_begin, date_end)
 rand(Date.parse(date_begin)..Date.parse(date_end))
end

#Random last names.

def random_last_names(n, client)
  
  rl = <<~SQL 
  SELECT last_name FROM last_names;
  SQL

  @last_names = @last_names ? @last_names : client.query(rl).to_a.map { |el| el['last_name']}
  result = @last_names.sample(n)

  puts result
end

def random_first_names(n, client)
  
  rf = <<~SQL
  SELECT FirstName FROM male_names;
  SQL

  rf2 = <<~SQL
  SELECT names FROM female_names;
  SQL

  @names = @names ? @names : (client.query(rf).to_a.map { |el| el['FirstName']} + client.query(rf2).to_a.map { |el| el['names']})
  result = @names.sample(n)

  puts result 
end
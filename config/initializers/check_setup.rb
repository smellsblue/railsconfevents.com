unless File.exist? File.join(Rails.root, "config/database.yml")
  if STDOUT.isatty
    STDERR.puts "You do not have a database file! Please run `rake setup`"
    exit 1
  else
    raise "You do not have a database file! Please run `rake setup`"
  end
end

unless File.exist? File.join(Rails.root, "config/secrets.yml")
  if STDOUT.isatty
    STDERR.puts "You do not have a secrets file! Please run `rake setup`"
    exit 1
  else
    raise "You do not have a secrets file! Please run `rake setup`"
  end
end

Rails.application.secrets.each do |key, value|
  if value == "todo"
    if STDOUT.isatty
      STDERR.puts "You do not have a value for the #{key} secret! Please run `rake setup`"
      exit 1
    else
      raise "You do not have a value for the #{key} secret! Please run `rake setup`"
    end
  end
end

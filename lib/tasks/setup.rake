task :setup do
  require "fileutils"
  require "securerandom"
  require "yaml"

  database_yml = File.join Rails.root, "config/database.yml"
  secrets_yml = File.join Rails.root, "config/secrets.yml"

  unless File.exist? database_yml
    STDOUT.puts "Creating config/database.yml (please update it with your database config)"
    FileUtils.cp "#{database_yml}.example", database_yml
  end

  unless File.exist? secrets_yml
    STDOUT.puts "Creating config/secrets.yml"
    FileUtils.cp "#{secrets_yml}.example", secrets_yml
  end

  secrets = YAML.load_file secrets_yml
  secrets_changed = false

  if secrets["test"]["secret_key_base"] == "todo"
    secrets["test"]["secret_key_base"] = SecureRandom.hex 64
    secrets_changed = true
  end

  unless Rails.env.test?
    if secrets[Rails.env.to_s]["secret_key_base"] == "todo"
      secrets[Rails.env.to_s]["secret_key_base"] = SecureRandom.hex 64
      secrets_changed = true
    end

    ["github_key", "github_secret",
     "twitter_consumer_key", "twitter_consumer_secret",
     "twitter_access_token", "twitter_access_secret"].each do |key|
      if secrets[Rails.env.to_s][key] == "todo"
        STDOUT.print "Please provide your #{key} (blank to skip for now): "
        value = STDIN.gets.strip

        unless value.blank?
          secrets[Rails.env.to_s][key] = value
          secrets_changed = true
        end
      end
    end
  end

  if secrets_changed
    STDOUT.puts "Updating config/secrets.yml"
    contents = File.read secrets_yml

    File.open secrets_yml, "w" do |f|
      f << contents[/(.*)^---/m, 1]
      f << secrets.to_yaml
    end
  end
end

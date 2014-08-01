require "json"

current = {}

Dir.glob("../projects-data/*.json").each do |file|
  data = JSON.parse(File.read(file))
  current[data["name"]] = file
end

category = ""

File.readlines('README.md').each do |line|
  if line.match(/\#\# ([^\n]+)/)
    category = line.scan(/\#\# ([^\n]+)/)[0][0]
    puts category.inspect
  end

  if line.match(/\* \[([A-Za-z0-9 ]+)\]\(([^\)]+)\) \- ([^\n]+)/)
    l = line.match(/\* \[([A-Za-z0-9 ]+)\]\(([^\)]+)\) \- ([^\n]+)/)
    if current[l[1]].nil?
      puts l[1]
      data = {}
      data["name"] = l[1]
      data["description"] = l[3]
      data["abstract"] = l[3]
      data["category"] = category
      data["tags"] = []
      filename = "#{data["name"].downcase.gsub(/[^a-z0-9]/, "_")}.json"
      data["links"] = [{"text" => "Website", "url" => l[2]}]
      File.open("./data/#{filename}", 'w') { |file| file.write(JSON.pretty_generate(data)) }
    end
  end
end
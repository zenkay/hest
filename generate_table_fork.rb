require 'erb'
require 'json'
require "maruku"
require "pp"

# load ordered category list
table_config = JSON.parse(File.read("config/wordpress.json"))

data_grouped_by_category = {}

# iterate on data files (alphabetically ordered)
Dir.glob('data/*.json').sort.each do |file|

	# read content
  data = JSON.parse(File.read(file))
  data_grouped_by_category[data["category"]] ||= []

  # convert markdown to HTML
  data["description"] = Maruku.new(data["description"]).to_html
  data["abstract"] = Maruku.new(data["abstract"]).to_html

  data_grouped_by_category[data["category"]] << data
end

# create table content
categories = []
table_config["categories"].each do |c|
	categories << {"name" => c, "items" => data_grouped_by_category[c]}
end

# write result
File.open("index.html", 'w') { |file| file.write(ERB.new(File.read("templates/table-fork.html")).result(binding)) } 
require "json"
require "nokogiri"
require "open-uri"

data = []

doc = Nokogiri::HTML5(URI.open("https://nrc.canada.ca/en/certifications-evaluations-standards/canadas-official-time/3-when-do-seasons-start"))

table = doc.css("table.table.table-responsive.table-bordered.small.mrgn-tp-lg").first

rows = table.css("tr")

rows[1..].each do |row|
  cells = row.css("td")

  year = cells.first.text.strip
  start_of_spring = cells[1].text.strip
  start_of_summer = cells[2].text.strip
  start_of_autumn = cells[3].text.strip
  start_of_winter = cells[4].text.strip

  data << {
    "#{year}": {
      "spring": start_of_spring,
      "summer": start_of_summer,
      "autumn": start_of_autumn,
      "winter": start_of_winter
    }
  }
end

File.open("seasons.json", "w") do |f|
  f.puts JSON.pretty_generate(data)
end

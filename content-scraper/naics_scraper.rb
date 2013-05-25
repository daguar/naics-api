require 'pry'
require 'httparty'
require 'nokogiri'

module NaicsScraper
  def self.get_codes_for_year(year)
    # May want to add error handling for year constraints (eg, only allow args of 2012/2007/2002)
    response = HTTParty.get("http://naics-api.herokuapp.com/v0/q?year=#{year}")
  end
  def self.get_content_for_code(code)
    response = HTTParty.get("http://www.census.gov/cgi-bin/sssd/naics/naicsrch?code=#{code}&search=2012%20NAICS%20Search")
    parsed_doc = Nokogiri::HTML(response.body)
    pieces = parsed_doc.css("#middle-column .inside")
    if code.to_s.length == 6
      content = pieces[0].children[10].children[2].text
    elsif code.to_s.length == 5
      content = pieces[0].children[10].children[4].text
    else
      binding.pry
    end
    content.strip
  end
end

# Example usage
#code_description = NaicsScraper.get_content_for_code(111120)
#all_2012_codes = NaicsScraper.get_codes_for_year(2012)

binding.pry

require 'rubygems'
require 'json'
require 'nokogiri'
require 'open-uri'

class Scrapper
    attr_accessor :page, :scrap_url

    def initialize(scrap_url)
        @page = Nokogiri::HTML(open(scrap_url))  # ici, 'https://www.annuaire-des-mairies.com/'" = scrap_url, dept = "val-d-oise.html"
        @scrap_url = scrap_url
    end

    def get_townhall_email(scrap_url)
        page2 = Nokogiri::HTML(open(scrap_url))
        email = page2.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').first.content
        return email
    end

    def get_townhall_urls
        val_oise = 'https://www.annuaire-des-mairies.com/val-d-oise.html'
        result_array = []
        doc = Nokogiri::HTML(open(val_oise))
        doc.xpath('//*[@class="lientxt"]/@href').each do |url|
            mairie_name = url.text.split("/").last.split(".").first # permet de recuperer le nom de la ville 
            mairie_url = "http://annuaire-des-mairies.com#{url.text[1..-1]}" #[1..-1] fourchette d'index pour retirer le ./

            mairie_email = get_townhall_email(mairie_url)

            result_array << {mairie_name => mairie_email}
        end
        return result_array
    end

    def save_as_json(array_to_store)
        File.open("emails.json","w") do |f|
            f.write(array_to_store.to_json)
            end
        system('mv emails.json db/emails.json')
    end

end

#puts get_townhall_urls.inspect
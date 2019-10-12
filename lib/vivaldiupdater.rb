require 'rest-client'
require 'nokogiri'

class VivaldiUpdater
  def initialize
    puts "Welcome to Vivaldi Updater for Ubuntu!"
    puts 'Vivaldi is currently running! If you choose to update, please close it!' if running?
    @current = `dpkg -l vivaldi-stable`.split("\n").last.split(' ')[2]
    puts "Current Vivaldi Version: #{@current}"
    site = RestClient.get('https://vivaldi.com/download').body
    doc = Nokogiri::HTML.parse(site)
    @url = doc.search('a.download-link').first.values[1]
    @version = @url.split('/').last.gsub('_amd64.deb', '').gsub('vivaldi-stable_', '')
    puts "Latest Vivaldi Version:  #{@version}"

    if @current == @version
      puts 'Vivaldi is up to date!'
      exit
    else
      puts 'Update available! Enter to update, CTRL+C to cancel!'
      gets
      update
    end
  end

  def running?
    output = `ps ax | grep vivaldi`.split("\n")
    return true if output.length > 3
    false
  end

  def update
    puts 'Downloading new update...'
    `wget #{@url}`
    puts 'Updating... sudo access may be needed'
    ur = @url.gsub('https://downloads.vivaldi.com/stable/', '')
    `sudo dpkg -i #{ur}`
    puts 'Done updating!'
  end
end

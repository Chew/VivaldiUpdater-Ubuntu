require 'rest-client'
require 'nokogiri'

class VivaldiUpdater
  def initialize(install = false, skip_current = false)
    puts "Welcome to Vivaldi Updater for Ubuntu!"
    puts 'Vivaldi is currently running! If you choose to update, please close it!' if running?
    if skip_current
      @current = "Skipped..."
    else
      begin
        @current = `dpkg -l vivaldi-stable`.split("\n").last.split(' ')[2]
        puts "Vivaldi is installed, ignoring --install flag" if install
      rescue NoMethodError
        case install
        when true
          puts "Vivaldi not detected on this machine! Installing..."
          @current = "None"
        when false
          puts "Vivaldi not detected on this machine! If you would like to install Vivaldi, please append '--install' to your command."
          exit
        end
      end
    end
    puts "Current Vivaldi Version: #{@current}"
    print "Latest Vivaldi Version:  Checking...\r"
    site = RestClient.get('https://vivaldi.com/download').body
    doc = Nokogiri::HTML.parse(site)
    @url = doc.search('a.download-link').first.values[1]
    @version = @url.split('/').last.gsub('_amd64.deb', '').gsub('vivaldi-stable_', '')
    $stdout.flush
    print "Latest Vivaldi Version:  #{@version}\n"

    if @current == @version
      puts 'Vivaldi is up to date!'
      exit
    else
      puts 'Update available! Enter to update, CTRL+C to cancel!'
      STDIN.gets.chomp
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

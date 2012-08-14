#!/usr/bin/env ruby
#
# File:  Warranty.rb
#
# Decription:     Contact's Apple's selfserve servers to capture warranty
#                 information about your product. Accepts arguments of
#                 machine serial numbers.
#
# Author:         Gary Larizza
# Last Modified:  8/13/2012
# Why:            Apple hates APIs
require 'uri'
require 'net/http'
require 'net/https'
require 'date'

def get_warranty(serial)
  # Setup HTTP connection
  uri              = URI.parse('https://selfsolve.apple.com/wcResults.do')
  http             = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request          = Net::HTTP::Post.new(uri.request_uri)

  # Prepare POST data
  request.set_form_data(
    {
      'sn'       => serial,
      'Continue' => 'Continue',
      'cn'       => '',
      'locale'   => '',
      'caller'   => '',
      'num'      => '0'
    }
  )

  # POST data and get the response
  response      = http.request(request)
  response_data = response.body

  # I apologize for this line
  warranty_status = response_data.split('warrantyPage.warrantycheck.displayHWSupportInfo').last.split('Repairs and Service Coverage: ')[1] =~ /^Active/ ? true : false

  # And this one too
  expiration_date = response_data.split('Estimated Expiration Date: ')[1].split('<')[0] if warranty_status

  puts "\nSerial Number:\t\t#{serial}"
  puts "Warranty Status:\t" + (warranty_status ? "Active and it expires on #{expiration_date}" : 'Expired')

  #TODO: 
  #  Grab product description and calculate Purchase Data
  #  Catch invalid Serial Numbers
  #  Make this more than just a proof of concept...
end

if ARGV.size > 0 then
  serial = ARGV.each do |serial|
    get_warranty(serial.upcase)
  end
else
  puts "Without your input, we'll use this machine's serial number."
  serial = %x(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}').upcase.chomp
  get_warranty(serial)
end

#!/usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require 'faraday'
require 'pry'

downloads_folder = '/Users/tonidezman/Downloads/ruby_on_rails_podcast'
Dir.mkdir(downloads_folder)


podcast_number   = 1
starting_episode = 10
ending_episode   = 141

(starting_episode..ending_episode).each do |podcast_number|
  site = "http://5by5.tv/rubyonrails/#{podcast_number}"
  web_site = open(site)
  doc           = Nokogiri::HTML(web_site)
  css_selector  = '.download_links p a'
  download_link = doc.css(css_selector).first.attributes['href'].value
  response      = Faraday.head(download_link)

  puts "Downloading: #{podcast_number}"
  File.open("#{downloads_folder}/#{podcast_number}.mp3", "wb") do |file|
    open(response.headers["Location"]) do |mp3|
      file.write mp3.read
    end
  end
end

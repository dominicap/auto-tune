#!/usr/bin/env ruby

# @date: October 22, 2016
# @author: Dominic Philip
# @version: 0.1

require 'json'
require 'net/http'
require 'taglib'

class TuneSort
  def initialize(directory)
    if File.exists?(File.expand_path(directory))
      @directory = File.expand_path(directory)
    else
      raise ArgumentError.new('Directory is not a valid location')
    end
  end

  def os
    case RUBY_PLATFORM
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        @os = 'windows'
      when /darwin|mac os/
        @os = 'macos'
      else
        raise SystemCallError.new('Operating System is not supported', 1)
    end
  end

  def get_itunes_tags(query)
    unless File.exists?(@directory + '/itunes_tags.json')
      lookup = 'https://itunes.apple.com/search?term=' + query.downcase.gsub!(' ', '+')
      File.write(@directory + '/itunes_tags.json', Net::HTTP.get(URI.parse(lookup)))
    end
  end

  def parse_track_id(track_number)
    track_id = nil
    if not File.exists?(@directory + '/itunes_tags.json')
      raise RuntimeError.new('iTunes JSON file has not been downloaded')
    else
      tags_hash = JSON.parse(File.read(@directory + '/itunes_tags.json'))
      (0..tags_hash['resultCount'].to_i).each { |key|
        itunes_track_number = tags_hash.dig('results', key, 'trackNumber')
        if track_number == itunes_track_number.to_i
          itunes_rating = tags_hash.dig('results', key, 'trackExplicitness')
          if itunes_rating == 'explicit'
            track_id = tags_hash.dig('results', key, 'trackId')
          elsif itunes_rating == 'notExplicit'
            track_id = tags_hash.dig('results', key, 'trackId')
          end
        end
      }
    end
    track_id
  end

  def get_track_number(song)
    track_number = nil
    TagLib::FileRef.open(song) do |tune|
      unless tune.nil?
        track_number = tune.tag.track
      end
    end
    track_number
  end

  def get_copyright(id)
    lookup = "https://itunes.apple.com/us/album/id#{id}"
    Net::HTTP.get(URI.parse(lookup)).split(/<li class="copyright">(.*?)<\/li>/)[1]
  end

  def set_track_id(id, song)
    system("mp4tags -I #{id.to_i} #{song}")
  end

  def set_copyright(copyright, song)
    system("mp4tags -C #{copyright.to_s} #{song}")
  end

  def remove_tags
    File.delete(@directory + '/itunes_tags.json')
    File.delete(@directory + '/spotify_tags.json')
    File.delete(@directory + '/wiki_tags.json')
  end
end

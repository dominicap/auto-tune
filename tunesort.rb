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
        return 'windows'
      when /darwin|mac os/
        return 'macos'
      else
        raise SystemCallError.new('Operating System is not supported', 1)
    end
  end

  def get_spotify_tags(song, artist)
    spotify_song_id_url = lookup = "https://api.spotify.com/v1/search?q=\
                                    album:#{album.downcase.gsub!(' ', '+')}%20\
                                    artist:#{artist.downcase.gsub!(' ', '+')}&type=track"
    lookup = "https://api.spotify.com/v1/audio-features/#{id}"
    File.write(@directory + '/spotify_tags.json', Net::HTTP.get(URI.parse(lookup)))
  end

  def get_itunes_tags(query)
    unless File.exists?(@directory + '/itunes_tags.json')
      lookup = 'https://itunes.apple.com/search?term=' + query.downcase.gsub!(' ', '+')
      File.write(@directory + '/itunes_tags.json', Net::HTTP.get(URI.parse(lookup)))
    end
  end

  def parse_info(track_number)
    if not File.exists?(@directory + '/itunes_tags.json')
      raise RuntimeError.new('iTunes JSON file has not been downloaded')
    else
      tags_hash = JSON.parse(File.read(@directory + '/itunes_tags.json'))
      (0..tags_hash['resultCount'].to_i).each { |key|
        itunes_track_number = tags_hash.dig('results', key, 'trackNumber')
        if track_number == itunes_track_number.to_i
          itunes_rating = tags_hash.dig('results', key, 'trackExplicitness')
          if itunes_rating == 'explicit'
            @info = Array.new.push(tags_hash.dig('results', key, 'artistId'),
                                  tags_hash.dig('results', key, 'collectionId'),
                                  tags_hash.dig('results', key, 'trackId'),
                                  tags_hash.dig('results', key, 'artistName'),
                                  tags_hash.dig('results', key, 'collectionName'),
                                  tags_hash.dig('results', key, 'trackName'),
                                  tags_hash.dig('results', key, 'releaseDate'),
                                  tags_hash.dig('results', key, 'collectionExplicitness'),
                                  tags_hash.dig('results', key, 'trackExplicitness'),
                                  tags_hash.dig('results', key, 'discCount'),
                                  tags_hash.dig('results', key, 'discNumber'),
                                  tags_hash.dig('results', key, 'trackCount'),
                                  tags_hash.dig('results', key, 'trackNumber'),
                                  tags_hash.dig('results', key, 'trackTimeMillis'),
                                  tags_hash.dig('results', key, 'country'),
                                  tags_hash.dig('results', key, 'currency'),
                                  tags_hash.dig('results', key, 'primaryGenreName')) 
          elsif itunes_rating == 'notExplicit'
            @info = Array.new.push(tags_hash.dig('results', key, 'artistId'),
                                  tags_hash.dig('results', key, 'collectionId'),
                                  tags_hash.dig('results', key, 'trackId'),
                                  tags_hash.dig('results', key, 'artistName'),
                                  tags_hash.dig('results', key, 'collectionName'),
                                  tags_hash.dig('results', key, 'trackName'),
                                  tags_hash.dig('results', key, 'releaseDate'),
                                  tags_hash.dig('results', key, 'collectionExplicitness'),
                                  tags_hash.dig('results', key, 'trackExplicitness'),
                                  tags_hash.dig('results', key, 'discCount'),
                                  tags_hash.dig('results', key, 'discNumber'),
                                  tags_hash.dig('results', key, 'trackCount'),
                                  tags_hash.dig('results', key, 'trackNumber'),
                                  tags_hash.dig('results', key, 'trackTimeMillis'),
                                  tags_hash.dig('results', key, 'country'),
                                  tags_hash.dig('results', key, 'currency'),
                                  tags_hash.dig('results', key, 'primaryGenreName')) 
          end
        end
      }
    end
  end

  def get_track_number(song)
    TagLib::FileRef.open(song) do |tune|
      unless tune.nil?
        return tune.tag.track
      end
    end
  end

  def get_album_title(song)
    TagLib::FileRef.open(song) do |tune|
      unless tune.nil?
        return tune.tag.album
      end
    end
  end

  def get_artist_name(song)
    TagLib::FileRef.open(song) do |tune|
      unless tune.nil?
        return tune.tag.artist
      end
    end
  end

  def get_copyright(id)
    lookup = "https://itunes.apple.com/us/album/id#{id}"
    Net::HTTP.get(URI.parse(lookup)).split(/<li class="copyright">(.*?)<\/li>/)[1]
  end

  def set_track_id(track_id, song)
    system("mp4tags -contentid #{id.to_i} #{song}")
  end
  
  def set_artist_id(artist_id, song)
    system("mp4tags -artistid #{artist_id.to_i} #{song}")
  end

  def set_copyright(copyright, song)
    system("mp4tags -copyright #{copyright.to_s} #{song}")
  end

  def remove_tag_files
    File.delete(@directory + '/itunes_tags.json',
                @directory + '/spotify_tags.json',
                @directory + '/wiki_tags.json')
  end
end

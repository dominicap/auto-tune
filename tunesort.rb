#!/usr/bin/env ruby

# @date: October 22, 2016
# @author: Dominic Philip
# @version: 0.1
  
require 'json'
require 'net/http'
require 'taglib'
require 'rspotify'

class TuneSort

  CLIENT_ID = 'e38aca60500943758be6be6e624b2e35'
  CLIENT_SECRET = '68c60cc5600c48e0ab6f28f5a5e24040'

  ITUNES_TAG_KEYS = Array.new.push('artistId', 'collectionId', 'trackId', 'artistName',
                                   'collectionName', 'trackName', 'releaseDate',
                                   'collectionExplicitness', 'trackExplicitness',
                                   'discCount', 'discNumber', 'trackCount',
                                   'trackNumber', 'trackTimeMillis',
                                   'country', 'currency', 'primaryGenreName')

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

  def get_tags(artist, album)
    unless File.exists?(@directory + '/itunes_tags.json')
      lookup = 'https://itunes.apple.com/search?term=' + (artist + ' ' + album).downcase.gsub!(' ', '+')
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
            info = Array.new
            (0..ITUNES_TAG_KEYS.length).each { |index|
              info.push(tags_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
            }
            return info
          elsif itunes_rating == 'notExplicit'
            info = Array.new
            (0..ITUNES_TAG_KEYS.length).each { |index|
              info.push(tags_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
            }
            return info
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

  def get_genre(genre_name)
    genre_appendix_lookup = 'http://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'
    unless genre_name.nil?
      genre_appendix = JSON.parse(Net::HTTP.get(URI.parse(genre_appendix_lookup)))
      genre_appendix['34']['subgenres'].each { |genres|
        genres.each { |genre|
          unless genre.nil?
            if genre['name'].to_s.include? genre_name
              return Array.new.push(genre['name'], genre['id'])
            end
          end
        }
      }
    end
  end

  def get_copyright(id)
    lookup = "https://itunes.apple.com/us/album/id#{id}"
    Net::HTTP.get(URI.parse(lookup)).split(/<li class="copyright">(.*?)<\/li>/)[1]
  end

  def get_tempo(artist, track)
    RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
    unless RSpotify::Track.search(artist.downcase + ' ' + track.downcase).all? &:nil?
      RSpotify::Track.search(artist.downcase + ' ' + track.downcase).max_by { |element|
        element.audio_features.tempo.round }.audio_features.tempo.round
    end
  end

  def set_artist_id(artist_id, song)
    unless artist_id.nil?
      system("mp4tags -artistid #{artist_id.to_i} #{song}")
    end
  end

  def set_collection_id(collection_id, song)
    unless collection_id.nil?
      system("mp4tags -playlistid #{set_collection_id.to_i} #{song}")
    end
  end

  def set_track_id(track_id, song)
    unless track_id.nil?
      system("mp4tags -contentid #{track_id.to_i} #{song}")
    end
  end

  def set_genre(genre, genre_id, song)
    unless track_id.nil?
      system("mp4tags -genreid #{genre_id.to_i} #{song}")
      system("mp4tags -genre #{genre.to_s} #{song}")
    end
  end

  def set_copyright(copyright, song)
    unless copyright.nil?
      system("mp4tags -copyright #{copyright.to_s} #{song}")
    end
  end

  def set_tempo(tempo, song)
    unless tempo.nil?
      system("mp4tags -tempo #{tempo.to_i} #{song}")
    end
  end

  def remove_tag_files
    File.delete(@directory + '/itunes_tags.json',
                @directory + '/wiki_tags.json')
  end
end
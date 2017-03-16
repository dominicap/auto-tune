require 'find'
require 'json'
require 'shellwords'

module AutoTune
  class Util

    ITUNES_TAG_KEYS = Array.new.push('artistId', 'collectionId', 'trackId', 'artistName',
                                     'collectionName', 'trackName', 'artworkUrl100',
                                     'releaseDate', 'collectionExplicitness',
                                     'trackExplicitness', 'discCount', 'discNumber',
                                     'trackCount', 'trackNumber', 'trackTimeMillis',
                                     'country', 'currency', 'primaryGenreName')

    def self.paths(directory)
      Array.new(Find.find(directory).select { |p| /.*\.M4A$/i =~ p || /.*\.MP3$/i =~ p })
    end

    def self.convert(path, params)
      # TODO: Fix this up
    end

    def self.parse(result_hash, track_number)
      (0..result_hash['resultCount'].to_i).each { |key|
        itunes_track_number = result_hash.dig('results', key, 'trackNumber')
        if track_number == itunes_track_number.to_i
          info = Array.new
          (0..ITUNES_TAG_KEYS.length).each { |index|
            info.push(result_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
          }
          return info
        end
      }
    end

    def self.os
      case RUBY_PLATFORM
        when /darwin|mac os/
          return 'macos'
        else
          raise SystemCallError.new('Operating System is not supported', 1)
      end
    end
  end
end

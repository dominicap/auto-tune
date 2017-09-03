require 'find'
require 'json'

module AutoTune
  class Util

    ITUNES_TAG_KEYS = Array.new.push('artistId', 'collectionId', 'trackId', 'artistName',
                                     'collectionName', 'trackName', 'artworkUrl100',
                                     'releaseDate', 'collectionExplicitness',
                                     'trackExplicitness', 'discCount', 'discNumber',
                                     'trackCount', 'trackNumber', 'trackTimeMillis',
                                     'country', 'currency', 'primaryGenreName')

    def self.paths(directory)
      Array.new(Find.find(directory).select { |p| /.*\.M4A$/i =~ p })
    end

    def self.parse(song_info)
      relevant_info = Array.new
      (0..ITUNES_TAG_KEYS.length).each { |index|
        relevant_info.push(song_info[ITUNES_TAG_KEYS.at(index)])
      }
      return relevant_info
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

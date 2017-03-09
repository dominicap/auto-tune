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
      Array.new(Find.find(directory).select { |p| /.*\.M4A$/i =~ p || /.*\.MP3$/i =~ p })
    end

    def self.parse(tags_hash, track_number)
      (0..tags_hash['resultCount'].to_i).each { |key|
        itunes_track_number = tags_hash.dig('results', key, 'trackNumber')
        if track_number == itunes_track_number.to_i
          info = Array.new
          (0..ITUNES_TAG_KEYS.length).each { |index|
            info.push(tags_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
          }
          return info
        end
      }
    end
  end
end

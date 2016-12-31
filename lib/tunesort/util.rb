require 'find'
require 'json'

module TuneSort
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

    def self.parse(directory, track_number)
      if File.exist?(directory + '/itunes_tags.json')
        tags_hash = JSON.parse(File.read(directory + '/itunes_tags.json'))
        unless tags_hash['resultCount'].to_i.zero?
          (0..tags_hash['resultCount'].to_i).each do |key|
            itunes_track_number = tags_hash.dig('results', key, 'trackNumber').to_i
            unless track_number.nil?
              if track_number.eql? itunes_track_number
                itunes_rating = tags_hash.dig('results', key, 'trackExplicitness')
                if itunes_rating == 'explicit'
                  info = []
                  (0..ITUNES_TAG_KEYS.length).each do |index|
                    info.push(tags_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
                  end
                  return info
                elsif itunes_rating == 'notExplicit'
                  info = []
                  (0..ITUNES_TAG_KEYS.length).each do |index|
                    info.push(tags_hash.dig('results', key, ITUNES_TAG_KEYS[index]))
                  end
                  return info
                end
              end
            end
          end
        end
      else
        raise 'tunesort: error: iTunes tags file has not been downloaded'
      end
    end
  end
end

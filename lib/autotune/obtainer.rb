require 'json'
require 'net/http'
require 'taglib'

module AutoTune
  class Obtainer
    def self.get_tags(album, artist, directory)
      album_id = get_album_id(album, artist, directory)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}&entity=song"
      return Net::HTTP.get(URI.parse(lookup))
    end

    def self.get_track_number(song)
      TagLib::FileRef.open(song) do |tune|
        return tune.tag.track unless tune.nil?
      end
    end

    def self.get_album_id(album, artist, directory)
      lookup = 'https://itunes.apple.com/search?term='
      query = (artist + ' ' + album).downcase.tr!(' ', '+') + '&entity=album'
      album_ids_hash = JSON.parse(Net::HTTP.get(URI.parse(lookup + query)))
      unless album_ids_hash['resultCount'].to_i.zero?
        (0..tags_hash['resultCount'].to_i).each do |key|
          itunes_rating = tags_hash.dig('results', key, 'contentAdvisoryRating')
          unless itunes_rating == 'clean'
            return tags_hash.dig('results', key, 'collectionId')
          end
        end
      end
    end

    private_class_method :self.get_album_id
  end
end

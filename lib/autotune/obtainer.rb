require 'json'
require 'net/http'
require 'taglib'

module AutoTune
  class Obtainer
    def self.get_tags(album, artist)
      album_id = get_album_id(album, artist)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}&entity=song"
      return JSON.parse(Net::HTTP.get(URI.parse(lookup)))
    end

    def self.get_artwork(artwork_url, directory)
      artwork_url = artwork_url.gsub!(/100x100bb.jpg/, '1000000000x1000000000bb.jpg')
      File.write(directory + '/artwork.jpg', Net::HTTP.get(URI.parse(URI.encode(artwork_url))))
      return directory + '/artwork.jpg'
    end

    def self.get_track_number(song)
      TagLib::FileRef.open(song) do |tune|
        return tune.tag.track unless tune.nil?
      end
    end

    def self.get_copyright(album, artist)
      album_id = get_album_id(album, artist)
      lookup = "https://itunes.apple.com/us/album/id#{album_id}"
      return Net::HTTP.get(URI.parse(lookup)).split(/<li class="copyright">(.*?)<\/li>/)[1]
    end

    def self.get_album_id(album, artist)
      lookup = 'https://itunes.apple.com/search?term='
      query = (artist + ' ' + album).downcase.tr!(' ', '+') + '&entity=album'
      result_hash = JSON.parse(Net::HTTP.get(URI.parse(lookup + query)))
      unless result_hash['resultCount'].to_i.zero?
        (0..result_hash['resultCount'].to_i).each do |key|
          itunes_rating = result_hash.dig('results', key, 'contentAdvisoryRating')
          unless itunes_rating == 'clean'
            return result_hash.dig('results', key, 'collectionId')
          end
        end
      end
    end

    private_class_method :get_album_id
  end
end

require 'json'
require 'net/http'
require 'taglib'
require 'tmpdir'

module AutoTune
  class Obtainer
    def self.get_tags(album, artist, clean, deluxe)
      album_id = get_album_id(album, artist, clean, deluxe)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}&entity=song"
      return JSON.parse(Net::HTTP.get(URI.parse(lookup)))
    end

    def self.get_album_details(album, artist, clean, deluxe)
      album_id = get_album_id(album, artist, clean, deluxe)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}"
      return JSON.parse(Net::HTTP.get(URI.parse(lookup)))
    end

    def self.get_artwork(album_details)
      artwork_url = album_details.dig('results', 0, 'artworkUrl100')
      artwork_url = artwork_url.gsub!(/100x100bb.jpg/, '1000000000x1000000000bb.jpg')
      File.write('/var/tmp/artwork.jpg', Net::HTTP.get(URI.parse(URI.encode(artwork_url.to_s))))
    end

    def self.get_track_number(song)
      TagLib::FileRef.open(song) do |tune|
        return tune.tag.track unless tune.nil?
      end
    end

    def self.get_genre_id(album_details)
      genre_name = album_details.dig('results', 0, 'primaryGenreName')
      genre_appendix_lookup =
          'http://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'
      unless genre_name.nil?
        genre_appendix = JSON.parse(Net::HTTP.get(URI.parse(genre_appendix_lookup)))
        genre_appendix['34']['subgenres'].each { |genres|
          genres.each { |genre|
            unless genre.nil?
              if genre['name'].to_s.include? genre_name
                return genre['id'].to_i
              end
            end
          }
        }
      end
    end

    def self.get_copyright(album_details)
      return album_details.dig('results', 0, 'copyright').to_s
    end

    def self.get_album_artist(album_details)
      return album_details.dig('results', 0, 'artistName').to_s
    end

    def self.get_album_id(album, artist, clean, deluxe)
      lookup = 'https://itunes.apple.com/search?term='
      query = (artist + ' ' + album).downcase.tr!(' ', '+') + '&entity=album'
      result_hash = JSON.parse(Net::HTTP.get(URI.parse(lookup + query)))
      unless result_hash['resultCount'].to_i.zero?
        (0..result_hash['resultCount'].to_i).each do |key|
          itunes_rating = result_hash.dig('results', key, 'contentAdvisoryRating')
          if itunes_rating == 'Clean' && clean
            if (result_hash.dig('results', key, 'collectionName').include? 'Deluxe') && deluxe
              return result_hash.dig('results', key, 'collectionId')
            elsif !(result_hash.dig('results', key, 'collectionName').include? 'Deluxe') && !deluxe
              return result_hash.dig('results', key, 'collectionId')
            end
          elsif (itunes_rating == 'Explicit' || itunes_rating == 'notExplicit') && !clean
            if (result_hash.dig('results', key, 'collectionName').include? 'Deluxe') && deluxe
              return result_hash.dig('results', key, 'collectionId')
            elsif !(result_hash.dig('results', key, 'collectionName').include? 'Deluxe') && !deluxe
              return result_hash.dig('results', key, 'collectionId')
            end
          end
        end
      end
    end

    private_class_method :get_album_id
  end
end

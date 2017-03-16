require 'json'
require 'net/http'
require 'taglib'
require 'rspotify'

module AutoTune
  class Obtainer

    CLIENT_ID = 'e38aca60500943758be6be6e624b2e35'
    CLIENT_SECRET = '68c60cc5600c48e0ab6f28f5a5e24040'

    def self.get_tags(album, artist, clean, deluxe)
      album_id = get_album_id(album, artist, clean, deluxe)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}&entity=song"
      return JSON.parse(Net::HTTP.get(URI.parse(lookup)))
    end

    def self.get_artwork(album_tags, directory)
      artwork_url = AutoTune::Util.parse(album_tags, 0)[6]
      artwork_url = artwork_url.gsub!(/100x100bb.jpg/, '1000000000x1000000000bb.jpg')
      File.write(directory + '/artwork.jpg', Net::HTTP.get(URI.parse(URI.encode(artwork_url.to_s))))
    end

    def self.get_track_number(song)
      TagLib::FileRef.open(song) do |tune|
        return tune.tag.track unless tune.nil?
      end
    end

    def self.get_tempo(album_tags, track_number)
      artist = AutoTune::Util.parse(album_tags, 0)[3]
      title = AutoTune::Util.parse(album_tags, track_number)[5].slice(0..title.index('(') - 1)
      RSpotify.authenticate(CLIENT_ID, CLIENT_SECRET)
      unless RSpotify::Track.search(artist.downcase + ' ' + title.downcase).all? &:nil?
        RSpotify::Track.search(artist.downcase + ' ' + title.downcase).max_by { |element|
          element.audio_features.tempo.round }.audio_features.tempo.round
      end
    end

    def self.get_genre_id(genre_name)
      genre_appendix_lookup =
          'http://itunes.apple.com/WebObjects/MZStoreServices.woa/ws/genres'
      unless genre_name.nil?
        genre_appendix = JSON.parse(Net::HTTP.get(URI.parse(genre_appendix_lookup)))
        genre_appendix['34']['subgenres'].each { |genres|
          genres.each { |genre|
            unless genre.nil?
              if genre['name'].to_s.include? genre_name
                return genre['id']
              end
            end
          }
        }
      end
    end

    def self.get_copyright(album_tags)
      album_id = album_tags.dig(album_tags.dig('resultCount','results', 0, 'collectionId'))
      lookup = "https://itunes.apple.com/us/album/id#{album_id}"
      return Net::HTTP.get(URI.parse(lookup)).split(/<li class="copyright">(.*?)<\/li>/)[1]
    end

    def self.get_album_artist(result_hash)
      return AutoTune::Util.parse(result_hash, 0)[3].to_s
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

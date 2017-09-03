require 'json'
require 'net/http'
require 'taglib'

module AutoTune
  class Obtainer
    def self.get_tags(album, artist, clean, deluxe)
      album_id = get_album_id(album, artist, clean, deluxe)
      lookup = "https://itunes.apple.com/lookup?id=#{album_id}&entity=song"
      return JSON.parse(Net::HTTP.get(URI.parse(lookup)))
    end

    def self.fingerprint(song)
      output = JSON.parse(`fpcalc -json "#{song}"`)
      return [output['duration'].round, output['fingerprint'], song]
    end

    def self.identify(fingerprint)
      file = File.join(File.dirname(__FILE__), 'config/keys.json')
      key = JSON.parse(File.read(file))['ACOUSTID']
      base = "http://api.acoustid.org/v2/lookup?client=#{key}"
      query = "&duration=#{fingerprint[0]}&meta=recordings+releasegroups+compress&fingerprint=#{fingerprint[1]}"

      output = JSON.parse(Net::HTTP.get(URI.parse(base + query)))

      begin
        if output['results'][0]['score'] > 0.8
          results = output['results'][0]['recordings'][0]
          return [results['artists'][0]['name'], results['releasegroups'][0]['title'], results['title']]
        end
      rescue
        print "Please enter the details for the song #{song}: "
      end
    end

    def self.get_album_details(album_id)
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

    def self.get_song_info(album, artist, song, clean, deluxe)
      lookup = 'https://itunes.apple.com/search?term='
      query = (artist + ' ' + album + ' ' + song).downcase.tr!(' ', '+') + '&entity=song'
      result_hash = JSON.parse(Net::HTTP.get(URI.parse(lookup + query)))
      song_info = Hash.new
      unless get_positions(result_hash, deluxe).nil?
        get_positions(result_hash, deluxe).each do |key|
          if song_info.nil? || song_info.empty?
            song_info = find_song(result_hash, key, clean)
          end
        end
        return song_info
      end
    end

    def self.get_positions(result_hash, deluxe)
      unless result_hash['resultCount'].to_i.zero?
        song_quantities = Hash.new
        (0..result_hash['resultCount'].to_i - 1).each do |key|
          song_quantities[key] = result_hash.dig('results', key, 'trackCount')
        end
        (0..song_quantities.length).each do |key|
          if deluxe
            unless song_quantities[key] == song_quantities.values.max
              song_quantities.delete(key)
            end
          else
            unless song_quantities[key] == song_quantities.values.min
              song_quantities.delete(key)
            end
          end
        end
        return song_quantities.keys
      end
    end

    def self.find_song(result_hash, key, clean)
      itunes_rating = result_hash.dig('results', key, 'contentAdvisoryRating')
      itunes_rating = result_hash.dig('results', key, 'collectionExplicitness') if itunes_rating.nil?
      if (itunes_rating == 'Clean' || itunes_rating == 'notExplicit') && clean
        return result_hash.dig('results', key)
      elsif (itunes_rating == 'Explicit' || itunes_rating == 'notExplicit') && !clean
        return result_hash.dig('results', key)
      end
    end

    private_class_method :get_positions
    private_class_method :find_song
  end
end

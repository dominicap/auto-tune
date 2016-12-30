require 'net/http'
require 'taglib'

module TuneSort
  class Obtainer
    def self.get_tags(album, artist, directory)
      json_file_location = directory + '/itunes_tags.json'
      unless File.exist?(json_file_location)
        base_lookup_url = 'https://itunes.apple.com/search?term='
        lookup = base_lookup_url + (artist + ' ' + album).downcase.tr!(' ', '+')
        File.write(json_file_location, Net::HTTP.get(URI.parse(lookup)))
      end
    end

    def self.get_track_number(song)
      TagLib::FileRef.open(song) do |tune|
        return tune.tag.track unless tune.nil?
      end
    end
  end
end

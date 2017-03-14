require 'find'
require 'fileutils'
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

    def self.convert(path, new_path)
      system("afconvert #{path} -f m4af -d aac -b 256000 -q 127 -s 2 #{new_path}")
    end

    def self.make_dirs(path)
      directory_name = "#{File.dirname(path)}/converted"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      return "#{directory_name}/#{File.basename(path, File.extname(path))}.m4a"
    end

    def self.clean(path)
      FileUtils.rm_rf("#{File.dirname(path)}/converted")
      FileUtils.delete("#{File.dirname(path)}/artwork.jpg")
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

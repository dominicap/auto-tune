require 'taglib'

module AutoTune
  class Designator
    def self.set_artist(artist, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.artist(artist)
          end
        end
      end
    end

    def self.set_album(album, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.album(album)
          end
        end
      end
    end

    def self.set_year(year, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.year(year)
          end
        end
      end
    end

    def self.set_track(track, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.track(track)
          end
        end
      end
    end

    def self.set_title(title, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.title(title)
          end
        end
      end
    end

    def self.set_genre(genre, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.genre(genre)
          end
        end
      end
    end

    def self.set_copyright(copyright, song)
      unless song.nil?
        if song =~ /.*\.MP3$/i
          TagLib::MPEG::File.open(song) do |tune|
            tag = tune.id3v2_tag
            frame = TagLib::ID3v2::TextIdentificationFrame.new('TCOP', TagLib::String::UTF8)
            unless copyright.nil?
              frame.text = copyright
              tag.add_frame(frame)
              tune.save
            end
          end
        elsif song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless copyright.nil?
              item = TagLib::MP4::Item.from_string_list([copyright])
              tune.tag.item_list_map.insert('cprt', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_album_artist_name(album_artist, song)
      unless song.nil?
        if song =~ /.*\.MP3$/i
          TagLib::MPEG::File.open(song) do |tune|
            tag = tune.id3v2_tag
            frame = TagLib::ID3v2::TextIdentificationFrame.new('TPE2', TagLib::String::UTF8)
            unless album_artist.nil?
              frame.text = album_artist
              tag.add_frame(frame)
              tune.save
            end
          end
        elsif song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless album_artist.nil?
              item = TagLib::MP4::Item.from_string_list([album_artist])
              tune.tag.item_list_map.insert('aART', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_content_id(content_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless content_id.nil?
              item = TagLib::MP4::Item.from_string_list([content_id])
              tune.tag.item_list_map.insert('cnID', item)
              tune.save
            end
          end
        end
      end
    end
  end
end

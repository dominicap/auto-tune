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

    def self.set_title(title, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.title(title)
          end
        end
      end
    end

    def self.track_number(track_number, song)
      unless song.nil?
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.track_number(track_number)
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

    def self.set_catalogue_id(catalogue_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless catalogue_id.nil?
              item = TagLib::MP4::Item.from_string_list([catalogue_id])
              tune.tag.item_list_map.insert('cnID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_track_number(track_number, total_tracks, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless track_number.nil? || total_tracks.nil?
              item = TagLib::MP4::Item.from_int_pair([track_number, total_tracks])
              tune.tag.item_list_map.insert('trkn', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_playlist_id(playlist_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless playlist_id.nil?
              item = TagLib::MP4::Item.from_string_list([playlist_id])
              tune.tag.item_list_map.insert('plID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_artist_id(artist_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless artist_id.nil?
              item = TagLib::MP4::Item.from_string_list([artist_id])
              tune.tag.item_list_map.insert('atID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_composer_id(composer_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless composer_id.nil?
              item = TagLib::MP4::Item.from_string_list([composer_id])
              tune.tag.item_list_map.insert('cmID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_genre_id(genre_id, song)
      unless song.nil?
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless genre_id.nil?
              item = TagLib::MP4::Item.from_string_list([genre_id])
              tune.tag.item_list_map.insert('geID', item)
              tune.save
            end
          end
        end
      end
    end
  end
end

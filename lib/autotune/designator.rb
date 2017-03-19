require 'taglib'

module AutoTune
  class Designator
    def self.set_artist_id(artist_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless artist_id.nil?
              item = TagLib::MP4::Item.from_int(artist_id)
              tune.tag.item_list_map.insert('atID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_playlist_id(playlist_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless playlist_id.nil?
              item = TagLib::MP4::Item.from_int(playlist_id)
              tune.tag.item_list_map.insert('plID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_catalogue_id(catalogue_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless catalogue_id.nil?
              item = TagLib::MP4::Item.from_int(catalogue_id)
              tune.tag.item_list_map.insert('cnID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_artist(artist, song)
      if File.exists? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.artist = artist unless artist.nil?
            tune.save
          end
        end
      end
    end

    def self.set_album(album, song)
      if File.exists? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.album = album unless album.nil?
            tune.save
          end
        end
      end
    end

    def self.set_title(title, song)
      if File.exists? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.title = title unless title.nil?
            tune.save
          end
        end
      end
    end

    def self.set_release_date(release_date, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless release_date.nil?
              item = TagLib::MP4::Item.from_string_list([release_date])
              tune.tag.item_list_map.insert('©day', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_rating(rating, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless rating.nil?
              if rating.include? 'clean'
                item = TagLib::MP4::Item.from_int(2)
                tune.tag.item_list_map.insert('rtng', item)
                tune.save
              elsif rating.include? 'explicit'
                item = TagLib::MP4::Item.from_int(1)
                tune.tag.item_list_map.insert('rtng', item)
                tune.save
              elsif rating.include? 'notExplicit'
                item = TagLib::MP4::Item.from_int(0)
                tune.tag.item_list_map.insert('rtng', item)
                tune.save
              end
            end
          end
        end
      end
    end

    def self.set_genre(genre, song)
      if File.exists? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.genre = genre unless genre.nil?
            tune.save
          end
        end
      end
    end

    def self.track_number(track_number, song)
      if File.exists? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.track = track_number unless track_number.nil?
            tune.save
          end
        end
      end
    end

    def self.set_artwork(artwork, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless artwork.nil?
              image_data = File.open(artwork, 'rb') { |f| f.read }
              cover_art = TagLib::MP4::CoverArt.new(TagLib::MP4::CoverArt::JPEG, image_data)
              item = TagLib::MP4::Item.from_cover_art_list([cover_art])
              tune.tag.item_list_map.insert('covr', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_copyright(copyright, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
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
      if File.exists? song
        if song =~ /.*\.M4A$/i
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
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless catalogue_id.nil?
              item = TagLib::MP4::Item.from_int(catalogue_id)
              tune.tag.item_list_map.insert('cnID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_track_number(track_number, total_tracks, song)
      if File.exists? song
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

    def self.set_disk_number(disk_number, total_disks, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless disk_number.nil? || total_disks.nil?
              item = TagLib::MP4::Item.from_int_pair([disk_number, total_disks])
              tune.tag.item_list_map.insert('disk', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_playlist_id(playlist_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless playlist_id.nil?
              item = TagLib::MP4::Item.from_int(playlist_id)
              tune.tag.item_list_map.insert('plID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_composer_id(composer_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless composer_id.nil?
              item = TagLib::MP4::Item.from_int(composer_id)
              tune.tag.item_list_map.insert('cmID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_genre_id(genre_id, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless genre_id.nil?
              item = TagLib::MP4::Item.from_int(genre_id)
              tune.tag.item_list_map.insert('geID', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_tempo(tempo, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless tempo.nil?
              item = TagLib::MP4::Item.from_int(tempo)
              tune.tag.item_list_map.insert('tmpo', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_composer(composer, song)
      if File.exists? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless composer.nil?
              item = TagLib::MP4::Item.from_string_list([composer])
              tune.tag.item_list_map.insert('©wrt', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_all(tune_tags, song)
      set_artist_id(tune_tags.at(0), song)
      set_playlist_id(tune_tags.at(1), song)
      set_catalogue_id(tune_tags.at(2), song)
      set_artist(tune_tags.at(3), song)
      set_album(tune_tags.at(4), song)
      set_title(tune_tags.at(5), song)
      set_release_date(tune_tags.at(7), song)
      set_rating(tune_tags.at(9), song)
      set_disk_number(tune_tags.at(11), tune_tags.at(10), song)
      set_track_number(tune_tags.at(13), tune_tags.at(12), song)
      set_genre(tune_tags.at(17), song)
      set_album_artist_name(tune_tags.at(19), song)
      set_genre_id(tune_tags.at(20), song)
      set_copyright(tune_tags.at(21), song)
      set_composer('', song)
      set_artwork('/var/tmp/artwork.jpg', song)
    end
  end
end

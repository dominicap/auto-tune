require 'taglib'

module AutoTune
  class Designator
    def self.set_artist_id(artist_id, song)
      if File.exist? song
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
      if File.exist? song
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
      if File.exist? song
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
      if File.exist? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.artist = artist unless artist.nil?
            tune.save
          end
        end
      end
    end

    def self.set_album(album, song)
      if File.exist? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.album = album unless album.nil?
            tune.save
          end
        end
      end
    end

    def self.set_title(title, song)
      if File.exist? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.title = title unless title.nil?
            tune.save
          end
        end
      end
    end

    def self.set_lyrics(lyrics, song)
      if File.exist? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless lyrics.nil?
              item = TagLib::MP4::Item.from_string_list([lyrics])
              tune.tag.item_list_map.insert('©lyr', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_release_date(release_date, song)
      if File.exist? song
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

    def self.set_artwork(artwork, song)
      if File.exist? song
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

    def self.set_tempo(tempo, song)
      if File.exist? song
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

    def self.set_rating(rating, song)
      if File.exist? song
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

    def self.set_disk_number(disk_number, total_disks, song)
      if File.exist? song
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

    def self.set_composer(composer, song)
      if File.exist? song
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

    def self.set_track_number(track_number, total_tracks, song)
      if File.exist? song
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

    def self.set_description(description, song)
      if File.exist? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless description.nil?
              item = TagLib::MP4::Item.from_string_list([description])
              tune.tag.item_list_map.insert('©des', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_comments(comments, song)
      if File.exist? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless comments.nil?
              item = TagLib::MP4::Item.from_string_list([comments])
              tune.tag.item_list_map.insert('©cmt', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_composer_id(composer_id, song)
      if File.exist? song
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

    def self.set_genre(genre, song)
      if File.exist? song
        TagLib::FileRef.open(song) do |tune|
          unless tune.null?
            tune.tag.genre = genre unless genre.nil?
            tune.save
          end
        end
      end
    end

    def set_purchase_date(purchase_date, song)
      if File.exist? song
        if song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless purchase_date.nil?
              item = TagLib::MP4::Item.from_string_list([purchase_date])
              tune.tag.item_list_map.insert('purd', item)
              tune.save
            end
          end
        end
      end
    end

    def self.set_album_artist_name(album_artist, song)
      if File.exist? song
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

    def self.set_genre_id(genre_id, song)
      if File.exist? song
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

    def self.set_copyright(copyright, song)
      if File.exist? song
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

    def self.set_all(tune_tags, song)
      functions = ['set_lyrics', 'set_artwork', 'set_tempo', 'set_composer', 'set_description', 'set_comments', 'set_composer_id']
      AutoTune::Designator.methods(false).each_with_index do |function, index|
        if functions.include? function
          AutoTune::Designator.send(:"#{function}", nil, song)
        elsif function == 'set_disk_number' || function == 'set_track_number'
          AutoTune::Designator.send(:"#{function}", index, index - 1, song)
        else
          AutoTune::Designator.send(:"#{function}", tune_tags[index], song) unless index > 21
        end
      end
      set_artwork('/var/tmp/artwork.jpg', song)
    end
  end
end


# AutoTune::Designator.methods(false).each_with_index do |method, index|
#   puts method, index
# end

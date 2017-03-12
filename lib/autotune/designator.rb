require 'taglib'

module AutoTune
  class Designator
    def self.set_album_artist_name(album_artist_name, song)
      unless song.nil?
        if song =~ /.*\.MP3$/i
          TagLib::MPEG::File.open(song) do |tune|
            tag = tune.id3v2_tag
            album_artist = TagLib::ID3v2::TextIdentificationFrame.new('TPE2', TagLib::String::UTF8)
            unless album_artist_name.nil?
              album_artist.text = album_artist_name
              tag.add_frame(tpe2)
              tune.save
            end
          end
        elsif song =~ /.*\.M4A$/i
          TagLib::MP4::File.open(song) do |tune|
            unless album_artist_name.nil?
              item = TagLib::MP4::Item.from_string_list([album_artist_name])
              tune.tag.item_list_map.insert('aART', item)
              tune.save
            end
          end
        end
      end
    end
  end
end

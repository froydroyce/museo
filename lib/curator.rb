require 'csv'

class Curator
  attr_reader :artists, :photographs

  def initialize
    @artists = []
    @photographs = []
  end

  def add_photograph(photo)
    @photographs << Photograph.new(photo)
  end

  def add_artist(artist)
    @artists << Artist.new(artist)
  end

  def find_artist_by_id(id)
    @artists.find { |artist| artist.id == id}
  end

  def find_photograph_by_id(id)
    @photographs.find { |photo| photo.id == id}
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all { |photo| photo.artist_id == artist.id}
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist|
      find_photographs_by_artist(artist).length > 1
    end
  end

  def find_artists_by_country(country)
    @artists.find_all do |artist|
      artist.country == country
    end
  end

  def photographs_taken_by_artist_from(country)
    find_artists_by_country(country).flat_map do |artist|
      find_photographs_by_artist(artist)
    end
  end

  def load_photographs(filepath)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      @photographs << Photograph.new(row)
    end
  end

  def load_artists(filepath)
    CSV.foreach(filepath, headers: true, header_converters: :symbol) do |row|
      @artists << Artist.new(row)
    end
  end

  def photographs_taken_between(range)
    @photographs.find_all do |photo|
      range.include? photo.year
    end
  end

  def artists_photographs_by_age(artist)
    photos_by_age = {}
    find_photographs_by_artist(artist).each do |photo|
      photos_by_age[photo.year - artist.born.to_i] = photo.name
    end
    photos_by_age
  end
end

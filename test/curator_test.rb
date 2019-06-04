require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/stub_any_instance'
require './lib/artist'
require './lib/photograph'
require './lib/curator'
require 'pry'


class CuratorTest < MiniTest::Test
  def setup
    @curator = Curator.new
    @photo_1 = {
      id: "1",
      name: "Rue Mouffetard, Paris (Boy with Bottles)",
      artist_id: "1",
      year: "1954"
    }

    @photo_2 = {
      id: "2",
      name: "Moonrise, Hernandez",
      artist_id: "2",
      year: "1941"
    }

    @photo_3 = {
      id: "3",
      name: "Identical Twins, Roselle, New Jersey",
      artist_id: "3",
      year: "1967"
    }

    @photo_4 = {
      id: "4",
      name: "Child with Toy Hand Grenade in Central Park",
      artist_id: "3",
      year: "1962"
    }

    @artist_1 = {
      id: "1",
      name: "Henri Cartier-Bresson",
      born: "1908",
      died: "2004",
      country: "France"
    }

    @artist_2 = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }

    @artist_3 = {
      id: "3",
      name: "Diane Arbus",
      born: "1923",
      died: "1971",
      country: "United States"
    }
  end

  def test_it_exists

    assert_instance_of Curator, @curator
  end

  def test_it_starts_with_no_artists

    assert_equal [], @curator.artists
  end

  def test_it_starts_with_no_photographs

    assert_equal [], @curator.photographs
  end

  def test_it_can_add_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_instance_of Photograph, @curator.photographs.first
    assert_instance_of Photograph, @curator.photographs.last
    assert_equal "Rue Mouffetard, Paris (Boy with Bottles)", @curator.photographs.first.name
  end

  def test_it_can_add_artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_instance_of Artist, @curator.artists.first
    assert_instance_of Artist, @curator.artists.last
    assert_equal "Henri Cartier-Bresson", @curator.artists.first.name
  end

  def test_it_can_find_artist_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal @artist_1[:name], @curator.find_artist_by_id("1").name
  end

  def test_it_can_find_photograph_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal @photo_2[:name], @curator.find_photograph_by_id("2").name
  end

  def test_it_can_find_photographs_by_artist
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal @photo_3[:name], @curator.find_photographs_by_artist(diane_arbus).first.name
    assert_equal @photo_4[:name], @curator.find_photographs_by_artist(diane_arbus).last.name
  end

  def test_it_can_find_artists_with_multiple_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal [diane_arbus], @curator.artists_with_multiple_photographs
    assert_equal 1, @curator.artists_with_multiple_photographs.length
    assert diane_arbus == @curator.artists_with_multiple_photographs.first
  end

  def test_it_can_find_artist_by_country
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")
    ansel_adams = @curator.find_artist_by_id("2")

    assert_equal [ansel_adams, diane_arbus], @curator.find_artists_by_country("United States")
  end

  def test_it_can_get_photographs_taken_by_artist_from_a_country
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")
    moonrise  = @curator.find_photograph_by_id("2")
    identical  = @curator.find_photograph_by_id("3")
    child  = @curator.find_photograph_by_id("4")

    assert_equal [moonrise, identical, child], @curator.photographs_taken_by_artist_from("United States")
  end

  def test_it_can_load_photographs
    @curator.load_photographs('./data/photographs.csv')
    rue = @curator.find_photograph_by_id("1")
    moonrise  = @curator.find_photograph_by_id("2")
    identical  = @curator.find_photograph_by_id("3")
    child  = @curator.find_photograph_by_id("4")

    assert_equal [rue, moonrise, identical, child], @curator.photographs
  end

  def test_it_can_load_artists
    @curator.load_artists('./data/artists.csv')
    henri = @curator.find_artist_by_id("1")
    ansel = @curator.find_artist_by_id("2")
    diane = @curator.find_artist_by_id("3")
    walker = @curator.find_artist_by_id("4")
    manuel = @curator.find_artist_by_id("5")
    bill = @curator.find_artist_by_id("6")

    assert_equal [henri, ansel, diane, walker, manuel, bill], @curator.artists
  end

  def test_it_can_find_photo_from_year_range
    @curator.load_photographs('./data/photographs.csv')
    rue = @curator.find_photograph_by_id("1")
    moonrise  = @curator.find_photograph_by_id("2")
    identical  = @curator.find_photograph_by_id("3")
    child  = @curator.find_photograph_by_id("4")

    assert_equal [rue, child], @curator.photographs_taken_between(1950..1965)
  end

  def test_it_can_find_artists_photographs_by_age
    @curator.load_artists('./data/artists.csv')
    @curator.load_photographs('./data/photographs.csv')
    diane_arbus = @curator.find_artist_by_id("3")
    expected = {
      44=>"Identical Twins, Roselle, New Jersey",
      39=>"Child with Toy Hand Grenade in Central Park"
    }

    assert_equal expected, @curator.artists_photographs_by_age(diane_arbus)
  end
end

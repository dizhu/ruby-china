class Location < ApplicationRecord
  acts_as_cached version: 1, expires_in: 1.week

  has_many :users

  scope :hot, -> { order(users_count: :desc) }

  validates :name, uniqueness: { case_sensitive: false }

  before_save { |loc| loc.name = loc.name.downcase.strip }

  def self.location_find_by_name(name)
    return nil if name.blank?
    name = name.downcase.strip
    #fixed by jiang 此处postgrelsql语法和其他处不一样～
    where("name like '%#{name}%'").first
  end

  def self.location_find_or_create_by_name(name)
    name = name.strip
    unless (location = location_find_by_name(name))
      location = create(name: name)
    end
    location
  end
end

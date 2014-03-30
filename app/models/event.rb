class Event < ActiveRecord::Base
  require 'unidecoder'
  
  attr_accessible :title, :price, :address, :telNo, :venue, :link, :latitude, :longitude, :email, :description, :event_image, :event_image_file_name, :event_image_content_type, :event_image_file_size, :event_image_updated_at, :catId, :zip_code, :zip_name, :geocode_address, :eventaddress, :image, :remote_image_url, :charge, :image_tmp, :image_processing, :user_id, :event_timings_attributes, :_destroy, :eventtype
  attr_accessor :_destroy
  has_archive

  scope :upcoming, order('date ASC')
  scope :featured, where(featured: 1)
  scope :paid, where(charge: 1)

  mount_uploader :image, ImageUploader
  process_in_background :image
  store_in_background :image

  has_one :zip
  has_one :category
  belongs_to :user
  has_many :event_timings, dependent: :destroy
  accepts_nested_attributes_for :event_timings, reject_if: proc { |a| a.all? { |key, value| key == '_destroy' || value.blank? } }, allow_destroy: :true
  
  validates_presence_of :title
  validates_associated :event_timings

  after_save :set_address
  after_save :set_imageUrl
  after_save :set_imageThumbUrl
  before_save :filter_special_chars
  after_destroy :delete_event_image
  
  geocoded_by :combine_address
  after_validation :geocode

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true, encoding: "ISO-8859-1:utf-8") do |row|
  #     @findEvent = Event.where("title=(?) and venue=(?)",row["title"].gsub('&','and'),row["venue"].gsub('&','and'))
  #     event_timings_attributes={"event_timings_attributes"=>{"0"=>{"date"=>row["date"],"time"=>row["time"]}}}
  #     unless @findEvent.blank?
  #       event_timings_attributes={"date"=>row["date"],"time"=>row["time"],"event_id"=>@findEvent.last.id}
  #       EventTiming.create!(event_timings_attributes)
  #       @newEvent = @findEvent.last
  #     else
  #       @newEvent = Event.create!(row.to_hash.merge(event_timings_attributes).except("time", "date"))
  #     end
  #     if !@newEvent.link.blank? || @newEvent.link_changed? 
  #       BitlyWorker.perform_async(@newEvent.id)
  #     end
  #   end
  # end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: "ISO-8859-1:utf-8") do |row|
      @findEvent = Event.where("title=(?) and venue=(?)",row["title"].gsub('&','and'),row["venue"].gsub('&','and'))
      event_timings_default = {"title"=>row["title"], "remote_image_url"=>row["remote_image_url"], "link"=>row["link"], "description"=>row["description"], "venue"=>row["venue"], "address"=>row["address"], "zip_code"=>row["zip_code"], "price"=>row["price"], "telNo"=>row["telNo"], "charge"=>row["charge"], "catId"=>row["catId"]}
      event_timings_attributes={}
      row_to_count = (row.length - 12)
      for i in 0..(row_to_count)
        if row["date_#{i}"].present?
          event_timings_attributes[i] = {"date"=>row["date_#{i}"],"time"=>row["time_#{i}"]}
        end
      end
      event_timings_attributes_hash = {"event_timings_attributes"=>event_timings_attributes}
      # event_timings_attributes={"event_timings_attributes"=>{"0"=>{"date"=>row["date"],"time"=>row["time"]}}}
      if @findEvent.blank?
        # event_timings_attributes={"date"=>row["date"],"time"=>row["time"],"event_id"=>@findEvent.last.id}
        @newEvent = Event.create!(event_timings_attributes_hash.merge(event_timings_default))
      else
        @newEvent = @findEvent.last
        @newEvent.update_attributes(event_timings_attributes_hash.merge(event_timings_default))
      end
      if !@newEvent.link.blank? || @newEvent.link_changed? 
        BitlyWorker.perform_async(@newEvent.id)
      end
    end
  end

  def filter_special_chars
    self.attributes.map{|key,value| self[key] =('title_description_venue'.include?(key))? value.to_s.gsub('&','and').to_ascii : value}
  end
  def combine_address
    self.geocode_address = "#{eventaddress}"
  end
  def delete_event_image
    self.remove_image!
  end
  def set_address
    if eventaddress != "#{address} Birmingham, AL #{zip_code}"
      self.eventaddress = "#{address} Birmingham, AL #{zip_code}"
      self.save
    end
  end
  def set_imageUrl
    if imageUrl != "http://eventsapp.us/uploads/event_image/#{id}/main.jpg"
      self.imageUrl = "http://eventsapp.us/uploads/event_image/#{id}/main.jpg"
      self.save
    end
  end
  def set_imageThumbUrl
    if imageThumbUrl != "http://eventsapp.us/uploads/event_image/#{id}/thumb.jpg"
      self.imageThumbUrl = "http://eventsapp.us/uploads/event_image/#{id}/thumb.jpg"
      self.save
    end
  end
end
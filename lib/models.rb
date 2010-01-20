require 'active_record'

DatabaseAuthentication = {
  'development' => {
    'adapter' => 'mysql',
    'host' => 'localhost',
    'username' => 'root',
    'password' => '',
    'reconnect' => true,
    'database' => 'snip',
    'pool' => 5
  },
  'production' => {
    'adapter' => 'mysql',
    'host' => 'localhost',
    'username' => 'homecamp',
    'password' => 'homecamp01',
    'reconnect' => true,
    'database' => 'snip',
    'pool' => 5
  }
}

ActiveRecord::Base.configurations = DatabaseAuthentication
ActiveRecord::Base.establish_connection ENV['RACK_ENV'] || 'development'
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__)+'/../log/database.log')

class Snippet < ActiveRecord::Base
  attr_reader :recently_reverted
  has_many :revisions, :dependent => :destroy

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :data
  validates_uniqueness_of :data  
  
  default_scope :order => 'title ASC'
  
  before_save :version_it, :if => :should_version?

  def should_version?
    !new_record? && data_changed? && !recently_reverted
  end
  
  def version_it
    revisions.build :version => version, :data => data_was
    self.version += 1
  end
    
  def revision(v = 0)
    return self if v.zero? || v.blank?
    revisions.find_by_version(v.to_i)
  end
  
  def revert_to(v = 0)
    return true if v.zero? || v.blank?
    r = revision(v)
    return false unless r
    
    # Clone attributes
    [:updated_at, :created_at, :version, :data].each do |attribute|
      write_attribute(attribute.to_sym, r.read_attribute(attribute.to_sym))
    end

    @recently_reverted = true
    if save
      @recently_reverted = false
      revisions.all(:conditions => ['version >= ?', v]).each(&:destroy)
      return true
    else
      return false
    end    
  end
  
  def extension
    return nil unless title.include?('.')
    @extension ||= title.split(/\./).last
  end
  
  def to_s
    title
  end
end

class Revision < ActiveRecord::Base
  belongs_to :snippet
  default_scope :order => 'version ASC'
  validates_presence_of :data
end
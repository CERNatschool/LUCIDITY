class FluxSpectra < ActiveRecord::Base

  hobo_model # Don't put anything above this

  fields do
    name :string, :required, :unique, :index => true, :name => true
    #
    filetext :text
    #
    projectname :string
    #
    n_events :integer, :required, :default => 10000, :null => false
    #
    notes :markdown
    #
    source_cards_count :integer, :default => 0, :null => false
    #
    timestamps
  end

  attr_accessible :name

  attr_accessible :filetext

  attr_accessible :projectname

  attr_accessible :n_events

  attr_accessible :notes

  has_many :source_cards, :inverse_of => :flux_spectra, \
                          :dependent => :destroy, \
                          :accessible => true
  children :source_cards

  # The zip file containing the source cards.
  has_attached_file :sourcecardsfile, :accessible => true
  attr_accessible   :sourcecardsfile, :sourcecardsfile_file_name, \
                                      :sourcecardsfile_file_size, \
                                      :sourcecardsfile_content_type, \
                                      :sourcecardsfile_updated_at

  def sourcecardsfileurl(whichfile, mybool)
    return sourcecardsfile.url(whichfile, mybool) if Rails.env == "development"
    badurl = URI(sourcecardsthefile.url(whichfile, mybool))
    return 'http://www.cern-at-school.org/LUCIDITY_r1/public' + badurl.path.to_s
  end

  # --- Permissions --- #

  def create_permitted?
    acting_user.administrator?
  end

  def update_permitted?
    acting_user.administrator?
  end

  def destroy_permitted?
    acting_user.administrator?
  end

  def view_permitted?(field)
    true
  end

end

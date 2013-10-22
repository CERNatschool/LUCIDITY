class SourceCard < ActiveRecord::Base

  hobo_model # Don't put anything above this

  Particles = HoboFields::Types::EnumString.for("Electrons", "Protons")

  fields do
    cardid            :string, :unique, :required, :index => true, :name => true
    #
    n_events          :integer
    #
    particle_type     Particles
    #
    e_min             :decimal, :precision =>  30, :scale => 15
    e_max             :decimal, :precision =>  30, :scale => 15
    #
    flux_integral     :decimal, :precision =>  30, :scale => 15
    flux_differential :decimal, :precision =>  30, :scale => 15
    #
    notes             :markdown
    #
    timestamps
  end

  attr_accessible :cardid
  
  attr_accessible :n_events

  # Particle type
  attr_accessible :particle_type, :particle_type_id

  attr_accessible :e_min, :e_max

  attr_accessible :flux_integral, :flux_differential

  attr_accessible :notes

  attr_accessible :flux_spectra, :flux_spectra_id
  belongs_to      :flux_spectra, :creator => true, \
                                 :inverse_of => :source_cards, \
                                 :counter_cache => true, \
                                 :accessible => true

  # Source card
  has_attached_file :cardfile, :accessible => true
  attr_accessible :cardfile
  attr_accessible :cardfile_file_name, :cardfile_file_size
  attr_accessible :cardfile_content_type, :cardfile_updated_at

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

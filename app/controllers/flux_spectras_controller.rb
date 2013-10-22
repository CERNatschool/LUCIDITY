require 'zip/zipfilesystem'

class FluxSpectrasController < ApplicationController

  hobo_model_controller

  auto_actions :all

  def index
    @fluxspectrafiles = FluxSpectra.search(params[:search], :name, :projectname, :filetext, :notes).
      order_by(parse_sort_param(:name, :projectname, :source_cards_count)).
      paginate(:page => (params[:page] or 1), :per_page => 20)

   hobo_index
  end

  def show
    @fluxspectra = find_instance

    @sourcecards = @fluxspectra.source_cards.search(params[:search], :cardid, :particletype, :notes).
        order_by(parse_sort_param(:cardid, :e_min, :e_max, :n_events, :particletype, :flux_integral, :flux_differential)).
        paginate(:page => (params[:page] or 1), :per_page => 30)
    @sourcecards = @sourcecards.particle_type_is(params[:particle_type]) if params[:particle_type] && !params[:particle_type].blank?

    hobo_show
  end

  web_method :process_files

  def process_files

    #testfile = Tempfile.new('test.in')
    #puts testfile.path
    #testfile.close
    #testfile.unlink

    @fluxfile = FluxSpectra.find(params[:id])

    logger = StringIO.new
    logger.puts("Processing flux file #{@fluxfile.name}")

    @filetext = StringIO.new(@fluxfile.filetext)
    filelines = @filetext.readlines
    #logger.puts(filelines)

    # The SPENVIS project name
    projname = filelines[2].delete("\n").split(",")[2].gsub("'","")
    projname = projname.delete("\n").delete("\r")
    logger.puts(projname)
    @fluxfile.projectname = projname

    # Extract the source card information

    if @fluxfile.n_events then
      @numevents = @fluxfile.n_events
    else
      @numevents = 10000
    end

    @notes = "From the project **#{projname}**."

    # Create the zip file for the source cards
    zipfilename = @fluxfile.name.delete(" ")+".zip"
    @zipfile = Zip::ZipFile.new(zipfilename, Zip::ZipFile::CREATE)
    #@zipfile.get_output_stream("first.txt") { |f| f.puts "This works!" } 

    counter = 0

    #-------------------------------------------------------------------------
    # The protons
    #-------------------------------------------------------------------------
    @particletype = "Protons"
    (75..102).each do |line|

      cardid = @fluxfile.name.delete(" ") + "_p_" + counter.to_s

      lovalues = filelines[line].delete("\n").delete(" ").split(",")
      hivalues = filelines[line+1].delete("\n").delete(" ").split(",")
      binmin = lovalues[0].to_f
      binmax = hivalues[0].to_f
      binmid = binmin + (binmax - binmin)/2.0
      #puts("E_min = #{binmin} MeV, E_max = #{binmax}, E_mid = #{binmid}")
      intfluxmin = lovalues[1].to_f
      intfluxmax = hivalues[1].to_f
      intfluxav = intfluxmin + (intfluxmax - intfluxmin)/2.0
      #puts("I_int_min = #{intfluxmin}, I_int_max = #{intfluxmax}, I_int_av = #{intfluxav}")
      diffluxmin = lovalues[2].to_f
      diffluxmax = hivalues[2].to_f
      diffluxav = diffluxmin + (diffluxmax - diffluxmin)/2.0

      # Write the source card
      @cardfile = File.open('run.in', mode="w")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("# LUCIDITY Source Card for SimLucid \n")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("# CERN@school / LUCID Collaboration \n")
      @cardfile.write("#\n")
      @cardfile.write("# Project name: " + projname + "\n")
      @cardfile.write("#\n")
      @cardfile.write("# Energy bin minimum [MeV]:\n")
      @cardfile.write("#%E\n" % binmin)
      @cardfile.write("# Energy bin maximum [MeV]:\n")
      @cardfile.write("#%E\n" % binmax)
      @cardfile.write("# Energy bin middle [MeV]:\n")
      @cardfile.write("#%E\n" % binmid)
      @cardfile.write("# Integrated   flux (min) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxmin)
      @cardfile.write("# Integrated   flux (max) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxmax)
      @cardfile.write("# Integrated   flux (avg) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxav)
      @cardfile.write("# Differential flux (min) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxmin)
      @cardfile.write("# Differential flux (max) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxmax)
      @cardfile.write("# Differential flux (avg) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxav)
      @cardfile.write("#\n")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("\n")
      @cardfile.write("# Initialize the simulation\n")
      @cardfile.write("/run/initialize\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle type\n")
      @cardfile.write("/gps/particle proton\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle energy\n")
      @cardfile.write("/gps/ene/type Lin\n")
      @cardfile.write("/gps/ene/min %.2f MeV\n" % binmin)
      @cardfile.write("/gps/ene/max %.2f MeV\n" % binmax)
      @cardfile.write("/gps/ene/gradient 0.0\n")
      @cardfile.write("/gps/ene/intercept 1.0\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle geometry\n")
      @cardfile.write("/gps/pos/type Surface\n")
      @cardfile.write("/gps/pos/shape Sphere\n")
      @cardfile.write("/gps/pos/centre 0. 0. 0. mm\n")
      @cardfile.write("/gps/pos/radius 49.9 mm\n")
      @cardfile.write("/gps/pos/confine PseudoDetector_phys\n")
      @cardfile.write("/gps/ang/type cos\n")
      @cardfile.write("\n")
      @cardfile.write("# Run the simulation with the specified number of events.\n")
      @cardfile.write("/run/beamOn %d\n" % @numevents)
      @cardfile.close
      @cardfile = File.open('run.in', mode="r")

      # Add the source card to the zip file
      @zipfile.add(@fluxfile.name.delete(' ')+"/protons/"+cardid+"/run.in", 'run.in')
      @zipfile.commit

      # Create the new source card
      cardparams = { \
        :cardid            => cardid, \
        :n_events          => @numevents, \
        :particle_type     => @particletype, \
        :e_min             => binmin, \
        :e_max             => binmax, \
        :flux_integral     => intfluxav, \
        :flux_differential => diffluxav, \
        :notes             => @notes, \
        :cardfile          => @cardfile, \
        :flux_spectra      => @fluxfile \
      }

      @card = SourceCard.where("cardid = ?", cardid)
      if @card.size > 0 then
        logger.puts("Found the card!")
        @card.each {|c| c.update_attributes(cardparams)}
      else
        logger.puts("New card!")
        SourceCard.create(cardparams)
      end

      # Tidy up
      File.delete(@cardfile.path)

      counter += 1
    end

    counter = 0

    #-------------------------------------------------------------------------
    # The electrons
    #-------------------------------------------------------------------------
    @particletype = "Electrons"
    (180..208).each do |line|

      cardid = @fluxfile.name.delete(" ") + "_e_" + counter.to_s

      lovalues = filelines[line].delete("\n").delete(" ").split(",")
      hivalues = filelines[line+1].delete("\n").delete(" ").split(",")
      binmin = lovalues[0].to_f
      binmax = hivalues[0].to_f
      binmid = binmin + (binmax - binmin)/2.0
      #
      intfluxmin = lovalues[1].to_f
      intfluxmax = hivalues[1].to_f
      intfluxav = intfluxmin + (intfluxmax - intfluxmin)/2.0
      #
      diffluxmin = lovalues[2].to_f
      diffluxmax = hivalues[2].to_f
      diffluxav = diffluxmin + (diffluxmax - diffluxmin)/2.0

      # Write the source card
      @cardfile = File.open('run.in', mode="w")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("# LUCIDITY Source Card for SimLucid \n")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("# CERN@school / LUCID Collaboration \n")
      @cardfile.write("#\n")
      @cardfile.write("# Project name: " + projname + "\n")
      @cardfile.write("#\n")
      @cardfile.write("# Energy bin minimum [MeV]:\n")
      @cardfile.write("#%E\n" % binmin)
      @cardfile.write("# Energy bin maximum [MeV]:\n")
      @cardfile.write("#%E\n" % binmax)
      @cardfile.write("# Energy bin middle [MeV]:\n")
      @cardfile.write("#%E\n" % binmid)
      @cardfile.write("# Integrated   flux (min) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxmin)
      @cardfile.write("# Integrated   flux (max) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxmax)
      @cardfile.write("# Integrated   flux (avg) for energy bin [cm^-2 s^-1]\n")
      @cardfile.write("#%E\n" % intfluxav)
      @cardfile.write("# Differential flux (min) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxmin)
      @cardfile.write("# Differential flux (max) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxmax)
      @cardfile.write("# Differential flux (avg) for energy bin [cm^-2 s^-1 MeV^-1]\n")
      @cardfile.write("#%E\n" % diffluxav)
      @cardfile.write("#\n")
      @cardfile.write("#" + "="*78 + "\n")
      @cardfile.write("\n")
      @cardfile.write("# Initialize the simulation\n")
      @cardfile.write("/run/initialize\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle type\n")
      @cardfile.write("/gps/particle e-\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle energy\n")
      @cardfile.write("/gps/ene/type Lin\n")
      @cardfile.write("/gps/ene/min %.2f MeV\n" % binmin)
      @cardfile.write("/gps/ene/max %.2f MeV\n" % binmax)
      @cardfile.write("/gps/ene/gradient 0.0\n")
      @cardfile.write("/gps/ene/intercept 1.0\n")
      @cardfile.write("\n")
      @cardfile.write("# Source particle geometry\n")
      @cardfile.write("/gps/pos/type Surface\n")
      @cardfile.write("/gps/pos/shape Sphere\n")
      @cardfile.write("/gps/pos/centre 0. 0. 0. mm\n")
      @cardfile.write("/gps/pos/radius 49.9 mm\n")
      @cardfile.write("/gps/pos/confine PseudoDetector_phys\n")
      @cardfile.write("/gps/ang/type cos\n")
      @cardfile.write("\n")
      @cardfile.write("# Run the simulation with the specified number of events.\n")
      @cardfile.write("/run/beamOn %d\n" % @numevents)
      @cardfile.close
      @cardfile = File.open('run.in', mode="r")

      # Add the source card to the zip file
      @zipfile.add(@fluxfile.name.delete(' ')+"/electrons/"+cardid+"/run.in", 'run.in')
      @zipfile.commit

      # Create the new source card
      cardparams = { \
        :cardid            => cardid, \
        :n_events          => @numevents, \
        :particle_type     => @particletype, \
        :e_min             => binmin, \
        :e_max             => binmax, \
        :flux_integral     => intfluxav, \
        :flux_differential => diffluxav, \
        :notes             => @notes, \
        :cardfile          => @cardfile, \
        :flux_spectra      => @fluxfile \
      }

      @card = SourceCard.where("cardid = ?", cardid)
      if @card.size > 0 then
        logger.puts("Found the card!")
        @card.each {|c| c.update_attributes(cardparams)}
      else
        logger.puts("New card!")
        SourceCard.create(cardparams)
      end

      # Tidy up
      File.delete(@cardfile.path)

      counter += 1
    end


    # Output the contents of the logger.
    logger.rewind
    logger.each_line {|s|
      puts s
    }


    @zipfile.commit
    @zipfile.close
 
    # You need to reopen the zip file as a normal file in order for
    # Paperclip to handle it.
    @zipfile = File.open(zipfilename, "r")
    @fluxfile.sourcecardsfile = @zipfile

    # Save the flux file's new properties
    @fluxfile.save!

    File.delete(zipfilename)

    # Send back to the flux file page.
    redirect_to @fluxfile

  end

end

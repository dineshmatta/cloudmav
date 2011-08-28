class LinkedinProfile
  include Mongoid::Document  
  include CodeMav::Syncable
  
  field :url, :type => String
  field :last_synced, :type => DateTime 

  belongs_to :profile

  def get_jobs(client)
    positions = client.profile(:fields => %w(positions)).positions
    return positions.map{|p| get_job_from_position(p)}
  end

  def sync_jobs!(client)
    self.last_synced = DateTime.now
    jobs = get_jobs(client)
    jobs.each do |job|
      unless self.profile.jobs.where(:imported_id => job.imported_id).first
        self.profile.jobs << job
        job.save
        profile.save
      end
    end
    self.save
  end

  def date_valid?(year, month)
    return false unless year && month
    return false if year == 0 || month == 0
    true
  end

  def get_job_from_position(position)
    job = Job.new
    job.imported_id = position.id
    job.title = position.title
    job.description = position.summary
    job.company_name = position.company.name unless position.company.nil?
    start_year = position.start_year || Time.now.year
    start_month = position.start_month || 1

    if date_valid?(start_year, start_month)
      job.start_date = DateTime.civil(start_year, start_month, 1)
    end
    
    end_year = position.end_year
    end_month = position.end_month 
    if date_valid?(end_year, end_month) 
      job.end_date = DateTime.civil(end_year, end_month, 1)
    else
      job.end_date = nil
    end
    return job
  end
end

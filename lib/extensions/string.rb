class String

  def blank?
    self.nil? || self.strip.empty?
  end

end

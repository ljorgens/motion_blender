Module.new do
  def require _
  end

  def require_relative _
  end

  def __ORIGINAL__
  end

  Object.send :include, self
end

Module.new do
  def require _
  end

  def require_relative _
  end

  def motion_require _
  end

  Object.send :include, self
end

module MotionBlender
  module_function

  def add _ = nil
  end

  def use_motion_dir _ = nil
  end

  def motion?
    true
  end

  def raketime?
    false
  end

  def runtime?
    true
  end

  def raketime &_
  end

  def runtime &proc
    proc.call
  end
end

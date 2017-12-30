module ServiceInitializer
  def call(*args)
    new(*args).call
  end
end

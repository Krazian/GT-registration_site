class PaperlessSyncWorker
  include Sidekiq::Worker
  def perform(id)
    r = User.find(id)
    p = Paperless::Api::User.new(r)
    p.register
  end
end
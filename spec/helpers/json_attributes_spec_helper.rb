module JsonAttributesSpecHelper
  def extras_on_user_lifecycle(extras)
    user = User.new(extras: extras)

    after_instantiation = user.extras.dup if user.extras

    user.save!

    after_save = user.extras.dup if user.extras

    user.reload

    after_reload = user.extras.dup if user.extras

    yield(after_instantiation, after_save, after_reload)
  end

  def self.mysql_version
    full_version = ActiveRecord::Base.connection.select_value("SELECT VERSION()")

    version = full_version[/^\d+\.\d+\.\d+/] || raise("Unexpected_mysql_version: #{patch_version}")

    Gem::Version.new(version)
  end

  def self.postgres?
    ActiveRecord::Base.connection.class::ADAPTER_NAME == "PostgreSQL"
  end
end

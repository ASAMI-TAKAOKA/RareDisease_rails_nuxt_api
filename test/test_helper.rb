ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

# gem 'minitest-reporters' setup
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  parallelize_setup do |worker|
    # seedデータの読み込み
    load "#{Rails.root}/db/seeds.rb"
  # Run tests in parallel with specified workers
  end

  # 並列テストの有効化/無効化
  parallelize(workers: :number_of_processors)

  # アクティブなユーザーを返す
  def active_user
    User.find_by(activated: true)
  end
end

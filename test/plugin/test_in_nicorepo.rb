require 'helper'
require 'fluent/plugin/in_nicorepo'

class NicorepoInputTest < Test::Unit::TestCase
  DUMMY_REPORT = OpenStruct.new(
    format: [{
      sender:     "dummy_user",
      topic:      "動画投稿",
      title:      "dummy_title",
      url:        "http://example.com",
      created_at: Time.now
    }]
  )

  CONFIG = %[
    tag nicorepo.test
  ]

  CONFIG_DEFAULTS = {
    interval: 600,
    limit_num: 50,
    limit_page: 30,
    kind: 'all'
  }

  def setup
    Fluent::Test.setup
    Nicorepo::Client.any_instance.stubs(:all).returns(DUMMY_REPORT)
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::InputTestDriver.new(Fluent::NicorepoInput).configure(conf, true)
  end

  def test_configure
    d = create_driver
    assert_equal('nicorepo.test', d.instance.tag)
    assert_equal(CONFIG_DEFAULTS[:interval], d.instance.interval)
    assert_equal(CONFIG_DEFAULTS[:limit_num], d.instance.limit_num)
    assert_equal(CONFIG_DEFAULTS[:limit_page], d.instance.limit_page)
    assert_equal(CONFIG_DEFAULTS[:kind], d.instance.kind)
  end

  def test_emit
    expected_record = DUMMY_REPORT.format.first

    d = create_driver
    d.run

    assert_equal(expected_record, d.emits.first[2])
  end
end


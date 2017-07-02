require 'helper'
require 'fluent/plugin/in_nicorepo'

class NicorepoDouble
  def initialize
  end

  def login(*)
    puts 'logined'
  end

  def all(*)
    [OpenStruct.new({
      body:  "report body",
      title: "report title",
      url:   "report url",
      date:  "report date"
    })]
  end
end

class NicorepoInputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    Fluent::Plugin::NicorepoInput.send(:const_set, :Nicorepo, NicorepoDouble)
  end

  CONFIG = %[
    mail dummy@mail.com
    pass dummy_pass
    tag nicorepo.test
  ]

  CONFIG_DEFAULTS = {
    interval: 600,
    limit_num: 50,
    limit_page: 30,
    kind: 'all'
  }

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Input.new(Fluent::Plugin::NicorepoInput).configure(conf)
  end

  def test_configure
    d = create_driver
    assert_equal('dummy@mail.com', d.instance.mail)
    assert_equal('dummy_pass', d.instance.pass)
    assert_equal('nicorepo.test', d.instance.tag)
    assert_equal(CONFIG_DEFAULTS[:interval], d.instance.interval)
    assert_equal(CONFIG_DEFAULTS[:limit_num], d.instance.limit_num)
    assert_equal(CONFIG_DEFAULTS[:limit_page], d.instance.limit_page)
    assert_equal(CONFIG_DEFAULTS[:kind], d.instance.kind)
  end

  def test_emit
    expected_record = {
        body:  "report body",
        title: "report title",
        url:   "report url",
        date:  "report date"
    }

    d = create_driver
    d.run
    d.run
    # TODO: 2回runしないとemitsに反映されない原因を調べる
    # Fluent::Engine.emitは正しく実行されていることを確認

    assert_equal(expected_record, d.emits.first[2])
  end
end


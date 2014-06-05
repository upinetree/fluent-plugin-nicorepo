require 'nicorepo'

module Fluent
  class NicorepoInput < Fluent::Input
    Plugin.register_input 'nicorepo', self

    config_param :tag, :string
    config_param :interval, :time, default: '10m'
    config_param :mail, :string
    config_param :pass, :string
    config_param :limit_num, :integer, default: 30
    config_param :limit_page, :integer, default: 10

    def configure(conf)
      @nicorepo = Nicorepo.new
      super
    end

    def start
      @thread = Thread.new(&method(:run))
      super
    end

    def shutdown
      Thread.kill(@thread)
      super
    end

    def run
      loop do
        Thread.new(&method(:on_timer))
        sleep @interval
      end
    end

    def on_timer
      reports = fetch_reports
      reports.each do |report|
        time = Time.now
        record = report_to_hash(report)
        Engine.emit(@tag, time, record)
      end
    rescue => e
      log.error "unexpected error", error: e
    end

    private

    def fetch_reports
      @nicorepo.login(@mail, @pass)
      @nicorepo.all(3, since: nil)
    end

    # NOTE: nicorepo側にto_hがほしい
    def report_to_hash(report)
      {
        body:  report.body,
        title: report.title,
        url:   report.url,
        date:  report.date
      }
    end
  end
end


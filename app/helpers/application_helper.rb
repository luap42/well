module ApplicationHelper
  # convert time in minutes to fully qualified time frame
  def min_to_fqtf(time)
    min = time % 60
    h = (time / 60).floor % 24
    d = (time / 24 / 60).floor

    resp = "#{min}min"
    resp = "#{h}h #{resp}" if h != 0
    resp = "#{h}d #{resp}" if d != 0

    resp
  end
end

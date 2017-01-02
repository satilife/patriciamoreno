module FormatHelper
  def format_date(date)
    date.to_formatted_s(:long)
  end

  def format_datetime(datetime)
    datetime.localtime.to_formatted_s(:long)
  end
end

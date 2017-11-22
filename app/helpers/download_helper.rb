module DownloadHelper
  def download_link
    path = request.path.split('/')
    return '' if path[1] != "performance-data"

    # Strip the blank entry and the performance-data entry
    path.shift(2)
    return build_link("/v1/data/government/metrics.csv") if path[0] == "government"

    build_link("/v1/data/#{path[0]}/#{path[1]}/metrics.csv")
  end

private

  def build_link(path)
    URI::join(ENV.fetch('API_URL'), path)
  end
end

module ActiveRecord::DatabaseViews
  FILE_NAME_MATCHER_WITH_PREFIX = /^\d+?_(.+)/

  class View
    def name
      fpath = File.basename(path, '.sql')
      if fpath =~ FILE_NAME_MATCHER_WITH_PREFIX
        FILE_NAME_MATCHER_WITH_PREFIX.match(fpath)[1]
      else
        fpath
      end
    end
  end

 class ViewCollection
    private

    def view_paths
      Dir.glob('db/views/**/*.sql').sort
    end
  end
end

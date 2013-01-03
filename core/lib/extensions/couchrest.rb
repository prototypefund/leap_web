module CouchRest::Model::Designs

  class View

    # so we can called Ticket.method.descending or Ticket.method.ascending
    def ascending
      self
    end
  end

  class DesignMapper
    def load_views(dir)
      Dir.glob("#{dir}/*.js") do |js|
        name = File.basename(js, '.js')
        file = File.open(js, 'r')
        view name.to_sym,
          :map => file.read,
          :reduce => "function(key, values, rereduce) { return sum(values); }"
      end
    end
  end

end

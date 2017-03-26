class Row < Hyperloop::Component
  param :cols

  before_mount do
    mutate.testing 'holis'
  end

  def render
    div do
      params.cols.times{|x| Keycap(ref: "key#{x}")}
    end
  end
end

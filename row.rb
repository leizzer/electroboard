class Row < Hyperloop::Component
  param :cols

  def render
    div do
      params.cols.times{|x| Keycap(ref: "key#{x}")}
    end
  end
end

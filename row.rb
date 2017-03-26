class Row < React::Component::Base
  param :cols

  before_mount do
    state.testing! 'holis'
  end

  def render
    div do
      params.cols.times{|x| Keycap(ref: "key#{x}")}
    end
  end
end

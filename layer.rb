class Layer < React::Component::Base
  param :label
  param :rows
  param :cols
  param :hide

  before_mount do
    state.blah = 'b'
  end

  def render
    div(class: params.hide) do
      p do
        "Layer: #{params.label}"
      end

      params.rows.times{|x| Row(ref: "row#{x}", cols: params.cols) }
    end
  end
end

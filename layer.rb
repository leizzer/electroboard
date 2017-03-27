class Layer < Hyperloop::Component
  param :label
  param :rows
  param :cols

  def render
    div do
      p do
        "Layer: #{params.label}"
      end

      params.rows.times{|x| Row(ref: "row#{x}", cols: params.cols) }
    end
  end
end

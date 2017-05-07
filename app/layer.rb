class Layer < Hyperloop::Component
  param :label
  param :layer
  param :ilayer

  def render
    div do
      p do
        "Layer: #{params.label}"
      end

      params.layer.each_with_index {|row, x| Row(key: x, ref: "row#{x}", row: row, irow: x, ilayer: params.ilayer) }
    end
  end
end

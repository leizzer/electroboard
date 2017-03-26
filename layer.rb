class Layer < Hyperloop::Component
  param :label
  param :rows
  param :cols
  param :hide

  def render
    div(class: params.hide) do
      p do
        "Layer: #{params.label}"
      end

      params.rows.times{|x| Row(ref: "row#{x}", cols: params.cols) }
    end
  end
end

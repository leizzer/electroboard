class Row < Hyperloop::Component
  param :row
  param :ilayer
  param :irow


  def render
    div do
      params.row.each_with_index {|val, x| Keycap(ref: "key#{x}", val: val, icol: x, irow: params.irow, ilayer: params.ilayer)}
    end
  end
end

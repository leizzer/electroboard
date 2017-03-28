class SetupForm < Hyperloop::Component
  param :layers
  param :rows
  param :cols
  param :handler

  after_mount do
    mutate.layers params.layers
    mutate.rows params.rows
    mutate.cols params.cols
  end

  def setup_new_layout
    params.handler.setup_new_layout self
  end

  def render
    div(id: 'setup') do
      form(action: '#') do
        label{'Matrix'}

        input(type: 'text', value: state.rows, placeholder: 'R').on(:change) do |e|
          mutate.rows e.target.value.to_i
        end

        span{'x'}

        input(type: 'text', value: state.cols, placeholder: 'C').on(:change) do |e|
          mutate.cols e.target.value.to_i
        end

        br

        label{'Amout of Layers'}
        input(type: 'text', value: state.layers, placeholder: 'L').on(:change) do |e|
          mutate.layers e.target.value.to_i
        end

        input(type: 'submit', value: 'Change')
      end.on('submit') do |e|
        e.prevent_default
        self.setup_new_layout
      end
    end
  end
end
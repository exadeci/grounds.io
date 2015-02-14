class GroundDecorator < BaseDecorator
  def editor_data
    data = initial_data
    [:theme, :indent, :keyboard].each do |option|
      data[option] = session_or_default(option)
    end
    data
  end

  def shortcuts
    [
      ['⌘ / ctrl', 'enter', I18n.t('editor.run')],
      ['⌘ / ctrl', 's', I18n.t('editor.share')],
      ['⌘ / ctrl', '←', I18n.t('editor.back')],
    ]
  end


  def selected_label(option)
    editor.option_label(option, editor_data[option])
  end

  def options(option)
    editor.options(option).sort
  end

  private

  def session_or_default(option)
    h.session[option] ||= default(option)
  end

  def default(option)
    editor.default_option_code(option)
  end

  def initial_data
    {
      language: language,
      shared: id.present?,
      runner_url: Runner.url
    }
  end

  def editor
    Editor
  end
end

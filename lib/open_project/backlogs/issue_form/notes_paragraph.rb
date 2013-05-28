class OpenProject::Backlogs::IssueForm::NotesParagraph < OpenProject::Nissue::IssueView::DescriptionParagraph
  def visible?
    true
  end

  def render(t)
    html_id = "issue_notes_#{SecureRandom.hex(10)}"
    s = content_tag(:fieldset, [
      content_tag(:legend, Journal.human_attribute_name(:notes)),
      t.text_area_tag('issue[notes]', '', :cols => 60, :rows => 10, :class => 'wiki-edit', :id => html_id),
      t.wikitoolbar_for(html_id) ].join.html_safe
    )
  end
end

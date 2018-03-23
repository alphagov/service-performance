module ServicesHelper
  def render_markdown(field)
    return '' if !field

    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    markdown.render(field).html_safe
  end

  def transactions_received_applicable_list(service)
    [
      %i(total_transactions total),
      %i(online_transactions online),
      %i(email_transactions email),
      %i(phone_transactions phone),
      %i(paper_transactions paper),
      %i(face_to_face_transactions face_to_face),
      %i(other_transactions other)
    ].select do |long, short|
      if short == :total
        true
      else
        service.metric_applicable?(long)
      end
    end
  end

  def transactions_processed_applicable_list(service)
    [
      %i(transactions_processed total),
      %i(transactions_processed_with_intended_outcome with_intended_outcome)
    ].select do |long, _short|
      service.metric_applicable?(long)
    end
  end

  def calls_received_applicable_list(service)
    [
      %i(calls_received total),
      %i(calls_received_perform_transaction perform_transaction),
      %i(calls_received_get_information get_information),
      %i(calls_received_chase_progress chase_progress),
      %i(calls_received_challenge_decision challenge_a_decision),
      %i(calls_received_other other)
    ].select do |long, _short|
      service.metric_applicable?(long)
    end
  end

  # Given a date, iterates until it find's the next Friday.
  # Is assumed that it will be provided a date in the middle of the
  # month.
  def find_middle_day(dt, day: "Friday")
    (dt..dt.end_of_month).each do |d|
      return d if d.strftime("%A") == day
    end
    dt
  end
end

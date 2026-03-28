module TurboHelper
  # Turbo uses window.confirm() for data-turbo-confirm attributes.
  # In headless Firefox + Turbo 8, data-turbo-method links sometimes don't
  # fire reliably. This helper overrides window.confirm to return true, then
  # clicks the link. The sleep gives Turbo time to create and submit its
  # hidden form and for the server response to arrive.
  def accept_turbo_confirm(&block)
    page.execute_script("window.confirm = () => true")
    yield
    sleep 2
  end

  # Use this when accept_turbo_confirm still doesn't work.
  # Directly submits a DELETE fetch request via JS and navigates to the result.
  def click_turbo_delete_link(href, redirect_to: nil)
    page.execute_script(<<~JS)
      (async function() {
        const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
        const response = await fetch('#{href}', {
          method: 'DELETE',
          headers: { 'X-CSRF-Token': token, 'Accept': 'text/html' }
        });
        window.location.href = response.url || '#{redirect_to || "/"}';
      })();
    JS
    sleep 2
  end
end

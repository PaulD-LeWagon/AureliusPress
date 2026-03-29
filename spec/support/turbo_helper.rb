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

  # Sends a DELETE request via JS fetch and then navigates to the final URL.
  # This is the reliable alternative to clicking data-turbo-method="delete" links
  # in headless Firefox, which can fail to fire the Turbo form submission.
  # After the DELETE, flash messages are stored in session and rendered on redirect.
  # We navigate to the redirect target using Turbo.visit so Turbo can render the flash.
  def click_turbo_delete_link(href, redirect_to: nil)
    fallback = redirect_to || "/"
    page.execute_script(<<~JS, href, fallback)
      (async function(href, fallback) {
        try {
          const meta = document.querySelector('meta[name="csrf-token"]');
          const token = meta ? meta.getAttribute('content') : '';
          const resp = await fetch(href, {
            method: 'DELETE',
            headers: {
              'X-CSRF-Token': token,
              'Accept': 'text/html, application/xhtml+xml',
              'X-Requested-With': 'XMLHttpRequest'
            },
            redirect: 'follow'
          });
          // Navigate to the final URL (after redirect), or to the fallback
          const dest = resp.url && resp.url !== href ? resp.url : fallback;
          Turbo.visit(dest);
        } catch(e) {
          window.location.href = fallback;
        }
      })(arguments[0], arguments[1]);
    JS
    sleep 2
  end
end

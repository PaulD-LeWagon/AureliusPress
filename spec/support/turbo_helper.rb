module TurboHelper
  # Accepts a Turbo data-turbo-confirm dialog via Capybara's CDP-level modal
  # handler. This works with Cuprite/Chrome because it intercepts the native
  # browser dialog before Cuprite auto-dismisses it (which would return false
  # and abort the Turbo request). The execute_script window.confirm override
  # is unreliable with Cuprite.
  def accept_turbo_confirm(&block)
    accept_confirm { yield }
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
            credentials: 'include',
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

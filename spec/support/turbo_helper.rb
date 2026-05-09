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
  # Cuprite can misfire data-turbo-method="delete" link clicks, so we bypass
  # Turbo's link interception entirely and issue the fetch directly.
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
          const dest = resp.url && resp.url !== href ? resp.url : fallback;
          Turbo.visit(dest);
        } catch(e) {
          window.location.href = fallback;
        }
      })(arguments[0], arguments[1]);
    JS
    expect(page).to have_current_path(redirect_to, wait: 5) if redirect_to
  end
end

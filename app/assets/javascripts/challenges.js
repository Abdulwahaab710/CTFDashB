$(document).ready(() => {
  $('.flag-submission-form').on("ajax:success", (_e, xhr, _status) => {
    if (xhr.message && typeof Swal !== 'undefined') {
      Swal.fire({
        title: xhr.flash,
        type: 'success',
        html: xhr.message
      });
    } else {
      $('.alert').removeClass('alert-danger');
      $('.alert').addClass('alert-success');
      $('.alert').text(xhr.flash);
      $('.alert').fadeIn();
    }
  }).on("ajax:error", (_e, xhr, _status, _error) => {
    $('.alert').removeClass('alert-success');
    $('.alert').addClass('alert-danger');
    $('.alert').text(xhr.responseJSON.error);
    $('.alert').fadeIn();
    if (xhr.responseJSON.max_tries) {
      $('.max-tries-label').text(`${xhr.responseJSON.max_tries} Tries left`);
    }
  });

  $('.delete-attachment').on("ajax:success", (e, xhr, _status) => {
    if (xhr.deleted) {
      e.currentTarget.parentElement.remove();
    }
  });
});

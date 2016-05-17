Config = {
  PORT: 3001,
}

socket = io.connect 'http://localhost:' + Config.PORT
socket.on 'progress', (data) ->
  textarea = $('#progress');
  textarea.html(textarea.text() + data.progress);
  textarea.scrollTop(textarea[0].scrollHeight);

  $('.progress-box-body').collapse('show')


$(document).on 'click', '#progress', (e) ->
  e.preventDefault();

$(document).on 'change', '#single-folder', (e) ->
  if this.checked
    $('#single-folder-download').parent().show()
  else
    $('#single-folder-download').parent().hide()


$(document).on 'submit', '#download', (e) ->
  e.preventDefault();

  form = $('#download');
  $('#progress').text('');
  $.ajax({
    type: "POST",
    url: 'http://localhost:' + Config.PORT + '/run',
    data: form.serialize(),
  });

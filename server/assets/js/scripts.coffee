$.fn.scrollBottom = () ->
	return $(this).scrollTop($(this)[0].scrollHeight)

$.fn.appendVal = (TextToAppend) ->
	return $(this)
		.val( $(this).val() + TextToAppend)

	
## Listener for console messages
try
	io.connect().on 'progress', (data) ->
	  
		$('#progress')
			.appendVal ( data.progress)
			.scrollBottom();

		$('#progress-box')
			.collapse('show');

## Init Captcha https://developers.google.com/recaptcha/docs/display#js_api
window
	.onRecaptchaLoaded = () ->
		debugger;
		_captchaId = grecaptcha.render(
			"recaptcha_holder", {
			sitekey: "6LeaOiITAAAAAF_A-e9qjM6TCgdt4-rqixnkkatL",
			theme: "dark", 
			size: 'compact' ,
			callback: captchaDone,
			"expired-callback": captcha_expired,
			})

captchaDone = (response) ->
	debugger;
	$("#g-recaptcha-response-1")
		.val(response)
	
captcha_expired = (response) ->
	debugger;
	
###
$("#progress").resizable({
	resize: () -> 
		debugger
		$("#progress-box-header").width( this.width() );
    
});
###
	
# Do not download when you click into the TextArea
$(document)
	.on 'click', '.collapser', (e) ->
		  e.preventDefault();

	.on 'change', '#single-folder', (e) ->
		$('#single-folder-group').toggle();


	.on 'submit', '#download', (e) ->
		  e.preventDefault();

		  $('#progress').val('');
		  grecaptcha.reset();

		  $.ajax({
			  type: "POST", 
			  url: '/run',
			  data: $('#download').serialize()
		  });

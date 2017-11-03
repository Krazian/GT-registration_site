$(document).ready(function(){
	// Keeps submit button disabled until all require fields are filled in
	$('input, textarea').keyup(function(){
		var empty = false;
		$('.required').each(function() {
			if (($(this).val() === '') || ($(this).val() === null)){empty = true;}
		});
		if (($(".display-file-name").html() === "") || ($("#profile-pic").html() === "")){empty = true;}
		if (empty) {
			$('#form-submit').attr('disabled', 'disabled');
		} else {
			$('#form-submit').removeAttr('disabled'); // updated according to http://stackoverflow.com/questions/7637790/how-to-remove-disabled-attribute-with-jquery-ie
		}
	});

	//Auto displays image after uploaded
	$("input:file").change(function(event){
		var fileName = $(this).val();
		$(".display-file-name").html(fileName.replace(/^.*[\\\/]/, ''));
    var files = event.target.files;
    var image = files[0];
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      console.log(file);
      img.src = file.target.result;
      $('#profile-pic').html(img);
    };
    reader.readAsDataURL(image);
    console.log(files);
  });

	//Gives export button the path to download CSV based on the URL
	$(".export_button").attr("href",window.location.href.split("?")[0]+".csv?"+window.location.href.split("?")[1]);
});
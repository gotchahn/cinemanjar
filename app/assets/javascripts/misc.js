$(document).on("ready page:load", function(){

  $('a[disabled=disabled]').on("click", function(e){
    e.preventDefault()
  });
});

$(document).on("turbolinks:load", function(){
  console.log("LOADED");

  $(document).on("click", "a[disabled=disabled]", function(e){
    e.preventDefault()
  });

  $(document).on("ajax:before", ".js-food-search", function(){
    $(".js-loading").show();
  });

  $(document).on("ajax:success", ".js-food-search", function(e, data, status, xhr){
    $(".js-loading").hide();
    $(".js-restaurants-table").html(data);
  });
});

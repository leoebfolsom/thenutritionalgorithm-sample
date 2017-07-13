$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});


/* ________________________________________________________________
BEGIN functions
*/
function clickVeg() {
  if (( $("#pescatarian").is(":checked") || $("#red-meat-free").is(":checked") )) {
    $("#pescatarian").attr('checked', false);
    $("#red-meat-free").attr('checked', false);
  }
}

function getQueryVariable(url, variable) {
   var query = url.substring(1);
   var vars = query.split('?')[1].split('&');
   for (var i=0; i<vars.length; i++) {
        var pair = vars[i].split('=');
        if (pair[0] == variable) {
          return pair[1];
        }
   }
   return false;
}

function clickListBuy() {
  var checkboxes = $(".list-buy-checkbox");
  var total_price = 0;
  var total_calories = 0;
  var total_protein = 0;
  var total_carbohydrates = 0;
  var total_fat = 0;
  var total_vitamin_a = 0;
  var total_vitamin_c = 0;
  var total_calcium = 0;
  var total_iron = 0;
  var total_fiber = 0;
  var total_sodium = 0;
  var total_sugar = 0;
  for(var i = 0; i < checkboxes.length; i++)
  {
    if (checkboxes[i].checked == true ) {
      var quantity_id = checkboxes[i].id.replace(/\D/g,'');
      var price_id = "#price-"+quantity_id;
      var calories_id = "#calories-"+quantity_id;
      var carbohydrates_id = "#carbohydrates-"+quantity_id;
      var protein_id = "#protein-"+quantity_id;
      var fat_id = "#fat-"+quantity_id;
      var fiber_id = "#fiber-"+quantity_id;
      var sugar_id = "#sugar-"+quantity_id;
      var vitamin_a_id = "#vitamin_a-"+quantity_id;
      var vitamin_c_id = "#vitamin_c-"+quantity_id;
      var calcium_id = "#calcium-"+quantity_id;
      var iron_id = "#iron-"+quantity_id;
      var sugar_id = "#sugar-"+quantity_id;
      var sodium_id = "#sodium-"+quantity_id;
      total_price += parseFloat($(price_id).val());
      total_calories += parseInt($(calories_id).val(), 10);
      total_carbohydrates += parseInt($(carbohydrates_id).val(), 10);
      total_fat += parseInt($(fat_id).val(), 10);
      total_fiber += parseInt($(fiber_id).val(), 10);
      total_protein += parseInt($(protein_id).val(), 10);
      total_sugar += parseInt($(sugar_id).val(), 10);
      total_vitamin_a += parseInt($(vitamin_a_id).val(), 10);
      total_vitamin_c += parseInt($(vitamin_c_id).val(), 10);
      total_iron += parseFloat($(iron_id).val());
      total_calcium += parseInt($(calcium_id).val(), 10);
      total_sodium += parseInt($(sodium_id).val(), 10);
    } 
  }
  $(".total-price").val(total_price.toFixed(2));
  $(".total-calories").val(total_calories);
  $(".total-carbohydrates").val(total_carbohydrates);
  $(".total-fat").val(total_fat);
  $(".total-protein").val(total_protein);
  $(".total-sugar").val(total_sugar);
  $(".total-fiber").val(total_fiber);
  $(".total-vitamin_a").val(total_vitamin_a);
  $(".total-vitamin_c").val(total_vitamin_c);
  $(".total-calcium").val(total_calcium);
  $(".total-iron").val(total_iron);
  $(".total-sodium").val(total_sodium);
}


function customCheckbox(checkboxName){
  var checkBox = $('input[name="'+ checkboxName +'"]');
  $(checkBox).each(function(){
      $(this).wrap( "<span class='custom-checkbox'></span>" );
      if($(this).is(':checked')){
          $(this).parent().addClass("selected");
      }
  });
  $(checkBox).click(function(){
      $(this).parent().toggleClass("selected");
  });
}

function pantry() {
  $('span[id^="pantry-link"]').click(function() {
    $(this).addClass("hidden");
    $(this).parent().find('span[id^="undo-pantry-link"]').removeClass("hidden");
  });
  $('span[id^="undo-pantry-link"]').click(function() {
    $(this).parent().find('span[id^="pantry-link"]').removeClass("hidden");
    $(this).addClass("hidden");
  });
}


$( document ).on( 'click', '#chartkick-calories-click', function() {
  $(".chartkick-container").addClass("hidden");
  $("#chartkick-calories-container").removeClass("hidden");
  $(".chartkick-click").removeClass("chartkick-active");
  $("#chartkick-calories-click").addClass("chartkick-active");
});
$( document ).on( 'click', '#chartkick-price-click', function() {
  $(".chartkick-container").addClass("hidden");
  $("#chartkick-price-container").removeClass("hidden");
  $(".chartkick-click").removeClass("chartkick-active");
  $("#chartkick-price-click").addClass("chartkick-active");
});

$( document ).on( 'click', '.list-buy-checkbox', function() {
  clickListBuy();
});
$( document ).on( 'keyup', '.list-buy-checkbox-individual-field', function() {
  clickListBuy();
});
$( document ).on( 'click', '.list-buy-checkbox-details-show-link', function() {
  var quantity_id = $(this).attr("id").replace(/\D/g,'');
  var list_buy_checkbox_details_id = "#list-buy-checkbox-details-"+quantity_id;
  $(list_buy_checkbox_details_id).show();
  $(this).addClass("hidden");
});
$( document ).on( 'click', '.list-buy-checkbox-details-hide-link', function() {
  var quantity_id = $(this).attr("id").replace(/\D/g,'');
  var list_buy_checkbox_details_id = "#list-buy-checkbox-details-"+quantity_id;
  $(list_buy_checkbox_details_id).hide();
  var show_link = "#list-buy-checkbox-details-show-link-"+quantity_id;
  $(show_link).removeClass("hidden");
});


function clickPesc() {
  if (($("#vegetarian").is(":checked") || $("#red-meat-free").is(":checked") )) {
    $("#vegetarian").attr('checked', false);
    $("#red-meat-free").attr('checked', false);
  }
}
function clickRedMeatFree() {
  if (($("#vegetarian").is(":checked") || $("#pescatarian").is(":checked")) ) {
    $("#vegetarian").attr('checked', false);
    $("#pescatarian").attr('checked', false);
  }
}

function getAge(dateString) {
  var today = new Date();
  var birthDate = new Date(dateString);
  var age = today.getFullYear() - birthDate.getFullYear();
  var m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age = age - 1;
  }
  return age;
}

function updateHeight() {
  $("#height").val((parseInt($("#height-slider").val(),10)));
  feet = Math.floor(parseInt($("#height").val(),10)/12);
  inches = parseInt($("#height").val(),10)%12;
  height_string = String(feet)+"' "+String(inches)+'" ';
  $("#height-in-feet-inches").html(height_string);
}


$(function() {
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    var form         = $(fileInput.parents('form:first'));
    var submitButton = form.find('input[type="submit"]');
  //  submitButton.prop('disabled', true);
   // submitButton.addClass("hidden");
    var progressBar  = $("<div class='bar'></div>");
    var barContainer = $("<div class='progress'></div>").append(progressBar);
    fileInput.after(barContainer);
    fileInput.fileupload({
   //   add: function (e, data) {
   //     fd["Content-Type"] = data.files[0].type;  
   //     data.formData = fd;
   //     data.submit();
   //   },  
      fileInput:       fileInput,
      url:             form.data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         form.data('form-data'),
      paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
      replaceFileInput: false,
      progressall: function (e, data) {
        var progress = parseInt(data.loaded / data.total * 100, 10);
        progressBar.css('width', progress + '%')
      },
      start: function (e) {
        submitButton.prop('disabled', true);

        progressBar.
          css('background', 'green').
          css('display', 'block').
          css('width', '0%').
          text("Loading...");
      },
      done: function(e, data) {
        submitButton.removeClass("hidden");
        submitButton.prop('disabled', false);
        progressBar.text("Uploading done");

        // extract key and generate URL from response
        var key   = $(data.jqXHR.responseXML).find("Key").text();
        var url   = '//' + form.data('host') + '/' + key;

        // create hidden field
        var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url })
        form.append(input);
      },
      fail: function(e, data) {
        submitButton.prop('disabled', true);
        submitButton.addClass("hidden");

        progressBar.
          css("background", "red").
          text("Failed");
      }
    });
  });
});

function removeElementsByClass(className){
  var elements = document.getElementsByClassName(className);
  while(elements.length > 0){
      elements[0].parentNode.removeChild(elements[0]);
  }
}

function rootCat() {
  $.each($(".root-cat-items"), function (index, value) {
    if ($(this).children().length == 0) {
      $(this).prev().addClass("hidden");
    } else {
      $(this).prev().removeClass("hidden");
    }
  });
  $.each($(".root-cat-items-list-view"), function (index, value) {
    if ($(this).children().length == 0) {
      $(this).prev().addClass("hidden");
    } else {
      $(this).prev().removeClass("hidden");
    }
  });
}

function quantityArrows() {
  $( document ).on( 'click', ".quantity-plus", function() {
    var amount_field = $(this).parent().find(".quantity-field-input");
    var current_val = parseInt(amount_field.val(),10);
    amount_field.val(current_val+1);
    amount_field.next().html(current_val+1)
    $(this).parent().find(".amount-submit").click();
  });
  $( document ).on( 'click', ".quantity-minus", function() {
    var amount_field = $(this).parent().find(".quantity-field-input");
    var current_val = parseInt(amount_field.val(),10);
    if (current_val >= 2) {
      amount_field.val(current_val-1);
      amount_field.next().html(current_val-1);
      $(this).parent().find(".amount-submit").click();
    }
  });
  $( document ).on( 'click', ".quantity-plus-search", function() {
    var amount_field = $(this).parent().find(".quantity-field-input-search");
    var current_val = parseInt(amount_field.val(),10);
    amount_field.val(current_val+1);
    amount_field.next().html(current_val+1)
  });
  $( document ).on( 'click', ".quantity-minus-search", function() {
    var amount_field = $(this).parent().find(".quantity-field-input-search");
    var current_val = parseInt(amount_field.val(),10);
    if (current_val >= 2) {
      amount_field.val(current_val-1);
      amount_field.next().html(current_val-1)
    }
  });


  $( document ).on( 'click', ".quantity-plus-suggestions", function() {
    var amount_field = $(this).parent().find(".suggestions-input-amount");
    var current_val = parseInt(amount_field.val(),10);
    amount_field.val(current_val+1);
    amount_field.next().html(current_val+1)
  });
  $( document ).on( 'click', ".quantity-minus-suggestions", function() {
    var amount_field = $(this).parent().find(".suggestions-input-amount");
    var current_val = parseInt(amount_field.val(),10);
    if (current_val >= 2) {
      amount_field.val(current_val-1);
      amount_field.next().html(current_val-1)
    }
  });


  



}

$(function() {
   $('#flash').delay(50).fadeIn('normal', function() {
      $(this).delay(7000).slideUp();
   });
});

function hoverdiv(e,divid){
  var left  = e.clientX  + "px";
  var top  = e.clientY  + "px";
  var div = document.getElementById(divid);
  div.style.left = left;
  div.style.top = top;
  $("#"+divid).toggle();
  return false;
}

/*
END functions
*/

/* ________________________________________________________________
BEGIN list.nutrition_constraints[] + user.settings[]
*/
$( document ).on( 'click', '#pescatarian', function() {
  clickPesc();
});
$( document ).on( 'click', '#vegetarian', function() {
  clickVeg();
});
$( document ).on( 'click', '#red-meat-free', function() {
  clickRedMeatFree();
});
/*
END list.nutrition_constraints[] + user.settings[]
*/

/* ________________________________________________________________
BEGIN list.image
*/



$( document ).on( 'click', '#small-image-link', function() {
  $("#large-image-row").hide();
  $("#large-image-row").removeClass("hidden");
  $('#large-image-row').slideDown();
});
$( document ).on( 'click', '#large-image-hide', function() {
  $('#large-image-row').slideUp();
});
/*
END list.image
*/

/* ________________________________________________________________
BEGIN list.post
*/
$( document ).on( 'click', ".delete-post-image-link", function() {
  $(this).parentsUntil(".post-image").parent().slideUp();
});

$( document ).on( 'click', '#posts-about-this-list', function() {
  $(this).slideUp();
  $('#large-post-row').slideDown();
});
$( document ).on( 'click', '#large-post-hide', function() {
  $('#posts-about-this-list').slideDown();
  $('#large-post-row').slideUp();
});
$( document ).on( 'click', '.scroll-to-top-of-list', function() {
  $('html, body').animate({scrollTop: 0});
});

$( document ).on( 'click', '#scroll-to-nutrition', function() {
  $('html, body').animate({scrollTop: $("#nutrition-totals").offset().top - 15});
});

$( document ).on( 'click', '.preview-of-list-click', function() {
  $("#preview-of-list").removeClass("hidden");
  $(".home-main").addClass("hidden");
  $(".parallax-window").addClass("hidden");
  $(".food-feed-parent").addClass("hidden");
  $(".food-feed-button").addClass("hidden");
  $('html, body').animate({scrollTop: 0});
});
$( document ).on( 'click', '#preview-of-list-hide', function() {
  $("#preview-of-list").addClass("hidden");
  $(".home-main").removeClass("hidden");
  $(".parallax-window").removeClass("hidden");
  $(".food-feed-parent").removeClass("hidden");
  $(".food-feed-button").removeClass("hidden");
});


$( document ).on( 'click', '.preview-of-charts-click', function() {
  $("#preview-of-charts").removeClass("hidden");
  $(".home-main").addClass("hidden");
  $(".parallax-window").addClass("hidden");
  $(".food-feed-parent").addClass("hidden");
  $(".food-feed-button").addClass("hidden");
  $('html, body').animate({scrollTop: 0});
});
$( document ).on( 'click', '#preview-of-charts-hide', function() {
  $("#preview-of-charts").addClass("hidden");
  $(".home-main").removeClass("hidden");
  $(".parallax-window").removeClass("hidden");
  $(".food-feed-parent").removeClass("hidden");
  $(".food-feed-button").removeClass("hidden");
});

$( document ).on( 'click', '.browse-lists-click', function() {
  $("#browse-container-dishes").addClass("hidden");
  $("#browse-container-lists").removeClass("hidden");
  $("#good-lists-display").addClass("hidden");
  $("#browse-lists-display").removeClass("hidden");

  $(".home-how-it-works").removeClass("active-browse");
  $("#browse-option-lists").addClass("active-browse");

  $('html, body').animate({scrollTop: $("#browse-lists-display").offset().top - 15});
});
$( document ).on( 'click', '#browse-dishes-click', function() {
  $("#browse-container-lists").addClass("hidden");
  $("#browse-container-dishes").removeClass("hidden");

  $(".home-how-it-works").removeClass("active-browse");
  $("#browse-option-dishes").addClass("active-browse");

  $('html, body').animate({scrollTop: $("#browse-container-dishes").offset().top - 15});

});

$( document ).on( 'click', '#good-lists-click', function() {
  $("#browse-container-lists").removeClass("hidden");
  $("#browse-container-dishes").addClass("hidden");
  $("#good-lists-display").removeClass("hidden");
  $("#browse-lists-display").addClass("hidden");

  $(".home-how-it-works").removeClass("active-browse");
  $("#browse-option-good-for-you").addClass("active-browse");

  $('html, body').animate({scrollTop: $("#good-lists-display").offset().top - 15});
  
});




$( document ).on( 'click', '#post-submit', function(e) {
  
  if ($("#new-dish-title").val().length == 0 || $("#new-dish-body").val().length == 0) {
    e.preventDefault();
    alert('Please make sure your dish has a title and some text.');
  } else {
    $('#large-post-row').slideUp();
    $("#posts-about-this-list").slideDown();
    $(':focus').blur();
  }

});


$( document ).on( 'click', '.scroll-to-dishes', function() {
  $('html, body').animate({scrollTop: $("#dishes-container").offset().top - 15});
  $('#large-post-row').slideDown();
  $("#posts-about-this-list").slideUp();
});


$( document ).on( 'click', '#visitor-posts-about-this-list', function() {
  $('html, body').animate({scrollTop: $("#list-posts").offset().top - 15});
});
$( document ).on( 'click', '.edit-post', function() {

  if ($(this).parentsUntil("#list-posts").find(".post-body-edit-div").hasClass("hidden")) {
    $(this).parentsUntil("#list-posts").find(".post-body-edit-div").removeClass("hidden");
  } else {
    $(this).parentsUntil("#list-posts").find(".post-body-edit-div").addClass("hidden");
  }
});
$( document ).on( 'click', '.read-more-dish', function() {
  var dish_id = $(this).attr("id").replace(/\D/g,'');
  var read_dish_id = "dish-"+dish_id;
  $('html, body').animate({scrollTop: $("#"+read_dish_id).offset().top - 15}, 'slow');
});
/*
END list.post
*/

/* ________________________________________________________________
BEGIN list.note
*/
$( document ).on( 'click', '#small-text-link', function() {
  $("#large-text-row").hide();
  $("#large-text-row").removeClass("hidden");
  $('#large-text-row').slideDown();
});
$( document ).on( 'click', '#large-text-hide', function() {
  $('#large-text-row').slideUp();
});
/*
END list.note
*/

/* ________________________________________________________________
BEGIN lists#index
*/
$( document ).on( 'click', '#good-lists-click', function() {
  $("#browse-lists-display").addClass("hidden");
  //$('html, body').animate({scrollTop: $("#lists-browse").offset().top - 15});
});
/*
END lists#index
*/


/* ________________________________________________________________
BEGIN activities#index
*/
$( document ).on( 'click', '#hide-logged-out-users', function() {
  if ($(".user-id-is-nil").length == 0) {
    alert("Everything on this page is logged in activity.");
  } else {
    if ($(".user-id-is-nil").hasClass("hidden")) {
      $(".user-id-is-nil").removeClass("hidden");
      $("#hide-logged-out-users").text("show only logged in activity");
    } else {
      $(".user-id-is-nil").addClass("hidden");
      $("#hide-logged-out-users").text("show all activity");
    }
  }
});
/*
END lists#index
*/


/* ________________________________________________________________
BEGIN search
*/

$( document ).on( 'click', '.text-field-clear', function() {
  $(".text-field-clearable").val('');
  if ($("#home-search-results").length > 0) {
    $("#home-search-results").html("");
  }
});

$( document ).on( 'click', '.add-from-search', function() {
  $(this).parentsUntil(".item").parentsUntil(".search-result-grand-container").hide(500);
  $(".search-results-container").addClass("hidden");
  $(".fixed-bottom-bar").show();
  $(".search-to-add").val("");
  $(".root-cat-container-items").css("opacity",1)
  $("#clear-search-results").addClass("hidden");
  if ($("#frequent-foods-box-list-2").hasClass("hidden") && $("#top-foods-box-list").hasClass("hidden")) {
    $('html, body').animate({scrollTop: $('#search').offset().top - 15});
  }
  


});
//document.onscroll = function() { $(':focus').blur(); };
$(document).on("keyup", '.search-to-add', function(event) {
  
  var val = $(this).val();
  if(event.keyCode == 13) {
    $(':focus').blur();
  }

  setTimeout(function () {
    $(':focus').blur();
    $(".fixed-bottom-bar").hide();

  }, 3000); 

 // $(this).parentsUntil(".search-to-add-container").parent().find(".search-results-container").html(val);
  $(".search-results-container").removeClass("hidden");
  
  //$(".search-results-container").html(val);
  if (val.length > 3) {
    setTimeout(function () {
      $(".search-submit").click();
    }, 1000); 

  }
 
});




/*
END search
*/

/* ________________________________________________________________
BEGIN preview details
*/



$( document ).on( 'click', '.preview-details-link', function() {
  var listnewval = $(this).parentsUntil(".item").parent().find(".preview-details-info").html();
  $("#preview-details-box").html(listnewval);
  $("#preview-details-box").removeClass("hidden");
  $("#details-parent-box").removeClass("hidden");
  $("#close-details-box").removeClass("hidden");
  $(".transparency").removeClass("hidden");
});

$( document ).on( 'click', '#close-details-box', function() {
  $("#details-parent-box").addClass("hidden");
  $("#preview-details-box").html("");
  $("#preview-details-box").addClass("hidden");
  $("#close-details-box").addClass("hidden");
  if ($("#user-likes-box-container").hasClass("hidden") || ($("#user-likes-box-container").length == 0)) {
    $(".transparency").addClass("hidden");
  }
});


/*
END preview details
*/


/* ________________________________________________________________
BEGIN add and remove boxes
*/
$( document ).on( 'click', '.add-to-dislikes', function() {
  $(this).parentsUntil(".search-result-grand-container").parent().remove();
});
$( document ).on( 'click', '.add-to-favorites', function() {
  $(this).parentsUntil(".search-result-grand-container").parent().remove();
});

$( document ).on( 'click', '.remove-from-favorite', function() {
  $(this).parentsUntil(".favorites-li").parent().remove();
});
$( document ).on( 'click', '.remove-from-dislikes', function() {
  $(this).parentsUntil(".dislikes-li").parent().remove();
});
$( document ).on( 'click', '.remove', function() {
  $(this).parentsUntil(".item-grand-div-container").parent().remove();
});

/* 
END add and remove boxes
*/

/* ________________________________________________________________
BEGIN list autocomplete
*/

$( document ).on( 'click', "#cancel-auto-button", function() {
  $("#cancel-auto-indicator").html("CANCEL");
  $("#stepwise-response").addClass("hidden");
  $("#add-or-delete-stepwise-button").addClass("hidden");
  $("#add-or-delete-stepwise").addClass("hidden");
  $("#shuffle-stepwise-skip").addClass("hidden");
  $("#add-and-like").addClass("hidden");
  $("#skip-or-delete-and-dislike").addClass("hidden");
  $("#stepwise-response-box-container").addClass("hidden");
  $("#stepwise-response-box").addClass("hidden");
  $(".shuffle-click").removeClass("hidden");
  $("#search-box-container").removeClass("hidden");
  $("#optimizer-name").html("");
 // $('html, body').animate({scrollTop: $('#hide-add-block').offset().top}, 'slow');
});

/* 
END autocomplete
*/

$( document ).on( 'focusin', ".scroll-to-input", function(event) {
  $('html, body').animate({scrollTop: $(this).offset().top - 15});
});

$( document ).on( 'change keyup focusout', ".quantity-field-input-list", function(event) {
  $(this.form).submit();
});
$( document ).on( 'change', "#amount-from-suggestions", function(event) {
  var url = $("#add-or-delete-stepwise").attr("href");
  var new_amount = String($(this).val());
  var food_id = getQueryVariable(url, 'food_id');

  var list_id = getQueryVariable(url, 'list_id');
  var mode = getQueryVariable(url, 'mode');
  var percentage = getQueryVariable(url, 'percentage');
  var params = { 'food_id':food_id, 'list_id':list_id, 'mode':mode, 'amount': new_amount, 'percentage': percentage };
  var new_url = "/add_food_stepwise?" + jQuery.param(params);
  $("#add-or-delete-stepwise").attr("href",new_url);

  var params = { 'food_id':food_id, 'list_id':list_id, 'mode':mode, 'amount': new_amount, 'percentage': percentage, 'add_and_like': '1' };
  var new_url = "/add_food_stepwise?" + jQuery.param(params);
  $("#add-and-like-link").attr('href',new_url);

});

$( document ).on( 'input change keyup', "#user-carbohydrates", function(event) {
  $('#carbohydrates-list-show').text($(this).val());
});
$( document ).on( 'input change keyup', "#user-fat", function(event) {
  $('#fat-list-show').text($(this).val());
});
$( document ).on( 'input change keyup', "#user-protein", function(event) {
  $('#protein-list-show').text($(this).val());
});

$( document ).on( 'input change keyup', ".quantity-percentage", function(event) {
  $(this).parentsUntil(".item-grand-div").find('.quantity-percentage-show').text($(this).val());
});
$( document ).on( 'input change keyup', ".quantity-percentage-search", function(event) {
  $(this).parentsUntil(".search-result-grand-container").find('.quantity-percentage-search-show').text($(this).val());
});
$( document ).on( 'input change keyup', "#percentage_from_suggestions", function(event) {
  $(this).parentsUntil("#user-actions-in-suggestions").find('#quantity-percentage-show-from-suggestions').text($(this).val());

  var url = $("#add-or-delete-stepwise").attr("href");
  var food_id = getQueryVariable(url, 'food_id');
  var new_percentage = String($(this).val());

  var list_id = getQueryVariable(url, 'list_id');
  var mode = getQueryVariable(url, 'mode');  
  var amount = getQueryVariable(url, 'amount');

  var params = { 'food_id':food_id, 'list_id':list_id, 'mode':mode, 'amount': amount, 'percentage': new_percentage };
  var new_url = "/add_food_stepwise?" + jQuery.param(params);
  $("#add-or-delete-stepwise").attr("href",new_url);
  
  var params = { 'food_id':food_id, 'list_id':list_id, 'mode':mode, 'amount': amount, 'percentage': new_percentage, 'add_and_like': '1' };
  var new_url = "/add_food_stepwise?" + jQuery.param(params);
  $("#add-and-like-link").attr('href',new_url);


});
$( document ).on( 'change keyup focusout', ".quantity-field-input-list", function(event) {
  $(this.form).submit();
//  if ($(this).val() <= 0) {

  //  $(this).parent().find(".quantity-field-input-save-status").html("Can't be zero.");
 // } else {
 //   $(this).parent().find(".quantity-field-input-save-status").html("Enter to save.");
//  }
});
//$( document ).on( 'keyup', ".quantity-field-input-list", function(event) {
 // if(event.keyCode == 13) {
 //   if ($(this).val() > 0) {
      
 //     $(this).parent().find(".quantity-field-input-save-status").html("Saved!");
 //   } else if ($(this).val() <= 0) {
 //     $(this).parent().find(".quantity-field-input-save-status").html("Can't be zero.");
//    }
 // } else {
 //   if ($(this).val() > 0) {
 //     $(this).parent().find(".quantity-field-input-save-status").html("Enter to save.");
 //   } else {
 //     $(this).parent().find(".quantity-field-input-save-status").html("Can't be zero.");
 //   }
 // }
//});
//$( document ).on( 'focusout', ".quantity-field-input-list", function(event) {
//  if ($(this).val() > 0) {
//    $(this).parent().find(".quantity-field-input-save-status").html("");
//  }
//});

function submitMacronutrient() {

  if (!$("#fat-click").is(":checked") && !$("#protein-click").is(":checked") && !$("#carb-click").is(":checked")) {

    var current_total = parseInt($("#user-fat").val(),10)+parseInt($("#user-carbohydrates").val(),10)+parseInt($("#user-protein").val(),10);
    if (current_total != 100) {
      $('input:submit').attr("disabled", true);
     // $("#user-macronutrient-error").removeClass("hidden");
      $("#submit-button").addClass("hidden");
      $("#must-be-hundred-span").html("If all three macronutrients are specified, combined calories must total to 100%.");    
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#counter").html("The current total is "+String(current_total)+"%.");
    } else {
      if ($("#is-user-profile").length == 1) {
        $('input:submit').attr("disabled", false);
     //   $("#user-macronutrient-error").addClass("hidden");
      }
      if ($("#must-be-hundred").hasClass("warning-border")==true) {
        $("#counter").html("");
        $("#must-be-hundred").removeClass("warning-border");
        $("#must-be-hundred").addClass("success-border");
        $("#submit-button").removeClass("hidden");
        $("#must-be-hundred-span").html("Success!");    
      }
    }
  } else if ($("#fat-click").is(":checked") && $("#protein-click").is(":checked") && $("#fat-click").is(":checked")) {
    if ($("#is-user-profile").length == 1) {
      $('input:submit').attr("disabled", false);
     // $("#user-macronutrient-error").addClass("hidden");
    }
    if ($("#must-be-hundred").hasClass("warning-border")==true) {
      $("#counter").html("");
      $("#must-be-hundred").removeClass("warning-border");
      $("#must-be-hundred").addClass("success-border");
      $("#submit-button").removeClass("hidden");
      $("#must-be-hundred-span").html("Success!");    
    }
  } else if (!$("#fat-click").is(":checked") && !$("#protein-click").is(":checked")) {
    var fat_plus_protein = parseInt($("#user-fat").val(),10)+parseInt($("#user-protein").val(),10);
    if (fat_plus_protein > 90) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
    //  $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred-span").html("Combined calories from fat and protein cannot exceed 90% of your diet.");
      $("#counter").html("The current total is "+String(fat_plus_protein)+"%.");
    } else if (fat_plus_protein < 20) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
   //   $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred").html("Combined calories from fat and protein cannot be less than 20% of your diet.");
      $("#counter").html("The current total is "+String(fat_plus_protein)+"%.");
    } else {
      if ($("#is-user-profile").length == 1) {
        $('input:submit').attr("disabled", false);
     //   $("#user-macronutrient-error").addClass("hidden");
      }
      if ($("#must-be-hundred").hasClass("warning-border")==true) {
        $("#counter").html("");
        $("#must-be-hundred").removeClass("warning-border");
        $("#must-be-hundred").addClass("success-border");
        $("#submit-button").removeClass("hidden");
        $('input:submit').attr("disabled",false);
    //    $("#user-macronutrient-error").addClass("hidden");
        $("#must-be-hundred-span").html("Success!");    
      }
    } 
  } else if (!$("#fat-click").is(":checked") && !$("#carb-click").is(":checked")) {
    var fat_plus_carbohydrates = parseInt($("#user-fat").val(),10)+parseInt($("#user-carbohydrates").val(),10);
    if (fat_plus_carbohydrates > 90) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
    //  $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred-span").html("Combined calories from fat and carbohydrates cannot exceed 90% of your diet.");
      $("#counter").html("The current total is "+String(fat_plus_carbohydrates)+"%.");
    } else if (fat_plus_carbohydrates < 20) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
   //   $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred-span").html("Combined calories from fat and carbohydrates cannot be less than 20% of your diet.");
      $("#counter").html("The current total is "+String(fat_plus_carbohydrates)+"%.");
    } else {
      if ($("#is-user-profile").length == 1) {
        $('input:submit').attr("disabled", false);
      //  $("#user-macronutrient-error").addClass("hidden");
      }
      if ($("#must-be-hundred").hasClass("warning-border")==true) {
        $("#counter").html("");
        $("#must-be-hundred").removeClass("warning-border");
        $("#must-be-hundred").addClass("success-border");
        $("#submit-button").removeClass("hidden");
        $('input:submit').attr("disabled",false);
    //    $("#user-macronutrient-error").addClass("hidden");
        $("#must-be-hundred-span").html("Success!");    
      }
    }
  } else if (!$("#protein-click").is(":checked") && !$("#carb-click").is(":checked")) {
    var protein_plus_carbohydrates = parseInt($("#user-carbohydrates").val(),10)+parseInt($("#user-protein").val(),10);
    if (protein_plus_carbohydrates > 90) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
   //   $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred-span").html("Combined calories from protein and carbohydrates cannot exceed 90% of your diet.");
      $("#counter").html("The current total is "+String(protein_plus_carbohydrates)+"%.");
    } else if (protein_plus_carbohydrates < 20) {
      $("#submit-button").addClass("hidden");
      $('input:submit').attr("disabled", true);
   //   $("#user-macronutrient-error").removeClass("hidden");
      $("#must-be-hundred").removeClass("success-border");  
      $("#must-be-hundred").addClass("warning-border");
      $("#must-be-hundred-span").html("Combined calories from protein and carbohydrates cannot be less than 20% of your diet.");
      $("#counter").html("The current total is "+String(protein_plus_carbohydrates)+"%.");
    } else {
      if ($("#is-user-profile").length == 1) {
        $('input:submit').attr("disabled", false);
 //       $("#user-macronutrient-error").addClass("hidden");
      }
      if ($("#must-be-hundred").hasClass("warning-border")==true) {
        $("#counter").html("");
        $("#must-be-hundred").removeClass("warning-border");
        $("#must-be-hundred").addClass("success-border");
        $("#submit-button").removeClass("hidden");
        $('input:submit').attr("disabled", false);
     //   $("#user-macronutrient-error").addClass("hidden");
        $("#must-be-hundred-span").html("Success!");    
      }
    }
  } else {
    if ($("#is-user-profile").length == 1) {
      $('input:submit').attr("disabled", false);
  //    $("#user-macronutrient-error").addClass("hidden");
    }
    if ($("#must-be-hundred").hasClass("warning-border")==true) {
      $("#counter").html("");
      $("#must-be-hundred").removeClass("warning-border");
      $("#must-be-hundred").addClass("success-border");
      $("#submit-button").removeClass("hidden");
      $('input:submit').attr("disabled", false)
 //     $("#user-macronutrient-error").addClass("hidden")
      $("#must-be-hundred-span").html("Success!");    
    }
  }
}

function pieMacro() {

  var total_carbohydrates = $("#total-carbohydrates-list").html();
  var total_carbohydrates_calories = total_carbohydrates * 4;
  var total_fat = $("#total-fat-list").html();
  var total_fat_calories = total_fat * 9;
  var total_protein = $("#total-protein-list").html();
  var total_protein_calories = total_protein * 4;
  var total_calories_by_macronutrients = total_protein_calories + total_fat_calories + total_carbohydrates_calories;
  if (total_calories_by_macronutrients != 0) {
    $("#pie-wrapper").show();
    var degrees_carbohydrates = Math.round(360*(total_carbohydrates_calories/total_calories_by_macronutrients));
    var degrees_fat = Math.round(360*(total_fat_calories/total_calories_by_macronutrients));
    var degrees_protein = Math.round(360*(total_protein_calories/total_calories_by_macronutrients));
    if (degrees_protein >= 180) {
      var transform_fat_right = "0";
      var transform_fat_left = String(180 - degrees_carbohydrates);
      var transform_protein_right = "180";
      var transform_protein_left = String(degrees_protein - 180);
      var transform_carbohydrates_right = "0";
      var transform_carbohydrates_left = String(-1*degrees_carbohydrates);
    } else if (degrees_fat + degrees_protein >= 180) {
      var transform_fat_left = String(180 - degrees_carbohydrates);
      var transform_fat_right = "180";
      var transform_protein_left = "0";
      var transform_protein_right = String(degrees_protein);
      var transform_carbohydrates_right = "0";
      var transform_carbohydrates_left = String(-1*degrees_carbohydrates);
    } else {
      var transform_fat_left = "0";
      var transform_fat_right = String(360-degrees_carbohydrates);
      var transform_protein_left = "0";
      var transform_protein_right = String(degrees_protein);
      var transform_carbohydrates_right = String(180-degrees_carbohydrates);
      var transform_carbohydrates_left = "180";
    }
    $("#pie_chart ul :nth-child(1) p, #macronutrient-pie:target #pie_chart ul :nth-child(1) p").css(
        {"transform":"rotate("+transform_carbohydrates_right+"deg)",
        "-moz-transform":"rotate("+transform_carbohydrates_right+"deg)",
        "-webkit-transform":"rotate("+transform_carbohydrates_right+"deg)",
        "-o-transform":"rotate("+transform_carbohydrates_right+"deg)"});
    $("#pie_chart ul :nth-child(2) p, #macronutrient-pie:target #pie_chart ul :nth-child(2) p").css(
        {"transform":"rotate("+transform_carbohydrates_left+"deg)",
        "-moz-transform":"rotate("+transform_carbohydrates_left+"deg)",
        "-webkit-transform":"rotate("+transform_carbohydrates_left+"deg)",
        "-o-transform":"rotate("+transform_carbohydrates_left+"deg)"});
    $("#pie_chart ul :nth-child(3) p, #macronutrient-pie:target #pie_chart ul :nth-child(3) p").css(
        {"transform":"rotate("+transform_fat_right+"deg)",
        "-moz-transform":"rotate("+transform_fat_right+"deg)",
        "-webkit-transform":"rotate("+transform_fat_right+"deg)",
        "-o-transform":"rotate("+transform_fat_right+"deg)"});
    $("#pie_chart ul :nth-child(4) p, #macronutrient-pie:target #pie_chart ul :nth-child(4) p").css(
        {"transform":"rotate("+transform_fat_left+"deg)",
        "-moz-transform":"rotate("+transform_fat_left+"deg)",
        "-webkit-transform":"rotate("+transform_fat_left+"deg)",
        "-o-transform":"rotate("+transform_fat_left+"deg)"});
    $("#pie_chart ul :nth-child(5) p, #macronutrient-pie:target #pie_chart ul :nth-child(5) p").css(
        {"transform":"rotate("+transform_protein_right+"deg)",
        "-moz-transform":"rotate("+transform_protein_right+"deg)",
        "-webkit-transform":"rotate("+transform_protein_right+"deg)",
        "-o-transform":"rotate("+transform_protein_right+"deg)"});
    $("#pie_chart ul :nth-child(6) p, #macronutrient-pie:target #pie_chart ul :nth-child(6) p").css(
        {"transform":"rotate("+transform_protein_left+"deg)",
        "-moz-transform":"rotate("+transform_protein_left+"deg)",
        "-webkit-transform":"rotate("+transform_protein_left+"deg)",
        "-o-transform":"rotate("+transform_protein_left+"deg)"});
  } else {
    $("#pie-wrapper").hide();
  }
  $(".boxlab").css("background","none")
}

function changePercentageMaxOrMin(elem, perc) {
  var $div = $(elem).find('div');
  if (perc == "100") {
    $div.html('<span class="simple-nutrition percentage-label"></span>');
    $(elem).attr("data-original-title","");
  }

  $div.css('width', perc + '%');
  if(perc != 100) {
   //   if($("#list-user-is-current-user").length == 1) {
   //     $(elem).attr("data-original-title","Try using SUGGESTIONS and AUTOCOMPLETE buttons to meet your nutrition needs.");
   //   }
      if(perc > 100) {
        $div.html('<span class="simple-nutrition percentage-label">'+perc + '%</span>');
        $div.css('width', '100%');
        $(elem).addClass('out-of-range-above');
        $(elem).removeClass('out-of-range-below');
      } else {
        $div.html('<span class="simple-nutrition percentage-label">'+perc + '%</span>');
        $(elem).removeClass('out-of-range-above');
        $(elem).addClass('out-of-range-below');
      }
  } else {
      $(elem).removeClass('out-of-range-above');
      $(elem).removeClass('out-of-range-below');
      $(elem).attr("data-original-title","");
  }
  if ($("#hide-detailed-nutrition-link").hasClass("hidden") == true) {
    $(".detailed-nutrition").hide();
  } else {
    $(".detailed-nutrition").show();
  }
  $(".percentage-label").parent().css("text-align","left")
}

function changePercentageMax(elem, perc) {
  var $div = $(elem).find('div');
  if (perc <= 100) {
    $div.html('<span class="simple-nutrition percentage-label"></span>');
  } else {
    $div.html('<span class="simple-nutrition percentage-label">'+perc + '%</span>');
  }
  if ($("#show-detailed-nutrition-link").hasClass("hidden") == true) {
    $(".detailed-nutrition").show();
  }
  $div.css('width', perc + '%');
  if(perc > 100) {
   //   if($("#list-user-is-current-user").length == 1) {
   //     $(elem).attr("data-original-title","Try using SUGGESTIONS and AUTOCOMPLETE buttons to meet your nutrition needs.");
   //   }
      $div.css('width', '100' + '%');
      $(elem).addClass('out-of-range-above');
  }
  else {
      $(elem).attr("data-original-title","");
      $(elem).removeClass('out-of-range-above');
  }
  $(".percentage-label").parent().css("text-align","left")
}
function changePercentageMin(elem, perc) {
  var $div = $(elem).find('div');
  if (perc >= 100) {
    $div.html('<span class="simple-nutrition percentage-label"></span>');
  } else {
    $div.html('<span class="simple-nutrition percentage-label">'+perc + '%</span>');
  }
  if ($("#show-detailed-nutrition-link").hasClass("hidden") == true) {
    $(".detailed-nutrition").show();
  }  
  $div.css('width', perc + '%');
  if(perc < 100 ) {
//    if($("#list-user-is-current-user").length == 1) {
//      $(elem).attr("data-original-title","Try using SUGGESTIONS and AUTOCOMPLETE buttons to meet your nutrition needs.");
//    }
    $(elem).addClass('out-of-range-below');
  }
  else {
    $(elem).attr("data-original-title","");
    $div.css('width', '100%');
    $(elem).removeClass('out-of-range-below');
  }
  $(".percentage-label").parent().css("text-align","left")
}


function docReady() {

  $("h1,h2").css("text-shadow","none");
  $("body div").css("text-shadow","none");
  $("#home-items h1").css("letter-spacing",1);

  /* BEGIN STRIPE */
  $(".stripe-button-el span").html("JOIN TODAY");
  $(".stripe-button-el").removeClass("stripe-button-el").addClass("btn").addClass("wide-button");
  /* END STRIPE */

  //$(document).on("click", '.dietary_restrictions .ui-btn', function(event) {
  //  setTimeout(function () {
    //  $("#edit-user-submit-button").click();   
  //  }, 100);
 //});
  $(document).on("click", '.root-cat', function(event) {

    var root_cat = $(this).parent().attr('id');
    if ($(this).parentsUntil(".root-cat-container").parent().find(".sub-cat").hasClass("hidden") == true) {
      $(".sub-cat").addClass("hidden");
      $(this).parentsUntil(".root-cat-container").parent().find(".sub-cat").removeClass("hidden");
      $("."+root_cat).removeClass("hidden");
    } else {
      $(".sub-cat").addClass("hidden");
      $(".food-name").addClass("hidden");
    }
    $('html, body').animate({scrollTop: $(this).offset().top});
  });

  $(document).on("click", '#show-list-view-link', function(event) { 
    $("#edit-list-parameters").addClass("hidden");
    $("#section-two").removeClass("hidden");
    $(".show-edit-list-parameters-link").removeClass("hidden");
    $("#hide-edit-list-parameters-link").addClass("hidden");
    $(this).addClass("hidden");
    $(".show-full-view-link").removeClass("hidden");
    $("#bring-checklist-to-store").removeClass("hidden");
    $("#bought-groceries-link").removeClass("hidden");
    $("#list-view-items-container").removeClass("hidden");
    $("#full-view-container").addClass("hidden");
    $("nav").addClass("hidden");
    $(".top-of-list").addClass("hidden");
    $("footer").addClass("hidden");
    $("#list-buttons").addClass("hidden");
  });

  if ($("#calories-progress").length != 0) {
    changePercentageMaxOrMin('#progressbar-calories', Math.round(parseFloat($("#calories-progress").html())));
    changePercentageMaxOrMin('#progressbar-carbohydrates', Math.round(parseFloat($("#carbohydrates-progress").html())));
    changePercentageMaxOrMin('#progressbar-fat', Math.round(parseFloat($("#fat-progress").html())));
    changePercentageMaxOrMin('#progressbar-protein', Math.round(parseFloat($("#protein-progress").html())));
    changePercentageMin('#progressbar-fiber', parseFloat($("#fiber-progress").html()));
    changePercentageMax('#progressbar-sodium', parseFloat($("#sodium-progress").html()));
    changePercentageMaxOrMin('#progressbar-vitamin_a', parseFloat($("#vitamin_a-progress").html()));
    changePercentageMaxOrMin('#progressbar-vitamin_c', parseFloat($("#vitamin_c-progress").html()));
    changePercentageMaxOrMin('#progressbar-calcium', parseFloat($("#calcium-progress").html()));
    changePercentageMaxOrMin('#progressbar-iron', parseFloat($("#iron-progress").html()));
  }
  $( document ).on( 'click', '#dismiss-notice', function() {
    $(this).parentsUntil(".notice").parent().slideUp();
  });
  $( document ).on( 'click', '.delete-post', function() {
    $(this).parentsUntil(".post-li").parent().remove();
  });
  $( document ).on( 'click', '.delete-list', function() {
    $(this).parentsUntil(".list-grand-div-container").parent().remove();
  });

  updateHeight();




  $("#user-carbohydrates").on("input change keyup", function(e){
    submitMacronutrient();
  });
  $("#user-fat").on("input change keyup", function(e){
    submitMacronutrient();
  });
  $("#user-protein").on("input change keyup", function(e){
    submitMacronutrient();
  });





  $("#user_birthday_1i").css({"width":"100%"});
  $("#user_birthday_2i").css({"width":"100%"});
  $("#user_birthday_3i").css({"width":"100%"});
  $("#user_birthday_1i-button").css({"padding":"0"});
  $("#user_birthday_2i-button").css({"padding":"0"});
  $("#user_birthday_3i-button").css({"padding":"0"});
  $("h1 a").css("color","black");

  rootCat();
  pieMacro();





  //LIST SHOW FIELDS

  $(".show-edit-list-parameters-link").click(function() {
    $("#dishes-container").addClass("hidden");
    $("#list-standard").addClass("hidden");
    $("#edit-list-parameters").removeClass("hidden");
    $("#section-two").addClass("hidden");
    $(".list-header").addClass("hidden");
    $(".show-edit-list-parameters-link").addClass("hidden");
    $("#hide-edit-list-parameters-link").removeClass("hidden");
    $(".hide-when-settings-are-shown").hide();
    $('#show-fixed-bottom-bar').addClass("hidden");
    $('#hide-fixed-bottom-bar').hide();
  });
  $("#hide-edit-list-parameters-link").click(function() {
    $("#edit-list-parameters").addClass("hidden");
    $("#dishes-container").removeClass("hidden");
    $("#list-standard").removeClass("hidden");
    $("#section-two").removeClass("hidden");
    $(".list-header").removeClass("hidden");
    $(".show-edit-list-parameters-link").removeClass("hidden");
    $("#hide-edit-list-parameters-link").addClass("hidden");
    $(".hide-when-settings-are-shown").show();
    $('html, body').animate({scrollTop: 0});
    $('#show-fixed-bottom-bar').addClass("hidden");
    $('#hide-fixed-bottom-bar').show();
  });
  $(document).on("click", '#hide-fixed-bottom-bar', function(event) { 
    $(".fixed-bottom-bar").addClass("hidden");
    $('#show-fixed-bottom-bar').removeClass("hidden");
    $('#hide-fixed-bottom-bar').hide();

  });
  $(document).on("click", '#show-fixed-bottom-bar', function(event) { 
    $(".fixed-bottom-bar").removeClass("hidden");
    $('#show-fixed-bottom-bar').addClass("hidden");
    $('#hide-fixed-bottom-bar').show();
  });

  $("#list-title-edit, #list-note-edit, #list-private-note-edit").focus(function() {
    //if (!$("#show-fixed-bottom-bar").hasClass("hidden")) {
      $(".fixed-bottom-bar").hide();
    //}
  });
  $("#list-title-edit, #list-note-edit, #list-private-note-edit").focusout(function() {
    //if ($("#show-fixed-bottom-bar").hasClass("hidden")) {
      $(".fixed-bottom-bar").show();
    //}
  });

  $("#list-title-edit-submit").click(function() {

    //if(event.keyCode == 13) {
      var new_list_title = $("#list-title-edit").val();
      $(this.form).submit();
      $("#list-title-main").html(new_list_title.replace(/\b\w/g, l => l.toUpperCase()));
      $("#edit-title-modal-close").click();
     // $("#list-title").removeClass("hidden");
     // $("#list-title-edit-container").addClass("hidden");
      $(':focus').blur();
    //}
  });
  $("#list-note-edit").keyup(function(event){
    var char_remaining = 140-$("#list-note-edit").val().length;
    $("#list-note-characters-remaining").html(char_remaining);
    if (char_remaining < 0) {
      $("#list-note-characters-remaining").css("color","red");
      $("input#list-note-edit-submit").prop("disabled",true);
      $("#list-note-edit-submit").css("color","red");
    } else {
      $("#list-note-characters-remaining").css("color","gray");
      $("input#list-note-edit-submit").prop("disabled",false);
      $("#list-note-edit-submit").css("color","");
    }  
  });
  $("#list-note-edit-submit").click(function() {
    var new_list_note = $("#list-note-edit").val();
    var new_list_note_replace = new_list_note.replace(/\b\w/g, l => l);//.replace(/\n(?!.*\n)/, '');
    var new_html = new_list_note_replace.replace(/\b\w/g, l => l).replace(/\r?\n/g, '<br />');
    $("#list-note-edit").val(new_list_note_replace);
    var new_html_autolink = new_html.replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1" target="_blank">$1</a> ');
    $(this.form).submit();
    $("#list-note-main").html(new_html_autolink);
    $(':focus').blur();
    $("#edit-description-modal-close").click();
  });
  $("#list-private-note-edit-submit").click(function() {
    var new_list_private_note = $("#list-private-note-edit").val();
    var new_list_private_note_replace = new_list_private_note.replace(/\b\w/g, l => l);//.replace(/\n(?!.*\n)/, '');
    var new_html = new_list_private_note_replace.replace(/\b\w/g, l => l).replace(/\r?\n/g, '<br />');
    if (new_html == "") {
      new_html = "Write notes for yourself.";
    }
    $("#list-private-note-edit").val(new_list_private_note_replace);
    var new_html_autolink = new_html.replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1" target="_blank">$1</a> ');
    $(this.form).submit();
    $("#list-private-note-main").html(new_html_autolink);
    $(':focus').blur();
    $("#edit-private-note-modal-close").click();
  });
  if ($("#list-note-main").length > 0) {
    var list_note = $("#list-note-main").html();
    var list_note_replace = list_note.replace(/\b\w/g, l => l);//.replace(/\n(?!.*\n)/, '');
    var new_html = list_note_replace.replace(/\b\w/g, l => l).replace(/\r?\n/g, '<br />');
    var new_html_autolink = new_html.replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1" target="_blank">$1</a> ');
    $("#list-note-main").html(new_html_autolink);
    $('#list-note-main br:lt(1)').remove();
  }
  if ($("#list-private-note-main").length > 0) {
    var list_private_note = $("#list-private-note-main").html();
    var list_private_note_replace = list_private_note.replace(/\b\w/g, l => l);//.replace(/\n(?!.*\n)/, '');
    var new_html = list_private_note_replace.replace(/\b\w/g, l => l).replace(/\r?\n/g, '<br />');
    var new_html_autolink = new_html.replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1" target="_blank">$1</a> ');
    $("#list-private-note-main").html(new_html_autolink);
    $('#list-private-note-main br:lt(1)').remove();
  }
  if ($(".activity-link").length > 0) {
    $( ".activity-link" ).each(function( index ) {
      var list_note = $(this).html();
      var list_note_replace = list_note.replace(/\b\w/g, l => l);//.replace(/\n(?!.*\n)/, '');
      var new_html = list_note_replace.replace(/\b\w/g, l => l).replace(/\r?\n/g, '<br />');
      var new_html_autolink = new_html.replace(/((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g, '<a href="$1" target="_blank">$1</a> ');
      $(this).html(new_html_autolink);
      $('.activity-link br:lt(1)').remove();    
    });
  }

  $("#list-title").click(function() {
//    $("#list-title-edit-container").removeClass("hidden");
//    $("#list-title").addClass("hidden");
    val = $("#list-title-edit").val();
    $("#list-title-edit").focus();
    $("#list-title-edit").val('');
    $("#list-title-edit").val(val);
  });
  $(".list-note").click(function(e) {
    var target  = $(e.target);
    if( target.is('a') ) {
        return true; // True, because we don't want to cancel the 'a' click.
    }

    //$("#list-note-edit-container").removeClass("hidden");
    $("#list-note-edit").css("width","100%");
   // $(".list-note").addClass("hidden");
    val = $("#list-note-edit").val();
    $("#list-note-edit").focus();
    $("#list-note-edit").val('');
    $("#list-note-edit").val(val);
    $("#list-note-edit").height($("#list-note-edit")[0].scrollHeight);
    var char_remaining = 140-$("#list-note-edit").val().length;
    $("#list-note-characters-remaining").html(char_remaining);
    if (char_remaining < 0) {
      $("#list-note-characters-remaining").css("color","red");
      $("input#list-note-edit-submit").prop("disabled",true);
      $("#list-note-edit-submit").css("color","red");
    } else {
      $("#list-note-characters-remaining").css("color","gray");
      $("input#list-note-edit-submit").prop("disabled",false);
      $("#list-note-edit-submit").css("color","");
    }    
  });
  $(".list-private-note").click(function(e) {
    var target  = $(e.target);
    if( target.is('a') ) {
        return true; // True, because we don't want to cancel the 'a' click.
    }

    //$("#list-note-edit-container").removeClass("hidden");
    $("#list-private-note-edit").css("width","100%");
   // $(".list-note").addClass("hidden");
    val = $("#list-private-note-edit").val();
    $("#list-private-note-edit").focus();
    $("#list-private-note-edit").val('');
    $("#list-private-note-edit").val(val);
    $("#list-private-note-edit").height($("#list-private-note-edit")[0].scrollHeight);
  });
  $("#max-price-show-edit").keyup(function(event){
    if(event.keyCode == 13) {
      var new_budget = "Budget: $"+String(parseFloat(Math.round($(this).val() * 100) / 100).toFixed(2));
      $(this.form).submit();
      $("#max-price-show-main").html(new_budget.replace(/\b\w/g, l => l.toUpperCase()));
      $("#max-price-show").removeClass("hidden");
      $("#max-price-show-edit-container").addClass("hidden");
    }
  });
  $(".search-submit").click(function() {
    $(".search-results-container").html("<div class='col-md-12 col-sm-12 col-xs-12 text-center'>Please wait while the nutrition algorithm searches.</div>");
    //$(':focus').blur();
    $(".search-results-container").removeClass("hidden");
    $("#frequent-foods-box-list-2").addClass("hidden");
    $("#top-foods-box-list").addClass("hidden");
    $("#by-aisle-box-list").addClass("hidden");
    $(".fixed-bottom-bar").hide();
  });



    




  $(document).on("click", '#curate-toggle', function(event) {
    if ($(".curate-list").hasClass("hidden")) {
      $(".curate-list").removeClass("hidden");
    } else {
      $(".curate-list").addClass("hidden");
    }
    
  });



  $(document).on("click", '#clear-search-results', function(event) { 
    $(".search-results-container").html("");
    $(".search-results-container").addClass("hidden");
    $(".fixed-bottom-bar").show();
    $("#top-foods-box-list").addClass("hidden");
    $("#by-aisle-box-list").addClass("hidden");
    $("#frequent-foods-box-list-2").addClass("hidden");
    $("#clear-search-results").addClass("hidden");
    $(".root-cat-container-items").css("opacity",1)

    $("#search").val("");

  });
  $(document).on("click", '.browse-by-aisle-click', function(event) { 
    $("#browse-results-container").html("The nutrition algorithm is thinking.");
  });
  
  $(document).on("click", '#add-foods-frequents-2', function(event) { 
    $(".search-results-container").html("");
    $("#clear-search-results").addClass("hidden");
    $(".search-results-container").addClass("hidden");

    if ($("#frequent-foods-box-list-2").hasClass("hidden")) {
      $("#frequent-foods-box-list-2").removeClass("hidden");
    } else {
      $("#frequent-foods-box-list-2").addClass("hidden");
    }
    $("#top-foods-box-list").addClass("hidden");
    $("#by-aisle-box-list").addClass("hidden");
  });
  $(document).on("click", '#add-foods-likes-2', function(event) { 
    $(".search-results-container").html("");
    $("#clear-search-results").addClass("hidden");
    $(".search-results-container").addClass("hidden");

    $("#frequent-foods-box-list-2").addClass("hidden");
    if ($("#top-foods-box-list").hasClass("hidden")) {
      $("#top-foods-box-list").removeClass("hidden");
    } else {
      $("#top-foods-box-list").addClass("hidden");
    }
    $("#by-aisle-box-list").addClass("hidden");
  });
  $(document).on("click", '#browse-by-aisle', function(event) { 
    $(".search-results-container").html("");
    $("#clear-search-results").addClass("hidden");
    $(".search-results-container").addClass("hidden");

    $("#frequent-foods-box-list-2").addClass("hidden");
    $("#top-foods-box-list").addClass("hidden");
    if ($("#by-aisle-box-list").hasClass("hidden")) {
      $("#by-aisle-box-list").removeClass("hidden");
    } else {
      $("#by-aisle-box-list").addClass("hidden");
    }
    
  });


 // $("#search").keyup(function(event){
 //   if(event.keyCode == 13) {
 //     $(".search-results-container").html("<div class='col-md-12 col-sm-12 col-xs-12 text-center'>Please wait while the nutrition algorithm searches.</div>");
 //   }
 // });
  $("#search").focus(function(event){
    $('.fixed-bottom-bar').hide();
    $('html, body').animate({scrollTop: $('#search').offset().top - 15});
    $(".root-cat-container-items").css("opacity",0.4);
    
  });
  $("#search").focusout(function(event){
    $('.fixed-bottom-bar').show();
    if ($(".search-results-container").hasClass("hidden")) {
      $(".root-cat-container-items").css("opacity",1);
    }
  });

  $("#max-price-show-edit").blur(function(event){
    var new_budget = "Budget: $"+String(parseFloat(Math.round($(this).val() * 100) / 100).toFixed(2));
    $(this.form).submit();
    $("#max-price-show-main").html(new_budget.replace(/\b\w/g, l => l.toUpperCase()));
    $("#max-price-show").removeClass("hidden");
    $("#max-price-show-edit-container").addClass("hidden");
  });

  $("#max-price-show").click(function() {
    $("#max-price-show-edit-container").removeClass("hidden");
    $("#max-price-show").addClass("hidden");
    val = parseFloat(Math.round($("#max-price-show-edit").val() * 100) / 100).toFixed(2);
    $("#max-price-show-edit").focus();
    $("#max-price-show-edit").val('');
    $("#max-price-show-edit").val(val);
  });

  $(".age-field-input-edit-profile").parent().hide();

  


  $('[data-toggle="tooltip"]').tooltip(); 

 
  var problem = false;

// parseInt($("#total-iron-day").html().replace(/\D/g,''), 10)

  $(".shuffle-click").on("click", function(event) {
    $(this).addClass("hidden");
    $("#search-box-container").addClass("hidden");
    $(".search-results-container").html("");
    $(".search-results-container").addClass("hidden");
    $("#top-foods-box-list").addClass("hidden");
    $("#by-aisle-box-list").addClass("hidden");
    $("#browse-text").hide();
    $(".browse-categories-buttons").hide();
    $("#frequent-foods-box-list-2").addClass("hidden");
    $("#clear-search-results").addClass("hidden");
    $("#search").val("");
    $('html, body').animate({scrollTop: $('#stepwise-response-box-container').offset().top});
    $("#optimizer-name").html('');
    $(".cancel-auto").addClass("hidden");
    $("#edit-list-parameters").addClass("hidden");
    $("#section-two").removeClass("hidden");
    $(".show-edit-list-parameters-link").removeClass("hidden");
    $("#hide-edit-list-parameters-link").addClass("hidden");
    $("#stepwise-response").html('');
    $("#stepwise-response").removeClass("hidden");
    $("#stepwise-response-box-container").removeClass("hidden");
    $("#stepwise-response-box").removeClass("hidden");

    $("#cancel-auto-indicator").html("AUTO");
    $("#searcher-box-list").addClass("hidden")
    $("#stepwise-response-box-container").removeClass("hidden")
  });
  $("#user-likes-box-link").on("click", function(event) {
    $("#user-likes-box-container").removeClass("hidden");

  });
  $(".dim-when-clicked").on("click", function(event) {
    $("#stepwise-response-box").css("opacity",0.5);
  });
  $("#add-or-delete-stepwise-button").on("click", function(event) {

    //$("#stepwise-response").html('');
    //$("#add-or-delete-stepwise").addClass("hidden");
    //$("#shuffle-stepwise-skip").addClass("hidden");
    //$("#add-and-like").html('');
    //$("#skip-or-delete-and-dislike").html('');
    //$("#amount-from-suggestions").addClass("hidden");
    //$("#user-actions-in-suggestions").addClass("hidden");
    //$("#amount-and-percentage").addClass("hidden");
  });
  $("#shuffle-stepwise-skip").on("click", function(event) {
  //  $("#stepwise-response").html('');
  //  $("#add-or-delete-stepwise").addClass("hidden");
  //  $("#shuffle-stepwise-skip").addClass("hidden");
  //  $("#add-and-like").html('');
  //  $("#skip-or-delete-and-dislike").html('');
  //  $("#amount-from-suggestions").addClass("hidden");
  //  $("#user-actions-in-suggestions").addClass("hidden");
  //  $("#amount-and-percentage").addClass("hidden");
  });
  $("#add-and-like-link").on("click", function(event) {
    $("#stepwise-response").html('');
    $("#add-or-delete-stepwise").addClass("hidden");
    $("#shuffle-stepwise-skip").addClass("hidden");
    $("#add-and-like").html('');
    $("#skip-or-delete-and-dislike").html('');
    $("#amount-from-suggestions").addClass("hidden");
    $("#user-actions-in-suggestions").addClass("hidden");
    $("#amount-and-percentage").addClass("hidden");
  });
  $("#delete-and-dislike-link").on("click", function(event) {
    $("#stepwise-response").html('');
    $("#add-or-delete-stepwise").addClass("hidden");
    $("#shuffle-stepwise-skip").addClass("hidden");
    $("#add-and-like").html('');
    $("#skip-or-delete-and-dislike").html('');
    $("#amount-from-suggestions").addClass("hidden");
    $("#user-actions-in-suggestions").addClass("hidden");
    $("#amount-and-percentage").addClass("hidden");
  });
  $("#skip-and-dislike-link").on("click", function(event) {
    $("#stepwise-response").html('');
    $("#add-or-delete-stepwise").addClass("hidden");
    $("#shuffle-stepwise-skip").addClass("hidden");
    $("#add-and-like").html('');
    $("#skip-or-delete-and-dislike").html('');
    $("#amount-from-suggestions").addClass("hidden");
    $("#user-actions-in-suggestions").addClass("hidden");
    $("#amount-and-percentage").addClass("hidden");
  });
  $(".shuffle-stepwise-enough").on("click", function(event) {
    $(".shuffle-stepwise-enough").addClass("hidden");
    $("#optimizer-name").html("");
    $("#browse-text").show();
    $("#browse-text").html("<i class='fa fa-angle-up fa-2x' aria-hidden='true'></i>");
    $(".browse-categories-buttons").show();
    $("#stepwise-response").addClass("hidden");
    $("#stepwise-response-box-container").addClass("hidden");
    $("#stepwise-response-box").addClass("hidden");
    $("#add-or-delete-stepwise").addClass("hidden");
    $("#shuffle-stepwise-skip").addClass("hidden");
    $(".shuffle-click").removeClass("hidden");
    $("#search-box-container").removeClass("hidden");
    $("#add-and-like").addClass("hidden");
    $("#amount-from-suggestions").addClass("hidden");
    $("#user-actions-in-suggestions").addClass("hidden");
    $("#skip-or-delete-and-dislike").addClass("hidden");
    $("#amount-and-percentage").addClass("hidden");
    $('html, body').animate({scrollTop: $('#hide-add-block').offset().top}, 'slow');
  });

  $(".user-likes-enough").on("click", function(event) {
    $("#user-likes-box-container").addClass("hidden");
  });


  $('.dropdown-toggle').dropdown();
  $("#browse-categories").on("click", function(event) {
    if ($("#search-box-container").hasClass("hidden")) {
      $("#browse-text").html("<i class='fa fa-angle-up fa-2x' aria-hidden='true'></i>");
      $("#search-box-container").removeClass("hidden");
    } else {

      $("#browse-text").html("<div class='tiny-text'>FREQUENTS AND FAVORITES</div>");
      $("#search-box-container").addClass("hidden");
    }
  });

  



  $("#search").css("width","100%");
  $("#search").parent().css("max-width","none");
  $("#search_favorite").css("width","100%");
  $("#search_favorite").parent().css("max-width","none");
  $("#search_dislike").css("width","100%");
  $("#search_dislike").parent().css("max-width","none");

  $(".search-box").css("width","auto");
  $("#uncheck-all").on("click", function(event) {
    $(".ui-checkbox-on").addClass("ui-checkbox-off").removeClass("ui-checkbox-on");
  });


  if ($("#default-carb").length == 1) {
    if ($("#default-carb").html() == "" || $("#default-carb").html() == "-1") {
     // $("#user-carb-checkbox").attr("checked",true).checkboxradio("refresh");
      $("#user-carbohydrates-slider-container").addClass("hidden");
      $("#user-carbohydrates").attr("min",-1);
      $("#user-carbohydrates").val(-1);
    }
  }  
  quantityArrows();
  pantry();





  //Allow user to specify macronutrients. Ensure that reasonable / feasible values are selected.
  $("#carb-click").on("click", function(event) {

    if ($("#user-carbohydrates-slider-container").hasClass("hidden")) {

      $("#user-carbohydrates-slider-container").removeClass("hidden");
      $("#user-carbohydrates").attr("min",1);
      var protein_slider_val = $("#user-protein").val();
      var protein_slider = parseInt(protein_slider_val,10);
      var fat_slider_val = $("#user-fat").val();
      var fat_slider = parseInt(fat_slider_val,10);
      if (protein_slider != -1 || fat_slider != -1 || protein_slider_val != "" || fat_slider_val != "") {
        if (protein_slider != -1 && fat_slider != -1 && protein_slider_val != "" && fat_slider_val != "") {
          var carbohydrates_specify = 100 - (protein_slider+fat_slider);
        } else if (fat_slider != -1 && fat_slider_val != "" && (protein_slider == -1 || protein_slider_val == "")) {
          if (fat_slider + 40 > 90) {
            var carbohydrates_specify = 90 - fat_slider;
          } else {
            var carbohydrates_specify = 40;
          }
        } else if (protein_slider != -1 && protein_slider_val != "" && (fat_slider == -1 || fat_slider_val == "")) {
          if (protein_slider + 40 > 90) {
            var carbohydrates_specify = 90 - protein_slider;
          } else {
            var carbohydrates_specify = 40;
          }
        } else {
          var carbohydrates_specify = 40;
        }
      } else {
        var carbohydrates_specify = 40;
      }
      $("#user-carbohydrates").val(carbohydrates_specify);
      
      $("#carbohydrates-list-show").text(carbohydrates_specify)
      submitMacronutrient();
    } else {
      $("#user-carbohydrates-slider-container").addClass("hidden");
      $("#user-carbohydrates").attr("min",-1);
      $("#user-carbohydrates").val(-1);
      submitMacronutrient();
    }
  });

  if ($("#default-fat").length == 1) {
    if ($("#default-fat").html() == "" || $("#default-fat").html() == "-1") {
   //   $("#user-fat-checkbox").attr("checked",true).checkboxradio("refresh");
      $("#user-fat-slider-container").addClass("hidden");
      $("#user-fat").attr("min",-1);
      $("#user-fat").val(-1);
    }
  }
  $("#fat-click").on("click", function(event) {
    if ($("#user-fat-slider-container").hasClass("hidden")) {
      $("#user-fat-slider-container").removeClass("hidden");
      //$("#user-fat-slider").attr("min",10);
      $("#user-fat").attr("min",1);
      var protein_slider_val = $("#user-protein").val();
      var protein_slider = parseInt(protein_slider_val,10);
      var carbohydrates_slider_val = $("#user-carbohydrates").val();
      var carbohydrates_slider = parseInt(carbohydrates_slider_val,10);
      if (protein_slider != -1 || carbohydrates_slider != -1 || protein_slider_val != "" || carbohydrates_slider_val != "") {
        if (protein_slider != -1 && carbohydrates_slider != -1 && protein_slider_val != "" && carbohydrates_slider_val != "") {
          var fat_specify = 100 - (protein_slider+carbohydrates_slider);
        } else if (carbohydrates_slider != -1 && carbohydrates_slider_val != "" && (protein_slider == -1 || protein_slider_val == "")) {
          if (carbohydrates_slider + 30 > 90) {
            var fat_specify = 90 - carbohydrates_slider;
          } else {
            var fat_specify = 30;
          }
        } else if (protein_slider != -1 && protein_slider_val != "" && (carbohydrates_slider == -1 || carbohydrates_slider_val == "")) {
          if (protein_slider + 30 > 90) {
            var fat_specify = 90 - protein_slider;
          } else {
            var fat_specify = 30;
          }
        } else {
          var fat_specify = 30;
        }
      } else {
        var fat_specify = 30;
      }
      $("#user-fat").val(fat_specify);
      $("#fat-list-show").text(fat_specify)
      submitMacronutrient();
    } else {
      $("#user-fat-slider-container").addClass("hidden");
      $("#user-fat").attr("min",-1);
      $("#user-fat").val(-1);
      submitMacronutrient();
    }    
  });


  if ($("#default-protein").length == 1) {
    if ($("#default-protein").html() == "" || $("#default-protein").html() == "-1") {
    //  $("#user-protein-checkbox").attr("checked",true).checkboxradio("refresh");
      $("#user-protein-slider-container").addClass("hidden");
      $("#user-protein").attr("min",-1);
      $("#user-protein").val(-1);
    }
  }
  $("#protein-click").on("click", function(event) {
    if ($("#user-protein-slider-container").hasClass("hidden")) {
      $("#user-protein-slider-container").removeClass("hidden");
      $("#user-protein").attr("min",1);
      var fat_slider_val = $("#user-fat").val();
      var fat_slider = parseInt(fat_slider_val,10);
      var carbohydrates_slider_val = $("#user-carbohydrates").val();
      var carbohydrates_slider = parseInt(carbohydrates_slider_val,10);
      if (fat_slider != -1 || carbohydrates_slider != -1 || fat_slider_val != "" || carbohydrates_slider_val != "") {
        if (fat_slider != -1 && carbohydrates_slider != -1 && fat_slider_val != "" && carbohydrates_slider_val != "") {
          var protein_specify = 100 - (fat_slider+carbohydrates_slider);
        } else if (carbohydrates_slider != -1 && carbohydrates_slider_val != "" && (fat_slider == -1 || fat_slider_val == "")) {
          if (carbohydrates_slider + 30 > 90) {
            var protein_specify = 90 - carbohydrates_slider;
          } else {
            var protein_specify = 30;
          }
        } else if (fat_slider != -1 && fat_slider_val != "" && (carbohydrates_slider == -1 || carbohydrates_slider_val == "")) {
          if (fat_slider + 30 > 90) {
            var protein_specify = 90 - fat_slider;
          } else {
            var protein_specify = 30;
          }
        } else {
          var protein_specify = 30;
        }
      } else {
        var protein_specify = 30;
      }      
      $("#user-protein").val(protein_specify);
      $("#protein-list-show").text(protein_specify)
      submitMacronutrient();
    } else {
      $("#user-protein-slider-container").addClass("hidden");
      $("#user-protein").attr("min",-1);
      $("#user-protein").val(-1);
      submitMacronutrient();
    }
  });

  if ($(".user-profile-update-settings").length > 0) {
    $("#user-profile-settings-message").removeClass("hidden");
  }

  $(document).on("click", '.hide-comments', function(event) { 
    $(this).hide();
    $(this).parentsUntil(".post-li").parent().find(".post-comments-container").slideUp();
    $(this).parentsUntil(".post-li").parent().find(".show-comments").show();
   // $('html, body').animate({scrollTop: $(this).parentsUntil(".post-li").parent().offset().top - 15});  

  });
  $(document).on("click", '.show-comments', function(event) { 
    $(this).hide();
    $(this).parentsUntil(".post-li").parent().find(".hide-comments").show()
    $(this).parentsUntil(".post-li").parent().find(".post-comments-container").slideDown();  
    var wHeight = $(window).height(); // Height of view port
    var eOffset = $(this).parentsUntil(".post-li").parent().find(".comment-submit").offset().top; // Y-offset of element
    var eHeight = $(this).parentsUntil(".post-li").parent().find(".comment-submit").height(); // Height of element
    $('html, body').animate({scrollTop: eOffset - wHeight + eHeight +180});  
  });
  $(document).on("click", '.scroll-to-comments', function(event) { 
    $(this).parentsUntil(".post-li").parent().find(".show-comments").first().click();
  });



  $(document).on("click", '.show-add-block', function(event) { 
    //$(this).slideUp(500);
    $(this).addClass("hidden");
    if($("#add-block").is(':hidden')){
      $("#add-block").show();
     // $('.fixed-bottom-bar').addClass('hidden');
    }
    $('html, body').animate({scrollTop: $("#add-block").offset().top});
  });
  $(document).on("click", '#write-a-dish', function(event) { 
    //$(this).slideUp(500);
    setTimeout(function () {
      $('.fixed-bottom-bar').hide();
    }, 800);
    $('html, body').animate({scrollTop: $("#dishes-container").offset().top});
    
  });



  $(document).on("click", '#instagram-dish-click', function(event) { 
    $("#instagram-dish-block").show();
    $("#original-dish-block").hide();
    $("#url").focus();
    $('.fixed-bottom-bar').hide();
    $('html, body').animate({scrollTop: $("#instagram-dish-block").offset().top});
  });

  $(document).on("click", '#original-dish-click', function(event) { 
    $("#instagram-dish-block").hide()
    $("#original-dish-block").show();
    $("#new-dish-title").focus();
    $('.fixed-bottom-bar').hide();
    $('html, body').animate({scrollTop: $("#original-dish-block").offset().top});
  });



  $(document).on("click", '.close-add-food-box', function(event) { 
    $("#add-block").slideUp(500);
    $(".search-box-container").addClass("hidden");
    $(".show-add-block").removeClass("hidden");
    $('.fixed-bottom-bar').removeClass('hidden');
  });

  $(document).on("click", '#browse-from-home', function(event) {
    if ($(".browse-show").hasClass("hidden")) {
      $(".browse-show").removeClass("hidden");
    } else {
      $(".browse-show").addClass("hidden");
    }
    
  });



  $('#notifications-dropdown').click(function() {
      // Only call notifications when opening the dropdown
      if(!$(this).hasClass('open')) {
         $.ajax({
            type: "GET",
            url: "/see_notifications",
            async: false,
            dataType: "script"
         });
      }
  });


  $( document ).on( 'keyup', "#home-search", function(event) {
    if(event.keyCode == 13) {
      $(".home-no-results").hide();
      $("#home-search-results").prepend("<div class='col-md-12 text-center home-thinking' style='margin-top:30px;'>Thinking.</div>");
      $('html, body').animate({scrollTop: $("#home-search").offset().top - 15});
    }
  });


  $(function () {
    $('[data-toggle="popover"]').popover()
  })


  $("#next-from-basic-demographic").click(function() {
    $("#basic-demographic").addClass("hidden");
    $("#dietary-restrictions-div").removeClass("hidden");
  });
  $("#next-from-dietary-restrictions-div").click(function() {
    $("#dietary-restrictions-div").addClass("hidden");
    $("#list-defaults-div").removeClass("hidden");
  });

  $("#next-from-list-defaults-div").click(function() {
    $("#list-defaults-div").addClass("hidden");
    $("#micronutrients-div").removeClass("hidden");
  });
  $("#next-from-micronutrients-div").click(function() {
    $("#micronutrients-div").addClass("hidden");
    $("#macronutrients-label").removeClass("hidden");
    $("#user-onboard").val("Z");
  });
  $("#next-from-macronutrients-label").click(function() {
    $("#user-profile-view-favorites").addClass("hidden");
    $("#onboarded-user").removeClass("hidden");
    $(".nav").show()
  });





}
$.fn.imageLoad = function(fn){
    this.load(fn);
    this.each( function() {
        if ( this.complete && this.naturalWidth !== 0 ) {
            $(this).trigger('load');
        }
    });
}
$( document ).ready(function() {
  $(".init-opacity-zero").css("opacity",1);
  if ($("#dishes-container").length > 0) {
    if ($(this).scrollTop() > $("#below-list-standard").offset().top) { //use `this`, not `document`
      $('.fixed-bottom-bar').fadeOut();
    } else {
      if ($("#show-fixed-bottom-bar").hasClass("hidden")) {
        $('.fixed-bottom-bar').fadeIn();
      }
    }
  }

  $(".detailed-nutrition").addClass("hidden");
  $('img.dish-image').imageLoad(function(){
    var image_height = parseInt($(this).css("height"),10);
    var image_width = parseInt($(this).css("width"),10);
    if (image_height > image_width) {
      $(this).css("width","100px");
      var margin_top_num = -(parseInt($(this).css("height"),10)-100)/2
      var margin_top = String(margin_top_num)+"px";
      $(this).css("margin-top",margin_top);

    } else {
      $(this).css("height","100px");
      var margin_left_num = -(parseInt($(this).css("width"),10)-100)/2
      var margin_left = String(margin_left_num)+"px";
      $(this).css("margin-left",margin_left);
    }
  });
  docReady();
  if ($("#home-fun").length == 0) {
    $("#list-title-edit").parent().parent().css("width","100%");
  }
  $("#list-title-edit").parent().css("max-width","");
  if ($("#edit-person-sex").length > 0) {
    var sex = $("#edit-person-sex").html();
    var activity_level = $("#edit-person-activity-level").html();
    $("#add-person-sex").val(sex);
    $("#add-person-activity-level").val(activity_level);
  }
  $("#edit-person-sex").remove();
  $(".notice").css("margin","0px");
});

$( window ).load(function() {
  $(".dish-image").each(function(i, obj) {
    var image_height = parseInt($(this).css("height"),10);
    var image_width = parseInt($(this).css("width"),10);
    if (image_height > image_width) {
      $(this).css("width","100px");
      var margin_top_num = -(parseInt($(this).css("height"),10)-100)/2
      var margin_top = String(margin_top_num)+"px";
      $(this).css("margin-top",margin_top);

    } else {
      $(this).css("height","100px");
      var margin_left_num = -(parseInt($(this).css("width"),10)-100)/2
      var margin_left = String(margin_left_num)+"px";
      $(this).css("margin-left",margin_left);
    }
  });
});

var scrollTimeout = null;
$(window).scroll(function(){
    if ($("#dishes-container").length > 0 && $("#hide-edit-list-parameters-link").hasClass("hidden") && !$("#search").is(":focus")) {
      if (scrollTimeout) clearTimeout(scrollTimeout);
      scrollTimeout = setTimeout(function(){


        if ($(this).scrollTop() > $("#below-list-standard").offset().top) { //use `this`, not `document`
          if ($("#show-fixed-bottom-bar").hasClass("hidden")) {

            $('.fixed-bottom-bar').hide();
          } else {
            $("#show-fixed-bottom-bar").hide();
          }

        } else {
          if ($(".search-results-container").hasClass("hidden")) {
            if ($("#show-fixed-bottom-bar").hasClass("hidden")) {
              $('.fixed-bottom-bar').show();
            } else {
              $("#show-fixed-bottom-bar").show();
            }
          }
        }
      },200); 
    }
});



updateHeight();
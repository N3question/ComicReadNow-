// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import "jquery";
import "popper.js";
import "bootstrap";
import "../stylesheets/application" 
import '@fortawesome/fontawesome-free/js/all'
import '../stylesheets/humberger'

(function() {
  ('#back a').on('click',function(event){
    ('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});


(function(){
  ("#send").on("click", function(event){
    let id = ("#main").val();
    ajax({
      // type: "POST",
      // url: "techacademy.php",
      // data: { "id" : id },
      // dataType : "json"
    }).done(function(data){
      $("#return").append('<p>'+data.id+' : '+data.school+' : '+data.skill+'</p>');
    }).fail(function(XMLHttpRequest, status, e){
      alert(e);
    });
  });
});



Rails.start()
Turbolinks.start()
ActiveStorage.start()

$(document).on('turbolinks:load',function(){
  $(".openbtn").click(function () {
      $(this).toggleClass('active');
  })
});
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

(function() {
  ('#back a').on('click',function(event){
    ('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});



//= require jquery
//= require jquery_ujs

//= require jquery
require("@rails/ujs").start()
// require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

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
// Rails 5?6?はSCSSのフォルダをassets配下からjsの配下でも可能になった関係で一緒にimportを書いている。
// spロケッツ...assets旧式
// webpacker...新型
// Rails 7からはまた使わなくなる（railsガイドなど参考にする）
import "../stylesheets/application" 
import '@fortawesome/fontawesome-free/js/all'
import '../stylesheets/humberger'
// import './uploader'

(function() {
  ('#back a').on('click',function(event){
    ('body, html').animate({
      scrollTop:0
    }, 800);
    event.preventDefault();
  });
});


Rails.start()
Turbolinks.start()
ActiveStorage.start()

// jquery objuect = $（）
$(document).on('turbolinks:load',function(){
  $(".openbtn").click(function () {
      $(this).toggleClass('active');
  });
});
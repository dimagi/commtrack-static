var CarouselControl = function (options) {
  'use strict';
  var self = this;
  self.start = options.start;
  self.sections = options.sections;
  
  self.init = function () {
    var History = window.History;
    if (!History.enabled) return false;
    
    var State = History.getState();
  	if (State.data.state) {
  	  self.start = State.data.state;
  	}
  
    $('.cchq-subnav li > a').bind('click', function(e) {
      e.preventDefault();
      
    	var order = $(this).data('order'); 
    	var section = self.sections[order-1];
    	
      History.pushState({state:section.order}, section.title, section.url);
      return false;
    
    });
    
    self.setNavState(self.start);
        
    $("#carousel").jcarousel({
      scroll: 1,
      start: self.start,
      buttonNextHTML: null,
      buttonPrevHTML: null,
    });
    
    History.Adapter.bind(window,'statechange',function(){ 
        var State = History.getState();
        self.setNavState(State.data.state);
        var carousel = $('#carousel').data('jcarousel');    
        carousel.scroll(jQuery.jcarousel.intval(State.data.state));
    });
    
  };
  
  self.setNavState = function (ind) {
    var slug = self.sections[ind-1].slug;
    $('.cchq-subnav li').removeClass('selected');
    $('#nav-'+slug).addClass('selected');
  };
  
};


function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var itineraryFormInputStart = document.getElementById('itinerary_start_point');
    var itineraryFormInputEnd = document.getElementById('itinerary_end_point');

    if (itineraryFormInputStart) {
      var autocomplete = new google.maps.places.Autocomplete(itineraryFormInputStart, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(itineraryFormInputStart, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }

    if (itineraryFormInputEnd) {
      var autocomplete = new google.maps.places.Autocomplete(itineraryFormInputEnd, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(itineraryFormInputEnd, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }

  });
}

export { autocomplete };

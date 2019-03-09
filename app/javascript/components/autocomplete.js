function autocomplete() {
  document.addEventListener("DOMContentLoaded", function() {
    var itineraryFormInput = document.getElementById('itinerary_start_point');
    if (itineraryFormInput) {
      var autocomplete = new google.maps.places.Autocomplete(itineraryFormInput, { types: [ 'geocode' ] });
      google.maps.event.addDomListener(itineraryFormInput, 'keydown', function(e) {
        if (e.key === "Enter") {
          e.preventDefault(); // Do not submit the form on Enter.
        }
      });
    }
  });
}

export { autocomplete };

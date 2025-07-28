
$(function () {
  // Slide animation handlers
  $("#RightToLeft").click(function () {
    $("#slide").animate({ marginLeft: "0" });
    $(".top").animate({ marginLeft: "100%" });
  });

  $("#LeftToRight").click(function () {
    $("#slide").animate({ marginLeft: "50%" });
    $(".top").animate({ marginLeft: "0" });
  });

  // Common addToCart function example
  window.addToCart = function(idx) {
    fetch('add-prod-servlet', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'idx=' + idx
    })
    .then(response => response.json())
    .then(data => {
      $("#cart-count").text(data.count);
    })
    .catch(error => console.error('Add to cart failed:', error));
  };
});
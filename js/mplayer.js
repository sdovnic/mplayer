jQuery(document).ready(function($) {
	$("a").click(function(event) {
		event.preventDefault();
		var windowheight = $(window).height();
		$("#splash").css({
			"position": "relative",
			"height": windowheight + "px"
		});
		$("#download").css({
			"position": "relative",
			"min-height": windowheight + "px"
		}).show(0, function() {
			$("body, html").animate({
				scrollTop: windowheight
			}, 600);
		});
		window.location = $("a").attr("href");
	});
});
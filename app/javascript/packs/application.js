// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "@popperjs/core"
import "bootstrap"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

(function($) {
	$(".sortable").sortable({
		containerSelector: "ul.sortable",
		itemSelector: "li.sort",
		handle: ".handle",
		placeholder:
			'<li><div class="card bg-primary text-white mb-1"><div class="card-header">Drop Here</div></div></li>',
		distance: 0,
		onDrop: function($item) {
			$item.attr("style", null).removeClass("dragged");
			$("body").removeClass("dragging");
		}
	});
})(jQuery);
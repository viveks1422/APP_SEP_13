# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	$('.bootstrap-datepicker').datepicker()
	$('#timepicker1').timepicker()
	$('#event_timings').on 'cocoon:before-insert', (e, insertedItem) ->
		insertedItem.fadeIn('slow')
		$('#removeBtn').removeClass("hide").fadeIn('slow')
	$('#event_timings').on 'cocoon:after-insert', (e, insertedItem) ->
	  	dateField = insertedItem.find(".bootstrap-datepicker")
	  	timeField = insertedItem.find("#timepicker1")
	  	dateField.datepicker()
	  	timeField.timepicker()
	$('#event_timings').on 'cocoon:before-remove', (e, item) ->
		$(this).data('remove-timeout', 1000)
		item.fadeOut('slow')
	$('#eventTable').dataTable
		"aoColumnDefs": [{"aTargets": [ 3 ], "bSortable": false}]
		"sPaginationType": "bs_normal"
		"sDom": "<'row'<'col-sm-12'<'pull-right'i><'pull-left'f>r<'clearfix'>>>t<'row'<'col-sm-12'<'pull-left'l><'pull-right'p><'clearfix'>>>"
		"oLanguage": {"sLengthMenu": "Show _MENU_ events"}
	$('#eventTable_filter > label > input').addClass('form-control filterMove')
	$('#eventtype > label.btn-primary').click ->
		eventtype = $(this).attr("for")
		$("#"+$(this).attr("for")).prop("checked",true)
		if(eventtype == "single")
			$('#event_timings').removeClass("hide")
			$('#addBtn').addClass("hide")
			$('#removeBtn').addClass("hide")
			$('#price').html("The last step is a <strong>$0.99</strong> payment to list your event on Birmingham Events.")
		else
			$('#event_timings').removeClass("hide")
			$('#addBtn').removeClass("hide")
			$('#removeBtn').removeClass("hide")
			$('#price').html("The last step is a <strong>$4.99</stong> payment to list your event on Birmingham Events.")
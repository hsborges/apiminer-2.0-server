/**
 * 
 */


// APIMiner cookie name
var cookieName = "apiminer2-cookie";


// APIMiner URLs - For a particular instance
var apiminer_server_url = "http://localhost:8080/server";
var dialog_url = apiminer_server_url + "/model/dialog";
var example_url = apiminer_server_url + "/service/example";
var recommendation_url = apiminer_server_url + "/service/recommendation/example";
var evaluation_url = apiminer_server_url + "/service/evaluation";
var full_code_url = apiminer_server_url + "/service/fullcode";
var examples_counter_url = apiminer_server_url + "/service/counter/examples";

// Obtain the dialog windown in apiminer webserver
function get_dialog() {
	if (document.getElementById("apiminer_example_dialog") == null) {
		jQuery.get(
				dialog_url,
				function(data){
					$("body").append(data);
				}
		).done(function() {
			$("#apiminer_example_dialog").hide();
			$("#apiminer_example_dialog")
				.dialog({
					autoOpen: false,
					modal:true, 
					minWidth: 900,
					maxWidth: 900,
					maxHeight: 700, 
					resizable: false,
					draggable: false,
					position: "top",
					open: function(event, ui) {
						$("body").css({ overflow: 'hidden' });
					},
					beforeClose: function(event, ui) {
						$("body").css({ overflow: 'inherit' });
					}
				});
		});
	}
}

// fully the form with the example data
function populate(api_method_name, example_index, rec) {
	$("#apiminer_example_dialog").dialog('open');
	
	$("#apiminer_example_holder").hide();
	$("#apiminer_loading_example").show();
	
	if (api_method_name != null && rec == null) {
		jQuery.get(
				example_url,
				{methodSignature: api_method_name, position:example_index},
				function (data) {
					var obj = jQuery.parseJSON(data);
					
					$("#apiminer_apimethod").val(api_method_name);
					$("#apiminer_example_dialog").attr("title",api_method_name);
					$("#apiminer_example_project").text(obj.project);
					$("#apiminer_example_file a").text(obj.file);
					$("#apiminer_example_file a").attr({href: full_code_url + "/" + obj.attachment_id});
					$("#apiminer_attachment_id").val(obj.attachment_id);
					
					$("#apiminer_example_place span").hide();
					$("#apiminer_example_place pre").html(obj.example.substring(1, obj.example.length - 1).split("\n\t").join("\n"));
					$("#apiminer_example_id").val(obj.example_id);
					
					$("#apiminer_example_list").html("");
					for (var i = 0; i < obj.num_examples; i++) {
						opt = $("<option>").attr({value:i}).html(i+1);
						opt.appendTo("#apiminer_example_list");
						if (i == example_index) {
							opt.prop('selected', true);
						}
					}
					
					if (obj.associations.length > 0) {
						$("#apiminer_associations_place").show();
						$("#apiminer_associations_form").html("");
						for (var i = 0; i < obj.associations.length; i++) {
						    $("<input>").attr({
						    	type: "radio",
						    	name: "rec",
						    	value:obj.associations[i].associatedElementsId,
						    	onclick:"recommendations_filtering(this);",
						    }).appendTo("#apiminer_associations_form");
						    $("<span>").html(obj.associations[i].associatedElements.join(' + ')).appendTo("#apiminer_associations_form");
						    $("<br>").appendTo("#apiminer_associations_form");
						}
					} else {
						$("#apiminer_associations_place").hide();
					}
				}
		).done(function() {
			SyntaxHighlighter.highlight();
			$("#apiminer_loading_example").hide();
			$("#apiminer_example_holder").show();
		}).fail(function(){
			console.log("Problema na obtencao do exemplo.");
			alert("TODO!");
		});
	} else {
		jQuery.get(
				recommendation_url,
				{associatedElementsId: rec, position:example_index},
				function (data) {
					var obj = jQuery.parseJSON(data);
					
					$("#apiminer_example_project").text(obj.project);
					$("#apiminer_example_file a").text(obj.file);
					$("#apiminer_example_file a").attr({href: full_code_url + "/" + obj.attachment_id});
					$("#apiminer_attachment_id").val(obj.attachment_id);
					
					$("#apiminer_example_place span").hide();
					$("#apiminer_example_place pre").html(obj.example.substring(1, obj.example.length - 1).split("\n\t").join("\n"));
					$("#apiminer_example_id").val(obj.example_id);
					
					$("#apiminer_example_list").html("");
					for (var i = 0; i < obj.num_examples; i++) {
						opt = $("<option>").attr({value:i}).html(i+1);
						opt.appendTo("#apiminer_example_list");
						if (i == example_index) {
							opt.prop('selected', true);
						}
					}
				}
		).done(function(){
			SyntaxHighlighter.highlight();
			$("#apiminer_loading_example").hide();
			$("#apiminer_example_holder").show();
		}).fail(function(){
			console.log("Problema na obtencao do exemplo.");
			alert("TODO!");
		});
	}
	
}

// change the example by selecting directly the index
function change_example_by_select() {
	var rec = $( "#apiminer_associations_form input:checked" ).val();
	var e = document.getElementById("apiminer_example_list");
	var index = e.options[e.selectedIndex].value;
	
	if (rec == null) {
		populate(document.getElementById('apiminer_apimethod').value, index, null);
	} else {
		populate(null, index, rec);
	}
}

// change the example by clicking on next button
function prev() {
	var rec = $( "#apiminer_associations_form input:checked" ).val();
	var e = document.getElementById("apiminer_example_list");
	
	var index = e.options[e.selectedIndex].value;
	if (index == 0) {
		index = --e.options.length;
	} else {
		--index; 
	}
	
	if (rec == null) {
		populate(document.getElementById('apiminer_apimethod').value, index, null);
	} else {
		populate(null, index, rec);
	}
}

// change the example by clicking on previous button
function next() {
	var rec = $( "#apiminer_associations_form input:checked" ).val();
	var e = document.getElementById("apiminer_example_list");
	var index = e.options[e.selectedIndex].value;
	
	if (rec == null) {
		populate(document.getElementById('apiminer_apimethod').value, ++index % e.options.length, null);	
	} else {
		populate(null, ++index % e.options.length, $( "#apiminer_associations_form input:checked" ).val());
	}
}

// filter the examples to an usage patterns recommendation 
function recommendations_filtering(caller){
	populate(null, 0, caller.value);
}

// clear the usage pattern recommendation filter 
function clear_recommendations_filtering(){
	$( "#apiminer_associations_form input:checked" ).prop('checked', false);
	populate(document.getElementById('apiminer_apimethod').value, 0, null);
}

// example evaluation
function rate(evaluation) {
	var methodName = document.getElementById('apiminer_example_id').value;
	var c = getCookie(cookieName).split("|");
	for (var i = 0; i < c.length; i++) {
		if (c[i].trim() == methodName.trim()) {
			alert("You already evaluated this example!");
			return;
		}
	}
	
	jQuery.post(
			evaluation_url,
			{
				apiMethodName: document.getElementById('apiminer_apimethod').value, 
				associatedElementsId: $( "#apiminer_associations_form input:checked" ).val(),
				exampleIndex: document.getElementById("apiminer_example_list").options[document.getElementById("apiminer_example_list").selectedIndex].value,
				exampleId: $("#apiminer_example_id").val(),
				evaluation: evaluation
			}
	);
	createCookie(cookieName, getCookie(cookieName) + "|" + methodName, 30);
	alert("Thanks for your evaluation!");
}

// create a cookie
function createCookie(name, value, days) {
    var expires;
    if (days) {
        var date = new Date();
        date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
        expires = "; expires=" + date.toGMTString();
    }
    else {
        expires = "";
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

// get a cookie
function getCookie(c_name) {
    if (document.cookie.length > 0) {
        c_start = document.cookie.indexOf(c_name + "=");
        if (c_start != -1) {
            c_start = c_start + c_name.length + 1;
            c_end = document.cookie.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = document.cookie.length;
            }
            return unescape(document.cookie.substring(c_start, c_end));
        }
    }
    return "";
}

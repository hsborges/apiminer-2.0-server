/**
 * 
 */


// APIMiner cookie name
var cookieName = "apiminer2-cookie";


// APIMiner URLs - For a particular instance
//var apiminer_server_url = "http://localhost:8080/server";
var apiminer_server_url = "http://apiminer.org";

var dialog_url = apiminer_server_url + "/model/dialog";
var examples_url = apiminer_server_url + "/service/example";
var patterns_list_url = apiminer_server_url + "/service/patterns";
var patterns_url = apiminer_server_url + "/service/patterns/example";
var evaluation_url = apiminer_server_url + "/service/evaluation";
var full_code_url = apiminer_server_url + "/service/examples/fullcode";
var examples_counter_url = apiminer_server_url + "/service/examples/counter";
var btn_click_log_url = apiminer_server_url + "/log/click/button";
var pattern_filter_log_url = apiminer_server_url + "/log/click/filter";
var page_request_log_url = apiminer_server_url + "/log/page";
var patterns_list_click_log_url = apiminer_server_url + "/log/click/patternslist";

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
					position: "middle",
					modal:true, 
					minWidth: 1000,
					maxHeight: 700, 
					resizable: false,
					draggable: true,
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

function btnClick(api_method_id) {
	jQuery.post(btn_click_log_url, {methodId: api_method_id});
}

function patternFilter(rec) {
	jQuery.post(pattern_filter_log_url, {patternId: rec});
}

function patternsListClick(patternId) {
	jQuery.post(patterns_list_click_log_url, {patternId: patternId});
}

// fully the form with the example data
function populate(api_method_id, example_index, rec) {
	console.log("Populating the dialog ... ");
	
	$("#apiminer_example_dialog").dialog('open');
	
	$("#apiminer_example_holder").hide();
	$("#apiminer_loading_example").show();
	
	if (api_method_id != null && rec == null) {
		jQuery.get(
				examples_url,
				{methodId: api_method_id, position:example_index},
				function (data) {
					var obj = jQuery.parseJSON(data);
					
					$("#apiminer_apimethod").val(api_method_id);
					
					$("#apiminer_example_project").text(obj.project);
					$("#apiminer_example_file a").text(obj.file);
					$("#apiminer_example_file a").attr({href: full_code_url + "?attachmentId=" + obj.attachment_id});
					$("#apiminer_attachment_id").val(obj.attachment_id);
					
					$("#apiminer_example_place span").hide();
					$("#apiminer_example_place_code").show();
					
					var example = obj.example.substring(1, obj.example.length - 1).split("\n\t").join("\n");

					var lines = new Array();
					var rows = example.split('\n');
					for (var row = 0; row < rows.length; row++) {
						for (var seed = 0; seed < obj.seeds.length; seed++) {
							var tl = rows[row].split(' ').join('');
							var ta = obj.seeds[seed].split('\n');
							var ts = ta[0].split(' ').join('');
							
							if (tl.indexOf(ts) > -1) {
								for (var i = 0; i < ta.length; i++) {
									lines.push(i + row);
								}
							}
						}
					}
					
					var code = $("<pre></pre>")
						.addClass("brush: java; highlight: [" + lines + "];")
						.html(example);
					
					$("#apiminer_example_place_code").html(code);
					$("#apiminer_example_id").val(obj.example_id);
					
					$("#apiminer_example_list").html("");
					for (var i = 0; (i < obj.num_examples && i < 20); i++) {
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
			SyntaxHighlighter.defaults['gutter'] = false;
			SyntaxHighlighter.defaults['toolbar'] = false;
			SyntaxHighlighter.highlight();
			$("#apiminer_loading_example").hide();
			$("#apiminer_example_holder").show();
		}).fail(function(){
			$("#apiminer_example_place span").show();
			$("#apiminer_example_place_code").hide();
			console.log("Problema na obtencao do exemplo.");
		});
	} else {
		jQuery.get(
				patterns_url,
				{associatedElementsId: rec, position:example_index},
				function (data) {
					var obj = jQuery.parseJSON(data);
					
					$("#apiminer_example_project").text(obj.project);
					$("#apiminer_example_file a").text(obj.file);
					$("#apiminer_example_file a").attr({href: full_code_url + "?attachmentId=" + obj.attachment_id});
					$("#apiminer_attachment_id").val(obj.attachment_id);
					
					$("#apiminer_example_place span").hide();
					$("#apiminer_example_place_code").show();
					
					var example = obj.example.substring(1, obj.example.length - 1).split("\n\t").join("\n");

					var lines = new Array();
					var rows = example.split('\n');
					for (var row = 0; row < rows.length; row++) {
						for (var seed = 0; seed < obj.seeds.length; seed++) {
							var tl = rows[row].split(' ').join('');
							var ta = obj.seeds[seed].split('\n');
							var ts = ta[0].split(' ').join('');
							
							if (tl.indexOf(ts) > -1) {
								for (var i = 0; i < ta.length; i++) {
									lines.push(i + row);
								}
							}
						}
					}
					
					var code = $("<pre></pre>")
						.addClass("brush: java; highlight: [" + lines + "];")
						.html(example);
					
					$("#apiminer_example_place_code").html(code);
					$("#apiminer_example_id").val(obj.example_id);
					
					$("#apiminer_example_list").html("");
					for (var i = 0; i < obj.num_examples; i++) {
						if (i >= 20) break;
						opt = $("<option>").attr({value:i}).html(i+1);
						opt.appendTo("#apiminer_example_list");
						if (i == example_index) {
							opt.prop('selected', true);
						}
					}
				}
		).done(function(){
			SyntaxHighlighter.defaults['gutter'] = false;
			SyntaxHighlighter.defaults['toolbar'] = false;
			SyntaxHighlighter.highlight();
			$("#apiminer_loading_example").hide();
			$("#apiminer_example_holder").show();
		}).fail(function(){
			$("#apiminer_example_place span").show();
			$("#apiminer_example_place_code").hide();
			console.log("Problema na obtencao do exemplo.");
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
	patternFilter(caller.value);
}

// clear the usage pattern recommendation filter 
function clear_recommendations_filtering(){
	console.log("Filtering the examples with the selected usage pattern");
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
				apiMethodId: document.getElementById('apiminer_apimethod').value, 
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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<style type="text/css">
	#apiminer_example_dialog > .ui-dialog-titlebar {
		font-size: 16px;
	}
	
	#apiminer_navigation_menu, .ui-dialog-titlebar {
		max-height: 25px;
	}
	
	#apiminer_example_dialog > button {
		height: 50px;
	}

	#apiminer_dialog_footer {
		font-size: 14px;
		text-align: center;
	}
	
	#apiminer_example_holder, #apiminer_loading_example, 
	#apiminer_example_place, #apiminer_associations_place {
		font-size: 14px;
		border: 1px solid rgb(170, 170, 170);
		border-top-right-radius: 4px;
		border-top-left-radius: 4px;
		border-bottom-right-radius: 4px;
		border-bottom-right-radius: 4px;
	}
	
	#apiminer_example_place, #apiminer_associations_place, 
	#apiminer_dialog_buttons, #apiminer_navigation_menu {
		margin: 1px;
	}
	
	#apiminer_dialog_buttons #next, 
	#apiminer_dialog_buttons #prev,
	#apiminer_example_list {
		float: right;
	}
	
	#apiminer_example_place {
		padding-left: 15px;
		padding-top: 15px;
	}
	
	#apiminer_example_file a {
		text-decoration: none;
		font-weight: bold;
		color: blue;
		outline: none;
	}
	
	#apiminer_associations_form, #apiminer_dialog_buttons {
		padding: 5px;	
	} 
	
	#apiminer_dialog_buttons button {
		height: 2.2em;
	}
	
	#apiminer_navigation_menu {
		vertical-align: middle;
	}
	
</style>
 
<!-- Dialog Box with an API example. -->
<div id="apiminer_example_dialog" class="example_dialog" title="Example">
	<div id="apiminer_loading_example">
		<div id="imageHolder">
			<img id="load_gif"
				src="<c:url value='/resources/images/loading.gif'/>"
				title="Please wait." width="730px" height="374px" align="center" />
		</div>
	</div>

	<div id="apiminer_example_holder" class="content">
		<div id="apiminer_navigation_menu" class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
			<span id="apiminer_example_project"></span> - <span id="apiminer_example_file"><a href="#"></a></span> 
			<select id="apiminer_example_list" onchange="change_example_by_select()">
				<!-- Options -->
			</select>
		</div>
		
		<input id="apiminer_attachment_id" type="hidden" value=""/>
		<input id="apiminer_apimethod" type="hidden" value=""/>
		
		<div id="apiminer_example_place" style="min-height: 150px; max-height: 250px; overflow: auto;">
			<span>No examples for this method.</span>
			<pre class="brush: java; gutter: false; toolbar: false;"></pre>
		</div>

		<div id="apiminer_associations_place">
			<span id="apiminer_associations_form_label" style="font-weight: bold;"> 
				Frequently called with: <a id="apiminer_associations_form_clear" href="#" title="Disable the association." onclick="clear_recommendations_filtering();">[Clear]</a>
			</span> 
			<div id="apiminer_associations_form">
				<!-- inputs -->
			</div>
		</div>
		
		<input id="apiminer_example_id" type="hidden" value=""/>

		<div id="apiminer_dialog_buttons">
			<button onclick="rate(true)" id="rt_Yes" class="rt_button"
				title="This example was useful.">
				<img
					src="http://apiminer.org/static/images/glyphicons_343_thumbs_up.png"
					width="16px" height="14px" /> Like
			</button>
			<button onclick="rate(false)" id="rt_No" class="rt_button"
				title="This example wasn't useful.">
				<img
					src="http://apiminer.org/static/images/glyphicons_344_thumbs_down.png"
					width="16px" height="14px" />
			</button>
			<button id="next" onclick="next();">Next</button>
			<button id="prev" onclick="prev();">Previous</button>
		</div>
	</div>
	
	<div id="apiminer_dialog_footer">
		<span>
			<a href="http://apiminer.org" title="apiminer.org" alt="apiminer.org" style="text-align: center;"> This example was provided by APIMiner.</a> 
		</span>
	</div>
</div>
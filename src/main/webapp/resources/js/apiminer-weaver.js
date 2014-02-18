/**
 *  APIMiner JavaDoc Weaver - JavaDoc documentation generated by javadoc command
 *  
 *  	This script instruments automatically the JavaDoc documentation. 
 *  Basically, it adds the "Example" button in the list of public methods.
 *  
 */

/**
 * Main method.
 */
function instruments() {
	var apiClass = $("ul.inheritance li").last().text();	
	
	jQuery.get(
			examples_counter_url,
			{apiClass: apiClass},
			function(data) {
				var obj = jQuery.parseJSON(data);
				
				$("table.overviewSummary tr").each(function(){
					if ($(this).hasClass("altColor") || $(this).hasClass("rowColor")) {
						var methodName = $(this).find($("td.colLast a"))
							.attr("href")
							.replace(/\.\.\//g, "")
							.replace(".html#","/")
							.replace(/\//g, ".");
						
						var num_examples = obj.methods[methodName];
						
						var ebtn = $("<button></button>").text("Example");
						var espan = $("<span></span>");
						
						if (num_examples != null && num_examples != 0) {
							ebtn.click(function() {
								populate(methodName, 0, null);
							});
						} else if (num_examples == null) {
							num_examples = 0;
						}
						
						$(this).prepend($("<td></td>")
								.attr("class","colFirst")
								.attr("style","text-align:center;")
								.append(ebtn)
								.append("<br/>")
								.append(espan));
						
						espan.text(num_examples + " examples");
					} else {
						$(this).prepend($("<th></th>").attr("scope","col").attr("class","colFirst"));
					}
				});
			}
	);
}
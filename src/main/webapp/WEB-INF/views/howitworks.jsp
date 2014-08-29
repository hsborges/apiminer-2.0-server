<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<t:genericpage>

  <jsp:attribute name="head">
	
	<style>
		#sub-menu {
			border: 1px solid lightgrey;
			padding: 0px;
			margin-bottom: 25px;		
		}	
		.nav-pills > li.active > a {
			border-radius: 0px 0px 0px 0px;
			background: -moz-linear-gradient(center top , rgb(65, 65, 65), rgb(33, 33, 33)) repeat scroll 0% 0% transparent;
			font-weight: bold;
		}
		.tab-content {
			min-height: 275px;		
		}
		.tab-content p {
			text-align: justify;
			text-indent: 35px; 	
		}
	</style>
	
  </jsp:attribute>

  <jsp:body>
	
	<div id="body">
	
		<div class="container">
			  
				<div>
					<p>
						 APIMiner platform follows a pipeline architecture with the following modules: 
					</p>
					<table class="table table-bordered">
						<tbody>
							<tr>
								<td style="width: 25%; text-align: center; vertical-align: middle;"><strong>Source Code Analyzer</strong></td>
								<td>This module analyzes the source code of the API and the client systems to extract structural data</td>
							</tr>
							<tr>
								<td style="width: 25%; text-align: center; vertical-align: middle;"><strong>Patterns Analyzer</strong></td>
								<td>This module extracts usage patterns of the API elements based on their usage by the client systems</td>
							</tr>
							<tr>
								<td style="width: 25%; text-align: center; vertical-align: middle;"><strong>Examples Extractor</strong></td>
								<td>This module extracts the usage examples from the source code of the client systems</td>
							</tr>
							<tr>
								<td style="width: 25%; text-align: center; vertical-align: middle;"><strong>Recommendation Engine</strong></td>
								<td>This module generates the recommendations of the patterns and the usage examples based on data extracted by the previous modules</td>
							</tr>
							<tr>
								<td style="width: 25%; text-align: center; vertical-align: middle;"><strong>JavaDoc Weaver</strong></td>
								<td>This module instruments the documentation of the API to include usage examples</td>
							</tr>
						</tbody>
					</table>			
				</div>
				
				<br />
				
				<div class="text-center">
					<img src="<c:url value="/resources/images/architecture.png"/>" width="95%">
				</div>
				
				
						
		</div>
	
	</div>
	
	<br /><br /><br />
	
	<script type="text/javascript" >
		$( "#menu-works" ).addClass( "active");
	</script>
	
  </jsp:body>
	
</t:genericpage>

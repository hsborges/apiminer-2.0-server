<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<t:genericpage>

  <jsp:attribute name="head">
  
    <style>
		.nav a {
			font-weight: bold;
		}
		#carousel-example-generic .carousel-inner div {
			height: 480px;
		}
		#carousel-example-generic .carousel-inner div img {
			padding-left: 4%;
		}
		#more-info-container p {
			font-size: large;
		}
		#body-configuration{
			padding-top: 25px;
			padding-bottom: 75px;
			background-color: #F2F2F2;		
		}
		.page-header {
			border: 1px solid black;
			text-align: center;		
		}
		#carousel-example-generic .carousel-indicators {
			margin: 0%;
			padding: 0%;
			left: 0%;
			width: 100%;
		}
		#carousel-example-generic .carousel-indicators {
			<!-- background: -moz-linear-gradient(center top , rgb(65, 65, 65), rgb(33, 33, 33)) repeat scroll 0% 0% transparent; -->
		}
		#carousel-example-generic .carousel-indicators li {
			border-color: black;
			font-weight: bolder;
			height: 18px;
			width: 18px;
		}
		#carousel-example-generic .carousel-indicators li.active {
			background: -moz-linear-gradient(center top , rgb(65, 65, 65), rgb(33, 33, 33)) repeat scroll 0% 0% transparent;
		}
		#carousel-example-generic .carousel-inner div {
			min-height: 420px;
		}
		#carousel-example-generic .carousel-inner div p {
			font-weight: bolder;
		}
		#carousel-example-generic .carousel-inner div p span {
			padding-right: 10px;
			padding-left: 10px;
		}
		.carousel-caption {
			color: black;
			font-weight: bold; 
		}
		#prev-control, #next-control {
			background-image: none;
			color: black;
			font-size: xx-large;
			outline:none;	
		}
    </style>
  
  </jsp:attribute>
  
  <jsp:body>
  
  	<div id="body">
	
		<div class="container text-content">
			
			<p align="justify">
				APIMiner 2.0 now provides a version for IDEs, including <a href="http://developer.android.com/sdk/installing/studio.html">Android Studio</a> and 
				<a href="http://developer.android.com/tools/index.html">Android Developer Tools</a> (Eclipse ADT). 
				The JavaDoc pages instrumented by APIMiner include source code examples for many methods from the Android API, including examples for methods that
				are frequently called together.
			</p>
			
			<br />
			
			<div id="carousel-example-generic" class="carousel slide">
				
				<ol class="carousel-indicators">
					<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
					<li data-target="#carousel-example-generic" data-slide-to="1"></li>
					<li data-target="#carousel-example-generic" data-slide-to="2"></li>
					<li data-target="#carousel-example-generic" data-slide-to="3"></li>
					<!-- <li data-target="#carousel-example-generic" data-slide-to="4"></li> -->

				</ol>
				
				<div class="carousel-inner">
					
					<div class="item active">
						<div class="text-center">
							<img src="<c:url value="/resources/images/android-eclipse-apiminer-edited-p1.png"/>" height="380">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
					<div class="item">
						<div class="text-center">
							<br /><br />
							<img src="<c:url value="/resources/images/android-eclipse-apiminer-edited-p2.png"/>"  height="275">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
					<div class="item">
						<div class="text-center">
							<br /><br />
							<img src="<c:url value="/resources/images/android-eclipse-apiminer-edited-p3.png"/>"  height="275">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
					<div class="item">
						<div class="text-center">
							<img src="<c:url value="/resources/images/eclipse-javadoc-recommended-example-edited.png"/>"  height="375">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
				</div>
				
				<!-- Controls -->
				<a id="prev-control" class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
					<span class="glyphicon glyphicon-chevron-left"></span>
				</a>
				
				<a id="next-control" class="right carousel-control" href="#carousel-example-generic" data-slide="next">
					<span class="glyphicon glyphicon-chevron-right"></span>
				</a>
				
			</div>			
						
		</div>
	
	</div>
	
	<div id="body-configuration">
	
		<div class="container text-content">
			
			<div class="page-header">
  				<h2>How to Configure</h2>
			</div>
			
			<ul class="nav nav-pills nav-justified">
				<li class="active">
					<a href="#android-studio-configuration" data-toggle="tab">
						<img src="<c:url value="/resources/images/android-studio-logo.png"/>">
						Android Studio
					</a></li>
				<li>
					<a href="#adt-configuration" data-toggle="tab">
						<img src="<c:url value="/resources/images/eclipse-adt-logo.png"/>">
						Eclipse ADT
					</a>
				</li>
			</ul>			
			
			<br />			
			
			<div class="tab-content">
			
				<div id="android-studio-configuration" class="tab-pane active">
				   <ol>
						<li>Click on menu "File -> Project Structure", or use the shortcut "CTRL + SHIFT + ALT + S", to open the configuration window.</li>
						<li>Select the tab "Documentation Paths".</li>
						<li>Click on "Specify URL" button, indicated by a plus sign and a globe or use the shortcut "ALT + S".</li>
						<li>Enter the following URL: http://java.labsoft.dcc.ufmg.br/apimineride/resources/docs/reference/</li>
						<li>Click "OK" and done!</li>
						<br /><br />
				   </ol>
				</div>
			
				<div id="adt-configuration" class="tab-pane">
				   <ol>
				   	<li>Click with the right button on the project and select the option "Properties"</li>
						<li>In the left menu, select the option "Java Build Path"</li>
						<li>Select the tab "Libraries"</li>
						<li>Search for the jar "android.jar" and expand the options by clicking on the symbol "+"</li>
						<li>Select "Javadoc location: ..." and click on "Edit..."</li>
						<li>Select "Javadoc URL ..." and enter the following URL: http://java.labsoft.dcc.ufmg.br/apimineride/resources/docs/reference/</li>
						<li>Click "Ok" and done!</li>
				   </ol>	
				</div>
			
			</div>

			
		</div>
		
	</div>
	
	<script type="text/javascript" >
		$( "#menu-ide-version" ).addClass( "active");
		$('.carousel').carousel({
  			interval: 3000
		});
	</script>	
  
  </jsp:body>
  
</t:genericpage>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<t:genericpage>

  <jsp:attribute name="head">

	<style>
		.vjs-big-play-button {
			top: 35% !important;
			left: 40% !important;
		}
		
		.centered-block {
		  margin-left: auto !important;
		  margin-right: auto !important;
		}
		
		#body-video {
			padding-top: 25px;
			padding-bottom: 75px;
			background-color: #F2F2F2;
		}
		
		#body-video p {
			font-size: x-large;
			font-weight: 900;
			background: -moz-linear-gradient(center top , rgb(65, 65, 65), rgb(33, 33, 33)) repeat scroll 0% 0% transparent;
			color: white;
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
	
		<div class="container">

			<div id="carousel-example-generic" class="carousel slide">
				
				<ol class="carousel-indicators">
					<li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
					<li data-target="#carousel-example-generic" data-slide-to="1"></li>
					<li data-target="#carousel-example-generic" data-slide-to="2"></li>
				</ol>
				
				<div class="carousel-inner">
					
					<div class="item active">
						<div class="text-center">
							<p>
								<span class="glyphicon glyphicon-hand-right"></span>
								APIMiner automatically instruments Javadoc documentation with examples of usage
								<span class="glyphicon glyphicon-hand-left"></span>
							</p>
							<img src="<c:url value="/resources/images/instrumented-javadoc-m.png"/>" alt="Instrumented JavaDoc">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
					<div class="item">
						<div class="text-center">
							<p>
								<span class="glyphicon glyphicon-hand-right"></span>
								Source code example provided by APIMiner
								<span class="glyphicon glyphicon-hand-left"></span>
							</p>
							<img src="<c:url value="/resources/images/apiminer-dialog.png"/>" alt="Instrumented JavaDoc" height="330">
							<div class="carousel-caption">
								
							</div>
						</div>
					</div>
					
					<div class="item">
						<div class="text-center">
							<p>
								<span class="glyphicon glyphicon-hand-right"></span>
								Source Code example for methods frequently called together.
								<span class="glyphicon glyphicon-hand-left"></span>
							</p>
							<img src="<c:url value="/resources/images/apiminer-dialog-recommendation.png"/>" alt="Instrumented JavaDoc" height="330">
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
	
	<div id="body-video">
		<div class="container">
		
			<table class="centered-block">
			  <tr>
			    <td>
			      <div>
			      	<p style="color: black;">Demo Video</p>
			        	<video id="example_video_1" class="video-js vjs-default-skin"
				  				controls preload="auto" width="700" height="394"
				  				poster="<c:url value="/resources/images/video-poster.png"/>"
				  				data-setup='{"example_option":true}'>
				 			<source src="<c:url value="/resources/videos/apiminer2-v2.mp4"/>" type='video/mp4' />
							<source src="<c:url value="/resources/videos/apiminer2-v2.webm"/>" type='video/webm' />
						</video>
			      </div>
			    </td>
			  </tr>
			</table>
		</div>
	</div>
	
	<script type="text/javascript" >
		$('.carousel').carousel({
  			interval: 7500
		});
	</script>
	
	<script type="text/javascript" >
		$( "#menu-home" ).addClass( "active");
	</script>
	
  </jsp:body>	

</t:genericpage>

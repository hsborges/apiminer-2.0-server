<%@tag description="Overall Page template" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@attribute name="head" fragment="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">

  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
	<meta name="google-site-verification" content="xGBv3fFu2sPMCay3i4ip9_wg9XOBtwaFOLFWKRj_DtY" />

	<meta name="description" content="Documenting APIs with source code examples and usage patterns"/>
	<meta name="keywords" content="APIMiner, examples, documentation, android, ufmg, aserg"/>
	<meta name="author" content="Hudson Silva Borges" />
	
	<title>APIMiner - Documenting APIs with source code examples and usage patterns</title>
	
	<link href="http://vjs.zencdn.net/4.1/video-js.css" rel="stylesheet"/>
	<script src="http://vjs.zencdn.net/4.1/video.js"></script>

    <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css"/>
    
    <link rel="stylesheet" type="text/css" href="<c:url value="/resources/css/apiminer-style.css"/>"></link>

    <script src="//code.jquery.com/jquery-1.10.2.min.js"></script>
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

	<!-- Google analytics -->
	<script>
	  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
	  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
	
	  ga('create', 'UA-40768852-1', 'apiminer.org');
	  ga('send', 'pageview');
	
	</script>
    
    <jsp:invoke fragment="head"/>
  
  </head>
  
  <body>
    
    <div id="header">
		<div id="header1">
			<div class="container">
				<div id="title-content">
					<div>
						<span id="apiminer-title"><a href="http://apiminer.org" >APIMiner</a></span> 	
						<span id="apiminer-summary">Documenting APIs with source code examples</span>
					</div>
				</div>
			</div>		
		</div>
		<div id="menu" data-spy="affix" data-offset-top="85">
			<div class="container">
				<div id="menu-itens">
					<a id="menu-home" href="http://apiminer.org">
						<span class="glyphicon glyphicon-home"></span>
						Home
					</a>
					<a id="menu-works" href="http://apiminer.org/howitworks">
						<span class="glyphicon glyphicon-cog"></span>				
						How it Works
					</a>
					<a href="http://apiminer.org/doc/reference/packages.html" target="_blank">
						<img src="<c:url value="/resources/images/android-icon.png"/>" height="24px" width="24px"> 
						Android APIMiner
					</a>
					<a id="menu-ide-version" href="http://apiminer.org/ideversion">
						<img src="<c:url value="/resources/images/eclipse_logo.png"/>" height="24px" width="24px">
						IDE Version
					</a>
					<a id="menu-info" href="http://apiminer.org/moreinfo">
						<span class="glyphicon glyphicon-plus-sign"></span>
						More Info
					</a>		
				</div>
			</div>
		</div>
	</div>
	
    <jsp:doBody/>
    
    <div id="footer" class="navbar navbar-fixed-bottom">
		<div id="apiminer-version" class="text-center">
			Version Beta 2.2
		</div>
		<div id="social-area" class="pull-right">				
			<div class="pull-right">	
				<!-- Twitter -->
				<a href="https://twitter.com/share" class="twitter-share-button"
				data-url="java.llp2.dcc.ufmg.br/apiminer"
				data-text="Check out APIMiner -- Documenting APIs with source code examples. http://apiminer.org"
				data-via="apiminer">Tweet</a>
				<script>
					!function(d, s, id) {
						var js, fjs = d.getElementsByTagName(s)[0];
						if (!d.getElementById(id)) {
							js = d.createElement(s);
							js.id = id;
							js.src = "//platform.twitter.com/widgets.js";
							fjs.parentNode.insertBefore(js, fjs);
						}
					}(document, "script", "twitter-wjs");
				</script>
			</div>			
			<div class="pull-right" style="padding-right: 25px;">	
				<div class="apiminer_div" id="fb-root"></div>
				<fb:like href="http://apiminer.org/" send="false" layout="button_count" width="35px" show_faces="false"></fb:like>
				<script>
					(function(d, s, id) {
						var js, fjs = d.getElementsByTagName(s)[0];
						if (d.getElementById(id))
							return;
						js = d.createElement(s);
						js.id = id;
						js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
						fjs.parentNode.insertBefore(js, fjs);
					}(document, 'script', 'facebook-jssdk'));
				</script>
			</div>
			<div class="pull-right">
				<!-- Google + -->
				<script type="text/javascript" src="https://apis.google.com/js/plusone.js"></script>
				<div class="g-plusone" data-size="medium" data-href="http://apiminer.org/">
			</div>		
 		</div>			
	</div>
	
  </body>
</html>
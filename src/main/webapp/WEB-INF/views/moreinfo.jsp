<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<t:genericpage>

  <jsp:attribute name="head">
  	
  	<style>
		#body {
			padding-top: 0px;
		}	
	</style>
  
  </jsp:attribute>
  
  <jsp:body>
  	
  	<div id="body">
	
		<div class="container">
			
			<div class="page-header"><h1> About</h1></div>
			<p>
				APIMiner is currently developed and maintained by the <b><a href="http://aserg.labsoft.dcc.ufmg.br/">Applied Software 
				Engineering Research Group (ASERG)</a></b> of the Department of Computer Science, 
				at the Federal University of Minas Gerais.
			</p>
			
			<br />			
			
			<div class="page-header"><h1>Publications</h1></div>			
			<p>
				Joao Eduardo Montandon; Hudson Borges; Daniel Felix; Marco Tulio Valente.
				<A HREF="http://www.dcc.ufmg.br/~mtov/pub/2013_wcre_apiminer.pdf">
				Documenting APIs with Examples: Lessons Learned with the APIMiner Platform.</A>
				20th Working Conference on Reverse Engineering (WCRE), Practice Track, p. 1-8, 2013.
			</p> 
	
			<br />			
			
			<div class="page-header"><h1>Talks</h1></div>
			<p>
				<iframe src="http://www.slideshare.net/slideshow/embed_code/32756850?rel=0" width="597" height="486" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC; border-width:1px 1px 0; margin-bottom:5px; max-width: 100%;" allowfullscreen> </iframe> <div style="margin-bottom:5px"> <strong> <a href="https://www.slideshare.net/hudsonsilbor/final-presentation-32756850" title="Extracting Examples for API Usage Patterns" target="_blank">Extracting Examples for API Usage Patterns</a> </strong> from <strong><a href="http://www.slideshare.net/hudsonsilbor" target="_blank">Hudson Borges</a></strong> </div>
			</p>
			
			<br />
			
			<div class="page-header"><h1>Contact</h1></div>
			<p>
				<a href="http://homepages.dcc.ufmg.br/~joao.montandon/">Joao
					Eduardo Montandon</a>, joao.montandon (at) dcc.ufmg.br
			</p>
			<p>
				<a href="http://homepages.dcc.ufmg.br/~hsborges/">
				Hudson Borges</a>, hsborges (at) dcc.ufmg.br
			</p>
			<p>
				<a href="http://homepages.dcc.ufmg.br/~mtov/">Marco Tulio Valente</a>,
				mtov (at) dcc.ufmg.br
			</p>
			<p>
				<a href="http://homepages.dcc.ufmg.br/~dfelix/">Daniel Carlos Hovadick F&eacute;lix</a>,
				dfelix (at) dcc.ufmg.br
			</p>
						
		</div>
	
	</div>
	
	<br /><br /><br />
	
	<script type="text/javascript" >
		$( "#menu-info" ).addClass( "active");
	</script>
  
  </jsp:body>
  
  
</t:genericpage>
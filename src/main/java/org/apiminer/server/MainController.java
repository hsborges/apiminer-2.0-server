package org.apiminer.server;

import java.io.IOException;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apiminer.entities.Attachment;
import org.apiminer.entities.Log;
import org.apiminer.entities.LogType;
import org.apiminer.entities.api.ApiElement;
import org.apiminer.entities.api.ApiMethod;
import org.apiminer.entities.example.AssociatedElement;
import org.apiminer.entities.example.Example;
import org.apiminer.entities.example.Recommendation;
import org.apiminer.server.exceptions.ExampleNotFoundException;
import org.apiminer.server.exceptions.ResourceNotFound;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;

/**
 * Handles requests for the apiminer 2.0 server.
 */

@Controller
public class MainController {
	
	private final Logger logger = Logger.getLogger(MainController.class);
	
	@PersistenceContext
	private EntityManager em;
	
	@RequestMapping(value = {"/"}, method = RequestMethod.GET)
	public ModelAndView index() {
		return new ModelAndView("index");
	}
	
	@RequestMapping(value = {"/howitworks"}, method = RequestMethod.GET)
	public ModelAndView howItWorks() {
		return new ModelAndView("howitworks");
	}
	
	@RequestMapping(value = {"/ideversion"}, method = RequestMethod.GET)
	public ModelAndView ideVersion() {
		return new ModelAndView("ideversion");
	}
	
	@RequestMapping(value = {"/moreinfo"}, method = RequestMethod.GET)
	public ModelAndView moreInfo() {
		return new ModelAndView("moreinfo");
	}
	
	@RequestMapping(value = {"/model/dialog"}, method = RequestMethod.GET)
	public ModelAndView dialogView() {
		return new ModelAndView("dialog");
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/log/page"}, method = RequestMethod.POST)
	public ResponseEntity<String> pageAccess(@RequestParam(required = true) String page) {
		this.em.persist(Log.createLog(LogType.PAGE_REQUEST).requestedUrl(page));
		return new ResponseEntity<String>(HttpStatus.CREATED);
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/log/click/button"}, method = RequestMethod.POST)
	public ResponseEntity<String> btnClick(@RequestParam(required = true) Long methodId) {
		this.em.persist(Log.createLog(LogType.BTN_EXAMPLE_CLICK).apiMethod(methodId));
		return new ResponseEntity<String>(HttpStatus.CREATED);
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/log/click/filter"}, method = RequestMethod.POST)
	public ResponseEntity<String> patternClick(@RequestParam(required = true) Long patternId) {
		this.em.persist(Log.createLog(LogType.USAGE_PATTERN_FILTER).pattern(patternId));
		return new ResponseEntity<String>(HttpStatus.CREATED);
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/service/example"}, method = RequestMethod.GET)
	public @ResponseBody String dialog(@RequestParam Long methodId, @RequestParam(defaultValue="0") Integer position) {
		Recommendation recommendation = null;
		try {
			recommendation = em.createQuery("SELECT re FROM Recommendation re WHERE :methodId = re.fromElement.id", Recommendation.class)
						.setParameter("methodId", methodId)
						.setMaxResults(1)
						.getSingleResult();
		} catch (NoResultException e) {
			logger.error("Recommendations not found for " + methodId, e);
			throw new ExampleNotFoundException();
		}
		
		int numExamples = em.createQuery("SELECT SIZE(re.elementExamples) FROM Recommendation re WHERE :methodId = re.fromElement.id", Integer.class)
				.setParameter("methodId", methodId)
				.setMaxResults(1)
				.getSingleResult();
		
		if (position >= numExamples) {
			throw new ExampleNotFoundException();
		}
		
		Example example = (Example) em.createNativeQuery("SELECT e.* FROM Recommendation r JOIN Recommendation_Example re ON r.id = ?1 AND re.recommendation_id = r.id AND re.example_index = ?2 JOIN Example e ON e.id = re.example_id", Example.class)
			.setParameter(1, methodId)	
			.setParameter(2, position)
			.setMaxResults(1)
			.getSingleResult();
		
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("num_examples", numExamples);
		jsonObject.addProperty("project", example.getProject().getName());
		jsonObject.addProperty("file", example.getAttachment().getFileName());
		jsonObject.addProperty("attachment_id", example.getAttachment().getId());
		jsonObject.addProperty("example", example.getFormattedCodeExample());
		jsonObject.addProperty("example_id", example.getId());
		
		JsonArray seedsArray = new JsonArray();
		for (String seed : example.getSeeds()) {
			seedsArray.add(new JsonPrimitive(seed));
		}
		jsonObject.add("seeds", seedsArray);
		
		JsonArray jsonArray = new JsonArray();
		
		for (AssociatedElement ae : recommendation.getAssociatedElements()) {
			JsonArray arrayElements = new JsonArray();
			for (ApiElement elements : ae.getElements()) {
				if (elements instanceof ApiMethod) {
					arrayElements.add(new JsonPrimitive(((ApiMethod) elements).getFullName()));
				} else {
					arrayElements.add(new JsonPrimitive(elements.getName()));
				}
			}
			
			JsonObject jsonAssociation = new JsonObject();
			jsonAssociation.addProperty("associatedElementsId", ae.getId());
			jsonAssociation.add("associatedElements", arrayElements);
			
			jsonArray.add(jsonAssociation);
		}
		
		jsonObject.add("associations", jsonArray);
		
		try {
			Log log = Log.createLog(LogType.EXAMPLE_REQUEST)
				.apiMethod(methodId)
				.example(example.getId(), position);
			
			this.em.persist(log);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return jsonObject.toString();
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/service/patterns/example"}, method = RequestMethod.GET)
	public @ResponseBody String dialogRecommendation(@RequestParam(required=true) Long associatedElementsId, @RequestParam(defaultValue="0") Integer position) {
		JsonObject jsonObject = new JsonObject();
		
		AssociatedElement result = null;
		try {
			result = em.createQuery("SELECT ae FROM AssociatedElement ae WHERE ae.id = :asId", AssociatedElement.class)
					.setParameter("asId", associatedElementsId)
					.setMaxResults(1)
					.getSingleResult();
		} catch (NoResultException e) {
			logger.info("Example for usage pattern not found!");
			throw new ExampleNotFoundException();
		} 
		
		if (result != null) {
			Example example = result.getRecommendedExamples().get(position);
			
			jsonObject.addProperty("num_examples", result.getRecommendedExamples().size());
			jsonObject.addProperty("project", example.getProject().getName());
			jsonObject.addProperty("file", example.getAttachment().getFileName());
			jsonObject.addProperty("attachment_id", example.getAttachment().getId());
			jsonObject.addProperty("example", example.getFormattedCodeExample());
			jsonObject.addProperty("example_id", example.getId());
			
			JsonArray seedsArray = new JsonArray();
			for (String seed : example.getSeeds()) {
				seedsArray.add(new JsonPrimitive(seed));
			}
			jsonObject.add("seeds", seedsArray);
			
			try {
				Log log = Log.createLog(LogType.PATTERN_REQUEST)
						.apiMethod(result.getRecommendedAssociations().getFromElement().getId())
						.example(example.getId(), position)
						.pattern(result.getId());
				this.em.persist(log);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return jsonObject.toString();
	}
	
	@Transactional(readOnly=false)
	@RequestMapping(value = {"/service/evaluation"}, method = RequestMethod.POST)
	public ResponseEntity<String> evaluate(@RequestParam(required=true)  Long apiMethodId, 
						@RequestParam(required=false) Long associatedElementsId, 
						@RequestParam(required=true) Integer exampleIndex, 
						@RequestParam(required=true) Long exampleId, 
						@RequestParam(required=true) Boolean evaluation) {
		
		ApiMethod method = null;
		
		try {
			method = em.find(ApiMethod.class, apiMethodId);
		} catch (NoResultException e) {
			logger.info("Method not found!");
			throw new ExampleNotFoundException();
		}
		
		try {
			Log log = Log.createLog(LogType.EXAMPLE_FEEDBACK)
				.apiMethod(method.getId())
				.example(exampleId, exampleIndex)
				.feedback(evaluation)
				.pattern(associatedElementsId);
			
			em.persist(log);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new ResponseEntity<String>(HttpStatus.CREATED);
	}
	
	@Transactional(readOnly = false)
	@RequestMapping(value = {"/service/examples/fullcode"}, method = RequestMethod.GET)
	public void dialogFullCode(@RequestParam(required = true) Long attachmentId, HttpServletResponse response) throws IOException {
		Attachment attachment = em.find(Attachment.class, attachmentId);
		
		if (attachment == null) {
			throw new ResourceNotFound();
		}
		
		response.setContentType("text/java");
        response.setHeader("Content-Disposition","attachment; filename=" + attachment.getFileName());
 
        response.getOutputStream().write(attachment.getContent());
        response.getOutputStream().flush();
        response.getOutputStream().close();
        
    	try {
			em.persist(Log.createLog(LogType.FULL_CODE_REQUEST).attachment(attachmentId));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	@RequestMapping(value = {"/service/examples/counter"}, method = RequestMethod.GET)
	public @ResponseBody String examples(@RequestParam(required=true) String apiClass) {
		List<ApiMethod> methods = em.createQuery("SELECT apm FROM ApiMethod apm JOIN apm.apiClass apc WHERE apc.name = ?1 AND apc.project.clientOf IS NULL", ApiMethod.class)
				.setParameter(1, apiClass.trim())
				.getResultList();
		
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("class_name", apiClass.trim());
		
		JsonObject jsonMethods = new JsonObject();
		for (ApiMethod apm : methods) {
			int recCount = 0;
			try {
				recCount = em.createQuery("SELECT SIZE(r.elementExamples) FROM Recommendation r WHERE r.fromElement = :method", Integer.class)
						.setParameter("method", apm)
						.getSingleResult();
			} catch (NoResultException e) {}
			
			JsonObject data = new JsonObject();
			data.addProperty("method_id", apm.getId());
			data.addProperty("num_examples", recCount);
			
			jsonMethods.add(apm.getFullName(), data);
		}
		
		jsonObject.add("methods", jsonMethods);
		
		return jsonObject.toString();
	}
	
}

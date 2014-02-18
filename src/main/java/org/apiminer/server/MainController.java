package org.apiminer.server;

import java.io.IOException;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.NoResultException;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apiminer.entities.Attachment;
import org.apiminer.entities.Log;
import org.apiminer.entities.LogType;
import org.apiminer.entities.api.ApiClass;
import org.apiminer.entities.api.ApiElement;
import org.apiminer.entities.api.ApiMethod;
import org.apiminer.entities.example.AssociatedElement;
import org.apiminer.entities.example.Example;
import org.apiminer.entities.example.Recommendation;
import org.apiminer.server.exceptions.ExampleNotFoundException;
import org.apiminer.server.exceptions.ResourceNotFound;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
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
	public ModelAndView home() {
		return new ModelAndView("redirect:http://www.apiminer.org");
	}
	
	@RequestMapping(value = {"/status"}, method = RequestMethod.GET)
	public @ResponseBody String status() {
		JsonObject jsonObject = new JsonObject();
		
		Long numExamples = em.createQuery("SELECT COUNT(e) FROM Example e", Long.class)
			.setMaxResults(1)
			.getSingleResult();
		
		jsonObject.addProperty("num_examples", numExamples);
		
		return jsonObject.toString();
	}
	
	@RequestMapping(value = {"/service/example"}, method = RequestMethod.GET)
	public @ResponseBody String dialog(@RequestParam String methodSignature, @RequestParam(defaultValue="0") Integer position) {
		JsonObject jsonObject = new JsonObject();
		
		ApiMethod method = null;
		try {
			method = em.createQuery("SELECT apm FROM ApiMethod apm WHERE apm.fullName = :signature AND apm.apiClass.project.clientOf IS NULL", ApiMethod.class)
				.setParameter("signature", methodSignature)
				.setMaxResults(1)
				.getSingleResult();
		} catch (NoResultException e) {
			logger.error(methodSignature + " not found", e);
			throw new ExampleNotFoundException();
		}
		
		Recommendation recommendation = null;
		try {
			recommendation = em.createQuery("SELECT re FROM Recommendation re WHERE :method = re.fromElement", Recommendation.class)
						.setParameter("method", method)
						.setMaxResults(1)
						.getSingleResult();
		} catch (NoResultException e) {
			logger.error("Recommendations not found for " + methodSignature, e);
			throw new ExampleNotFoundException();
		}
		
		if (position >= recommendation.getElementExamples().size()) {
			logger.info("Example index not found");
			throw new ExampleNotFoundException();
		}

		Example example = recommendation.getElementExamples().get(position);
		
		jsonObject.addProperty("num_examples", recommendation.getElementExamples().size());
		jsonObject.addProperty("project", example.getProject().getName());
		jsonObject.addProperty("file", example.getAttachment().getFileName());
		jsonObject.addProperty("attachment_id", example.getAttachment().getId());
		jsonObject.addProperty("example", example.getFormattedCodeExample());
		jsonObject.addProperty("example_id", example.getId());
		
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
		
		return jsonObject.toString();
	}
	
	@RequestMapping(value = {"/service/recommendation/example"}, method = RequestMethod.GET)
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
		}
		
		
		return jsonObject.toString();
	}
	
	@Transactional(readOnly=false)
	@RequestMapping(value = {"/service/evaluation"}, method = RequestMethod.POST)
	public void evaluate(@RequestParam(required=true)  String apiMethodName, 
						@RequestParam(required=false) Long associatedElementsId, 
						@RequestParam(required=true) Integer exampleIndex, 
						@RequestParam(required=true) Long exampleId, 
						@RequestParam(required=true) Boolean evaluation) {
		
		Long methodId = null;
		
		try {
			methodId = em.createQuery("SELECT apm.id FROM ApiMethod apm WHERE apm.fullName = ?1", Long.class)
				.setParameter(1, apiMethodName)
				.setMaxResults(1)
				.getSingleResult();
		} catch (NoResultException e) {
			logger.info("Method not found!");
			throw new ExampleNotFoundException();
		}
		
		Log log = new Log();
		log.setAddedAt(new Date());
		log.setApiMethodFullName(apiMethodName);
		log.setApiMethodId(methodId);
		log.setExampleId(exampleId);
		log.setExampleIndex(exampleIndex);
		log.setFeedback(evaluation);
		log.setRecommendedSetId(associatedElementsId);
		log.setType(LogType.EXAMPLE_FEEDBACK.name());
		log.setUser("UNKNOWN");
		
		em.persist(log);
	}
	
	@RequestMapping(value = {"/service/fullcode/{attachmentId}"}, method = RequestMethod.GET)
	public void dialogFullCode(@PathVariable Long attachmentId, HttpServletResponse response) throws IOException {
		Attachment attachment = em.find(Attachment.class, attachmentId);
		
		if (attachment == null) {
			throw new ResourceNotFound();
		}
		
		response.setContentType("text/java");
        response.setHeader("Content-Disposition","attachment; filename=" + attachment.getFileName());
 
        response.getOutputStream().write(attachment.getContent());
        response.getOutputStream().flush();
        response.getOutputStream().close();
	}
	
	@RequestMapping(value = {"/service/counter/examples"}, method = RequestMethod.GET)
	public @ResponseBody String examples(@RequestParam(required=true) String apiClass) {
		ApiClass apc = null;
		try {
			apc = em.createQuery("SELECT apc FROM ApiClass apc WHERE apc.name = ?1 AND apc.project.clientOf IS NULL", ApiClass.class)
				.setParameter(1, apiClass.trim())
				.setMaxResults(1)
				.getSingleResult();
		} catch (Exception e) {
			logger.info("Class not found!");
			throw new ExampleNotFoundException();
		}
		
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("class_name", apc.getName());
		
		JsonObject jsonMethods = new JsonObject();
		for (ApiMethod apm : apc.getApiMethods()) {
			jsonMethods.addProperty(apm.getFullName(), em.find(Recommendation.class, apm.getId()).getElementExamples().size());
		}
		
		jsonObject.add("methods", jsonMethods);
		
		return jsonObject.toString();
	}
	
	@RequestMapping(value = {"/model/dialog"}, method = RequestMethod.GET)
	public String dialogView() {
		return "dialog";
	}
	
}

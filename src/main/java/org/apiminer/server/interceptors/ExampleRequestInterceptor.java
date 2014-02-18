package org.apiminer.server.interceptors;

import java.lang.reflect.Method;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apiminer.entities.Log;
import org.apiminer.entities.LogType;
import org.apiminer.entities.api.ApiMethod;
import org.apiminer.entities.example.AssociatedElement;
import org.apiminer.server.HomeController;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class ExampleRequestInterceptor extends HandlerInterceptorAdapter {
	
	@PersistenceContext
	private EntityManager em;
	
	@Override
	@Transactional(readOnly = false)
	public void afterCompletion(HttpServletRequest request,
			HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		if (handler instanceof HandlerMethod) {
			HandlerMethod hm = (HandlerMethod) handler;
			
			Method single = HomeController.class.getMethod("dialog", String.class, Integer.class);
			Method recommendations = HomeController.class.getMethod("dialogRecommendation", Long.class, Integer.class);
			
			if (hm.getMethod().equals(single)) {
				Long apmId = null;
				try {
					apmId = em.createQuery("SELECT apm.id FROM ApiMethod apm WHERE apm.fullName = ?1", Long.class)
						.setParameter(1, request.getParameter("methodSignature"))
						.setMaxResults(1)
						.getSingleResult();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				Log log = new Log();
				
				log.setAddedAt(new Date());
				log.setApiMethodFullName(request.getParameter("methodSignature"));
				log.setApiMethodId(apmId);
				log.setExampleId(null);
				log.setExampleIndex(Integer.parseInt(request.getParameter("position")));
				log.setFeedback(null);
				log.setRecommendedSetId(null);
				log.setType(LogType.GET_EXAMPLE.name());
				log.setUser("UNKNOWN");
				
				em.persist(log);
			} else if(hm.getMethod().equals(recommendations)) {
				AssociatedElement ae = em.find(AssociatedElement.class, Long.parseLong(request.getParameter("associatedElementsId")));
				
				ApiMethod apm = (ApiMethod) ae.getRecommendedAssociations().getFromElement();
				
				Log log = new Log();
				
				log.setAddedAt(new Date());
				log.setApiMethodFullName(apm.getFullName());
				log.setApiMethodId(apm.getId());
				log.setExampleId(null);
				log.setExampleIndex(Integer.parseInt(request.getParameter("position")));
				log.setFeedback(null);
				log.setRecommendedSetId(null);
				log.setType(LogType.GET_RECOMMENDATION.name());
				log.setUser("UNKNOWN");
				
				em.persist(log);
			}
		}
		super.afterCompletion(request, response, handler, ex);
	}

	public EntityManager getEm() {
		return em;
	}

	public void setEm(EntityManager em) {
		this.em = em;
	}
	
	
}

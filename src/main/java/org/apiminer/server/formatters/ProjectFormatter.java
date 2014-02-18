package org.apiminer.server.formatters;

import java.text.SimpleDateFormat;

import org.apiminer.entities.api.Project;

import com.google.gson.JsonObject;

public class ProjectFormatter {
	
	private Project project;

	public ProjectFormatter(Project project) {
		super();
		this.project = project;
	}
	
	public String getJsonFormat(){
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("id", project.getId());
		jsonObject.addProperty("name", project.getName());
		jsonObject.addProperty("summary", project.getSummary());
		jsonObject.addProperty("addedAt", SimpleDateFormat.getDateTimeInstance().format(project.getAddedAt()));
		
		JsonObject object = new JsonObject();
		object.add("api", jsonObject);
		
		return object.toString();
	}

}

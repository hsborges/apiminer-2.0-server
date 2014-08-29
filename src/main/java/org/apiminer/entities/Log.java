package org.apiminer.entities;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@SuppressWarnings("serial")
@Entity
@Table(name = "Log")
public class Log implements Serializable {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(name = "type")
	private String type;
	
	@Column(name = "example_id")
	private Long exampleId;
	
	@Column(name = "example_index")
	private Integer exampleIndex;
	
	@Column(name = "api_method_id")
	private Long apiMethodId;
	
	@Column(name = "feedback")
	private Boolean feedback;
	
	@Column(name = "usage_pattern_id")
	private Long usagePatternId;
	
	@Column(name = "attachment_id")
	private Long attachmentId;
	
	@Column(name = "requested_url")
	private String requestedURL;
	
	@Column(name = "added_at")
	@Temporal(TemporalType.TIMESTAMP)
	private Date addedAt;
	
	private Log() {
		// Singleton
		this.addedAt = new Date(System.currentTimeMillis());
	}
	
	private Log(LogType logType) {
		this();
		this.type = logType.name();
	}
	
	public static Log createLog(LogType logType) {
		return new Log(logType);
	}
	
	public Log example(Long exampleId, Integer index) {
		this.exampleId = exampleId;
		this.exampleIndex = index;
		return this;
	}
	
	public Log apiMethod(Long apiMethodId) {
		this.apiMethodId = apiMethodId;
		return this;
	}
	
	public Log feedback(boolean feedback) {
		this.feedback = feedback;
		return this;
	}
	
	public Log pattern(Long patternId) {
		this.usagePatternId = patternId;
		return this;
	}
	
	public Log attachment(Long attachmentId) {
		this.attachmentId = attachmentId;
		return this;
	}
	
	public Log requestedUrl(String url) {
		this.requestedURL = url;
		return this;
	}
	
}

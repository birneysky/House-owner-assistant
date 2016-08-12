package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_house_comments")
public class HouseComment implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private Integer houseId;		// '房源ID',
	private Integer userId;		// '租客ID',
	private Integer orderId;		// '订单ID',
	private Integer generalScore;		// '0:未评价;1-5:五星级别',
	private Integer positionScore;		// '0:未评价;1-5:五星级别',
	private Integer serviceScore;		// '服务评价 0:未评价;1-5:五星级别',
	private Integer cleanScore;		// '清洁评价 0:未评价;1-5:五星级别',
	private Integer comfortScore;		// '舒适度评价 0:未评价;1-5:五星级别',
	private Integer facilityScore;		// '设施评价 0:未评价;1-5:五星级别',
	private Integer cateringScore;		// '餐饮评价 0:未评价;1-5:五星级别',
	private Integer commentTime;		// 
	private Integer status;		// '状态 0:初始化 1:删除',
	private Integer comments;		// '评价内容',
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Integer getHouseId() {
		return houseId;
	}
	public void setHouseId(Integer houseId) {
		this.houseId = houseId;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Integer getOrderId() {
		return orderId;
	}
	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}
	public Integer getGeneralScore() {
		return generalScore;
	}
	public void setGeneralScore(Integer generalScore) {
		this.generalScore = generalScore;
	}
	public Integer getPositionScore() {
		return positionScore;
	}
	public void setPositionScore(Integer positionScore) {
		this.positionScore = positionScore;
	}
	public Integer getServiceScore() {
		return serviceScore;
	}
	public void setServiceScore(Integer serviceScore) {
		this.serviceScore = serviceScore;
	}
	public Integer getCleanScore() {
		return cleanScore;
	}
	public void setCleanScore(Integer cleanScore) {
		this.cleanScore = cleanScore;
	}
	public Integer getComfortScore() {
		return comfortScore;
	}
	public void setComfortScore(Integer comfortScore) {
		this.comfortScore = comfortScore;
	}
	public Integer getFacilityScore() {
		return facilityScore;
	}
	public void setFacilityScore(Integer facilityScore) {
		this.facilityScore = facilityScore;
	}
	public Integer getCateringScore() {
		return cateringScore;
	}
	public void setCateringScore(Integer cateringScore) {
		this.cateringScore = cateringScore;
	}
	public Integer getCommentTime() {
		return commentTime;
	}
	public void setCommentTime(Integer commentTime) {
		this.commentTime = commentTime;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getComments() {
		return comments;
	}
	public void setComments(Integer comments) {
		this.comments = comments;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public HouseComment() {
	}
	public HouseComment(Integer id, Integer houseId, Integer userId, Integer orderId, Integer generalScore,
			Integer positionScore, Integer serviceScore, Integer cleanScore, Integer comfortScore,
			Integer facilityScore, Integer cateringScore, Integer commentTime, Integer status, Integer comments) {
		super();
		this.id = id;
		this.houseId = houseId;
		this.userId = userId;
		this.orderId = orderId;
		this.generalScore = generalScore;
		this.positionScore = positionScore;
		this.serviceScore = serviceScore;
		this.cleanScore = cleanScore;
		this.comfortScore = comfortScore;
		this.facilityScore = facilityScore;
		this.cateringScore = cateringScore;
		this.commentTime = commentTime;
		this.status = status;
		this.comments = comments;
	}
	
}

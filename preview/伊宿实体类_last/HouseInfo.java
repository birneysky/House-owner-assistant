package com.gotop.house.viewobject;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

@Entity
@Table(name = "view_house_info")
public class HouseInfo implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private Integer landlordId;		//房东ID
	private List<String> houseImages; //图片列表
	private String title;			//房源标题”
	private String headerImage;		//房东头像
	private Float price;  //房间日价
	private Integer cityId;  //房源所属城市
	private Integer commentCount;  //评论数量  count comments
	private Float averageGeneralScore;  //平均的得分  average comments
//	private Integer totalReservation; //总的预定天数  sum from house_order
	private Integer rentType; //出租方式
	private Integer roomNumber; //卧室的数量
	private Integer toliveinNumber; 	//3可住人数
	private Boolean hasConllected; 	//是否收藏

	public HouseInfo() {}

	@Id
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Transient
	public List<String> getHouseImages() {
		return houseImages;
	}

	public void setHouseImage(List<String> houseImages) {
		this.houseImages = houseImages;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@Column(name = "header_image")
	public String getHeaderImage() {
		return headerImage;
	}

	public void setHeaderImage(String headerImage) {
		this.headerImage = headerImage;
	}

	public Float getPrice() {
		return price;
	}

	public void setPrice(Float price) {
		this.price = price;
	}
	@Column(name = "city")
	public Integer getCityId() {
		return cityId;
	}

	public void setCityId(Integer cityId) {
		this.cityId = cityId;
	}

	@Column(name = "comment_count")
	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	@Column(name = "average_general_score")
	public Float getAverageGeneralScore() {
		return averageGeneralScore;
	}

	public void setAverageGeneralScore(Float averageGeneralScore) {
		this.averageGeneralScore = averageGeneralScore;
	}


//	public Integer getTotalReservation() {
//		return totalReservation;
//	}
//
//	public void setTotalReservation(Integer totalReservation) {
//		this.totalReservation = totalReservation;
//	}

	@Column(name = "rent_type")
	public Integer getRentType() {
		return rentType;
	}

	public void setRentType(Integer rentType) {
		this.rentType = rentType;
	}

	@Column(name = "room_number")
	public Integer getRoomNumber() {
		return roomNumber;
	}

	public void setRoomNumber(Integer roomNumber) {
		this.roomNumber = roomNumber;
	}

	@Column(name = "tolivein_number")
	public Integer getToliveinNumber() {
		return toliveinNumber;
	}

	public void setToliveinNumber(Integer toliveinNumber) {
		this.toliveinNumber = toliveinNumber;
	}

	@Transient
	public Boolean getHasConllected() {
		return hasConllected;
	}

	public void setHasConllected(Boolean hasConllected) {
		this.hasConllected = hasConllected;
	}

	@Column(name = "landlord_id")
	public Integer getLandlordId() {
		return landlordId;
	}

	public void setLandlordId(Integer landlordId) {
		this.landlordId = landlordId;
	}
	
	
}

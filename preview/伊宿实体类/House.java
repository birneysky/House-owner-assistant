package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_houses")
public class House implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private Integer landlordId;		// '房东ID',
	private String title;		// '房屋名称',
	private String area;		// '房屋面积',
	private Integer roomNumber;		// '室的数量',
	private Integer hallNumber;		// '厅的数量',
	private Integer kitchenNumber;		// '厨的数量',
	private Integer balconyNumber;		// '阳台的数量',
	private Integer toiletNumber;		// '独立卫生间数量',
	private Integer publicToiletNumber;		// '公共卫生间数量',
	private Integer hasBasement;		// '是否有地下室',
	private Integer toliveinNumber;		// '可住人数',
	private Integer province;		// '省份',
	private Integer city;		// '地市',
	private Integer distict;		// '区县',
	private String address;		// 
	private String houseNumber;		// '门牌号',
	private Float lng;		//'经度',
	private Float lat;		// '纬度',
	private String houseType;		// '房源类型',
	private Integer rentType;		// 
	private String description;		// '描述',
	private String position;		// '地理位置描述',
	private String traffic;		// '交通描述',
	private String surroundings;		// '周边生活',
	private Float price;		// '日价',
	private Integer toForeigner;		// '是否接待境外人士',
	private String checkinTime;		// '入住时间',
	private String checkoutTime;		// '退房时间',
	private String receptionTime;		// '接待时间',
	private Integer atLeastDays;		// 
	private Integer inMostDays;		// 
	private Integer needDeposit;		// '是否需要押金',
	private Float depositAmount;		// '押金金额',
	private Integer thirdCleaning;		// '是否需要第三方保洁？',
	private Integer platformToiletries;		// '平台提供洗漱用品？',
	private Integer platformBedding;		// '平台提供床品？',
	private Integer platformRecommend;		// '平台推荐',
	private Integer adminLock;		// 
	private Integer type7Rate;		// '连住7天折扣率',
	private Integer type3Rate;		// '连住3天折扣率',
	private Integer type15Rate;		// '连住15天折扣率',
	private Integer type30Rate;		// '连住30天折扣率',
	private Integer checkStatus;		// '资料审核状态0 待审核 1 审核待完善  2 审核不通过 3 审核通过',
	private Integer operationStatus;		// '运营状态 0 正常 1 房东下线 2 平台锁定',
	private String remark;		// '备注'
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "landlord_id")
	public Integer getLandlordId() {
		return landlordId;
	}
	public void setLandlordId(Integer landlordId) {
		this.landlordId = landlordId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getArea() {
		return area;
	}
	public void setArea(String area) {
		this.area = area;
	}
	@Column(name = "room_number")
	public Integer getRoomNumber() {
		return roomNumber;
	}
	public void setRoomNumber(Integer roomNumber) {
		this.roomNumber = roomNumber;
	}
	@Column(name = "hall_number")
	public Integer getHallNumber() {
		return hallNumber;
	}
	public void setHallNumber(Integer hallNumber) {
		this.hallNumber = hallNumber;
	}
	@Column(name = "kitchen_number")
	public Integer getKitchenNumber() {
		return kitchenNumber;
	}
	public void setKitchenNumber(Integer kitchenNumber) {
		this.kitchenNumber = kitchenNumber;
	}
	@Column(name = "balcony_number")
	public Integer getBalconyNumber() {
		return balconyNumber;
	}
	public void setBalconyNumber(Integer balconyNumber) {
		this.balconyNumber = balconyNumber;
	}
	@Column(name = "toilet_number")
	public Integer getToiletNumber() {
		return toiletNumber;
	}
	public void setToiletNumber(Integer toiletNumber) {
		this.toiletNumber = toiletNumber;
	}
	@Column(name = "public_toilet_number")
	public Integer getPublicToiletNumber() {
		return publicToiletNumber;
	}
	public void setPublicToiletNumber(Integer publicToiletNumber) {
		this.publicToiletNumber = publicToiletNumber;
	}
	@Column(name = "has_basement")
	public Integer getHasBasement() {
		return hasBasement;
	}
	public void setHasBasement(Integer hasBasement) {
		this.hasBasement = hasBasement;
	}
	@Column(name = "tolivein_number")
	public Integer getToliveinNumber() {
		return toliveinNumber;
	}
	public void setToliveinNumber(Integer toliveinNumber) {
		this.toliveinNumber = toliveinNumber;
	}
	public Integer getProvince() {
		return province;
	}
	public void setProvince(Integer province) {
		this.province = province;
	}
	public Integer getCity() {
		return city;
	}
	public void setCity(Integer city) {
		this.city = city;
	}
	public Integer getDistict() {
		return distict;
	}
	public void setDistict(Integer distict) {
		this.distict = distict;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	@Column(name = "house_number")
	public String getHouseNumber() {
		return houseNumber;
	}
	public void setHouseNumber(String houseNumber) {
		this.houseNumber = houseNumber;
	}
	public Float getLng() {
		return lng;
	}
	public void setLng(Float lng) {
		this.lng = lng;
	}
	public Float getLat() {
		return lat;
	}
	public void setLat(Float lat) {
		this.lat = lat;
	}
	@Column(name = "house_type")
	public String getHouseType() {
		return houseType;
	}
	public void setHouseType(String houseType) {
		this.houseType = houseType;
	}
	@Column(name = "rent_type")
	public Integer getRentType() {
		return rentType;
	}
	public void setRentType(Integer rentType) {
		this.rentType = rentType;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public String getTraffic() {
		return traffic;
	}
	public void setTraffic(String traffic) {
		this.traffic = traffic;
	}
	public String getSurroundings() {
		return surroundings;
	}
	public void setSurroundings(String surroundings) {
		this.surroundings = surroundings;
	}
	public Float getPrice() {
		return price;
	}
	public void setPrice(Float price) {
		this.price = price;
	}
	@Column(name = "to_foreigner")
	public Integer getToForeigner() {
		return toForeigner;
	}
	public void setToForeigner(Integer toForeigner) {
		this.toForeigner = toForeigner;
	}
	@Column(name = "checkin_time")
	public String getCheckinTime() {
		return checkinTime;
	}
	public void setCheckinTime(String checkinTime) {
		this.checkinTime = checkinTime;
	}
	@Column(name = "checkout_time")
	public String getCheckoutTime() {
		return checkoutTime;
	}
	public void setCheckoutTime(String checkoutTime) {
		this.checkoutTime = checkoutTime;
	}
	@Column(name = "reception_time")
	public String getReceptionTime() {
		return receptionTime;
	}
	public void setReceptionTime(String receptionTime) {
		this.receptionTime = receptionTime;
	}
	@Column(name = "at_least_days")
	public Integer getAtLeastDays() {
		return atLeastDays;
	}
	public void setAtLeastDays(Integer atLeastDays) {
		this.atLeastDays = atLeastDays;
	}
	@Column(name = "in_most_days")
	public Integer getInMostDays() {
		return inMostDays;
	}
	public void setInMostDays(Integer inMostDays) {
		this.inMostDays = inMostDays;
	}
	@Column(name = "need_deposit")
	public Integer getNeedDeposit() {
		return needDeposit;
	}
	public void setNeedDeposit(Integer needDeposit) {
		this.needDeposit = needDeposit;
	}
	@Column(name = "deposit_amount")
	public Float getDepositAmount() {
		return depositAmount;
	}
	public void setDepositAmount(Float depositAmount) {
		this.depositAmount = depositAmount;
	}
	@Column(name = "third_cleaning")
	public Integer getThirdCleaning() {
		return thirdCleaning;
	}
	public void setThirdCleaning(Integer thirdCleaning) {
		this.thirdCleaning = thirdCleaning;
	}
	@Column(name = "platform_toiletries")
	public Integer getPlatformToiletries() {
		return platformToiletries;
	}
	public void setPlatformToiletries(Integer platformToiletries) {
		this.platformToiletries = platformToiletries;
	}
	@Column(name = "platform_bedding")
	public Integer getPlatformBedding() {
		return platformBedding;
	}
	public void setPlatformBedding(Integer platformBedding) {
		this.platformBedding = platformBedding;
	}
	@Column(name = "platform_recommend")
	public Integer getPlatformRecommend() {
		return platformRecommend;
	}
	public void setPlatformRecommend(Integer platformRecommend) {
		this.platformRecommend = platformRecommend;
	}
	@Column(name = "admin_lock")
	public Integer getAdminLock() {
		return adminLock;
	}
	public void setAdminLock(Integer adminLock) {
		this.adminLock = adminLock;
	}
	@Column(name = "type7_rate")
	public Integer getType7Rate() {
		return type7Rate;
	}
	public void setType7Rate(Integer type7Rate) {
		this.type7Rate = type7Rate;
	}
	@Column(name = "type3_rate")
	public Integer getType3Rate() {
		return type3Rate;
	}
	public void setType3Rate(Integer type3Rate) {
		this.type3Rate = type3Rate;
	}
	@Column(name = "type15_rate")
	public Integer getType15Rate() {
		return type15Rate;
	}
	public void setType15Rate(Integer type15Rate) {
		this.type15Rate = type15Rate;
	}
	@Column(name = "type30_rate")
	public Integer getType30Rate() {
		return type30Rate;
	}
	public void setType30Rate(Integer type30Rate) {
		this.type30Rate = type30Rate;
	}
	@Column(name = "check_status")
	public Integer getCheckStatus() {
		return checkStatus;
	}
	public void setCheckStatus(Integer checkStatus) {
		this.checkStatus = checkStatus;
	}
	@Column(name = "operation_status")
	public Integer getOperationStatus() {
		return operationStatus;
	}
	public void setOperationStatus(Integer operationStatus) {
		this.operationStatus = operationStatus;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public House() { }
	public House(Integer id, Integer landlordId, String title, String area, Integer roomNumber, Integer hallNumber,
			Integer kitchenNumber, Integer balconyNumber, Integer toiletNumber, Integer publicToiletNumber,
			Integer hasBasement, Integer toliveinNumber, Integer province, Integer city, Integer distict,
			String address, String houseNumber, Float lng, Float lat, String houseType, Integer rentType,
			String description, String position, String traffic, String surroundings, Float price, Integer toForeigner,
			String checkinTime, String checkoutTime, String receptionTime, Integer atLeastDays, Integer inMostDays,
			Integer needDeposit, Float depositAmount, Integer thirdCleaning, Integer platformToiletries,
			Integer platformBedding, Integer platformRecommend, Integer adminLock, Integer type7Rate, Integer type3Rate,
			Integer type15Rate, Integer type30Rate, Integer checkStatus, Integer operationStatus, String remark) {
		super();
		this.id = id;
		this.landlordId = landlordId;
		this.title = title;
		this.area = area;
		this.roomNumber = roomNumber;
		this.hallNumber = hallNumber;
		this.kitchenNumber = kitchenNumber;
		this.balconyNumber = balconyNumber;
		this.toiletNumber = toiletNumber;
		this.publicToiletNumber = publicToiletNumber;
		this.hasBasement = hasBasement;
		this.toliveinNumber = toliveinNumber;
		this.province = province;
		this.city = city;
		this.distict = distict;
		this.address = address;
		this.houseNumber = houseNumber;
		this.lng = lng;
		this.lat = lat;
		this.houseType = houseType;
		this.rentType = rentType;
		this.description = description;
		this.position = position;
		this.traffic = traffic;
		this.surroundings = surroundings;
		this.price = price;
		this.toForeigner = toForeigner;
		this.checkinTime = checkinTime;
		this.checkoutTime = checkoutTime;
		this.receptionTime = receptionTime;
		this.atLeastDays = atLeastDays;
		this.inMostDays = inMostDays;
		this.needDeposit = needDeposit;
		this.depositAmount = depositAmount;
		this.thirdCleaning = thirdCleaning;
		this.platformToiletries = platformToiletries;
		this.platformBedding = platformBedding;
		this.platformRecommend = platformRecommend;
		this.adminLock = adminLock;
		this.type7Rate = type7Rate;
		this.type3Rate = type3Rate;
		this.type15Rate = type15Rate;
		this.type30Rate = type30Rate;
		this.checkStatus = checkStatus;
		this.operationStatus = operationStatus;
		this.remark = remark;
	}
	@Override
	public String toString() {
		return "House [id=" + id + ", landlordId=" + landlordId + ", title=" + title + ", area=" + area
				+ ", roomNumber=" + roomNumber + ", hallNumber=" + hallNumber + ", kitchenNumber=" + kitchenNumber
				+ ", balconyNumber=" + balconyNumber + ", toiletNumber=" + toiletNumber + ", publicToiletNumber="
				+ publicToiletNumber + ", hasBasement=" + hasBasement + ", toliveinNumber=" + toliveinNumber
				+ ", province=" + province + ", city=" + city + ", distict=" + distict + ", address=" + address
				+ ", houseNumber=" + houseNumber + ", lng=" + lng + ", lat=" + lat + ", houseType=" + houseType
				+ ", rentType=" + rentType + ", description=" + description + ", position=" + position + ", traffic="
				+ traffic + ", surroundings=" + surroundings + ", price=" + price + ", toForeigner=" + toForeigner
				+ ", checkinTime=" + checkinTime + ", checkoutTime=" + checkoutTime + ", receptionTime=" + receptionTime
				+ ", atLeastDays=" + atLeastDays + ", inMostDays=" + inMostDays + ", needDeposit=" + needDeposit
				+ ", depositAmount=" + depositAmount + ", thirdCleaning=" + thirdCleaning + ", platformToiletries="
				+ platformToiletries + ", platformBedding=" + platformBedding + ", platformRecommend="
				+ platformRecommend + ", adminLock=" + adminLock + ", type7Rate=" + type7Rate + ", type3Rate="
				+ type3Rate + ", type15Rate=" + type15Rate + ", type30Rate=" + type30Rate + ", checkStatus="
				+ checkStatus + ", operationStatus=" + operationStatus + ", remark=" + remark + "]";
	}
	
}

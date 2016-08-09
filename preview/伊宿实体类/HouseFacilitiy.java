package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_house_facilities")
public class HouseFacilitiy implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private Integer hotShower;
	private Integer sofa;
	private Integer showerGel;
	private Integer tv;
	private Integer microwaveOven;
	private Integer computer;
	private Integer airCondition;
	private Integer drinkingFountain;
	private Integer refrigerator;
	private Integer washer;
	private Integer wifi;
	private Integer wiredNetwork;
	private Integer parkingSpace;
	private Integer smokingAllowed;
	private Integer cookAllowed;
	private Integer petsAllowed;
	private Integer partyAllowed;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "hot_shower")
	public Integer getHotShower() {
		return hotShower;
	}
	public void setHotShower(Integer hotShower) {
		this.hotShower = hotShower;
	}
	public Integer getSofa() {
		return sofa;
	}
	public void setSofa(Integer sofa) {
		this.sofa = sofa;
	}
	@Column(name = "shower_gel")
	public Integer getShowerGel() {
		return showerGel;
	}
	public void setShowerGel(Integer showerGel) {
		this.showerGel = showerGel;
	}
	public Integer getTv() {
		return tv;
	}
	public void setTv(Integer tv) {
		this.tv = tv;
	}
	@Column(name = "microwave_oven")
	public Integer getMicrowaveOven() {
		return microwaveOven;
	}
	public void setMicrowaveOven(Integer microwaveOven) {
		this.microwaveOven = microwaveOven;
	}
	public Integer getComputer() {
		return computer;
	}
	public void setComputer(Integer computer) {
		this.computer = computer;
	}
	@Column(name = "air_condition")
	public Integer getAirCondition() {
		return airCondition;
	}
	public void setAirCondition(Integer airCondition) {
		this.airCondition = airCondition;
	}
	@Column(name = "drinking_fountain")
	public Integer getDrinkingFountain() {
		return drinkingFountain;
	}
	public void setDrinkingFountain(Integer drinkingFountain) {
		this.drinkingFountain = drinkingFountain;
	}
	public Integer getRefrigerator() {
		return refrigerator;
	}
	public void setRefrigerator(Integer refrigerator) {
		this.refrigerator = refrigerator;
	}
	public Integer getWasher() {
		return washer;
	}
	public void setWasher(Integer washer) {
		this.washer = washer;
	}
	public Integer getWifi() {
		return wifi;
	}
	public void setWifi(Integer wifi) {
		this.wifi = wifi;
	}
	@Column(name = "wired_network")
	public Integer getWiredNetwork() {
		return wiredNetwork;
	}
	public void setWiredNetwork(Integer wiredNetwork) {
		this.wiredNetwork = wiredNetwork;
	}
	@Column(name = "parking_space")
	public Integer getParkingSpace() {
		return parkingSpace;
	}
	public void setParkingSpace(Integer parkingSpace) {
		this.parkingSpace = parkingSpace;
	}
	@Column(name = "smoking_allowed")
	public Integer getSmokingAllowed() {
		return smokingAllowed;
	}
	public void setSmokingAllowed(Integer smokingAllowed) {
		this.smokingAllowed = smokingAllowed;
	}
	@Column(name = "cook_allowed")
	public Integer getCookAllowed() {
		return cookAllowed;
	}
	public void setCookAllowed(Integer cookAllowed) {
		this.cookAllowed = cookAllowed;
	}
	@Column(name = "pets_allowed")
	public Integer getPetsAllowed() {
		return petsAllowed;
	}
	public void setPetsAllowed(Integer petsAllowed) {
		this.petsAllowed = petsAllowed;
	}
	@Column(name = "party_allowed")
	public Integer getPartyAllowed() {
		return partyAllowed;
	}
	public void setPartyAllowed(Integer partyAllowed) {
		this.partyAllowed = partyAllowed;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public HouseFacilitiy() {
	}
	public HouseFacilitiy(Integer id, Integer hotShower, Integer sofa, Integer showerGel, Integer tv, Integer microwaveOven,
			Integer computer, Integer airCondition, Integer drinkingFountain, Integer refrigerator, Integer washer,
			Integer wifi, Integer wiredNetwork, Integer parkingSpace, Integer smokingAllowed, Integer cookAllowed,
			Integer petsAllowed, Integer partyAllowed) {
		super();
		this.id = id;
		this.hotShower = hotShower;
		this.sofa = sofa;
		this.showerGel = showerGel;
		this.tv = tv;
		this.microwaveOven = microwaveOven;
		this.computer = computer;
		this.airCondition = airCondition;
		this.drinkingFountain = drinkingFountain;
		this.refrigerator = refrigerator;
		this.washer = washer;
		this.wifi = wifi;
		this.wiredNetwork = wiredNetwork;
		this.parkingSpace = parkingSpace;
		this.smokingAllowed = smokingAllowed;
		this.cookAllowed = cookAllowed;
		this.petsAllowed = petsAllowed;
		this.partyAllowed = partyAllowed;
	}
	
	
}

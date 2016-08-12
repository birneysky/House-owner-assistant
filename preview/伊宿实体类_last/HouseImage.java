package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_house_images")
public class HouseImage implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;	
	private Integer houseId;
	private String imagePath;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "house_id")
	public Integer getHouseId() {
		return houseId;
	}
	public void setHouseId(Integer houseId) {
		this.houseId = houseId;
	}
	@Column(name = "image_path")
	public String getImagePath() {
		return imagePath;
	}
	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public HouseImage() {
	}
	public HouseImage(Integer id, Integer houseId, String imagePath) {
		super();
		this.id = id;
		this.houseId = houseId;
		this.imagePath = imagePath;
	}
	
	
	
}

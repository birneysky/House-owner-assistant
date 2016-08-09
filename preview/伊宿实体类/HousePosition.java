package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_house_positions")
public class HousePosition implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;		// '记录唯一标识',
	private Integer houseId;		// '房屋唯一标识ID',
	private Integer positionId;		// '景点唯一ID',
	private Integer positionTypeId;		// '景点类型ID',
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
	@Column(name = "position_id")
	public Integer getPositionId() {
		return positionId;
	}
	public void setPositionId(Integer positionId) {
		this.positionId = positionId;
	}
	@Column(name = "position_type_id")
	public Integer getPositionTypeId() {
		return positionTypeId;
	}
	public void setPositionTypeId(Integer positionTypeId) {
		this.positionTypeId = positionTypeId;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public HousePosition() {
	}
	public HousePosition(Integer id, Integer houseId, Integer positionId, Integer positionTypeId) {
		super();
		this.id = id;
		this.houseId = houseId;
		this.positionId = positionId;
		this.positionTypeId = positionTypeId;
	}
	
}
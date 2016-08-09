package com.gotop.house.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "asp_house_beds")
public class HouseBed implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private Integer doubleBedBig;
	private Integer doubleBedMedium;
	private Integer doubleBedSmall;
	private Integer singleBed;
	private Integer doubleDecker;
	private Integer armchair;
	private Integer doubleSofa;
	private Integer childrenBed;
	private Integer infantBed;
	private Integer tatami;
	private Integer roundRed;
	private Integer airBed;
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	@Column(name = "double_bed_big")
	public Integer getDoubleBedBig() {
		return doubleBedBig;
	}
	public void setDoubleBedBig(Integer doubleBedBig) {
		this.doubleBedBig = doubleBedBig;
	}
	@Column(name = "double_bed_medium")
	public Integer getDoubleBedMedium() {
		return doubleBedMedium;
	}
	public void setDoubleBedMedium(Integer doubleBedMedium) {
		this.doubleBedMedium = doubleBedMedium;
	}
	@Column(name = "double_bed_small")
	public Integer getDoubleBedSmall() {
		return doubleBedSmall;
	}
	public void setDoubleBedSmall(Integer doubleBedSmall) {
		this.doubleBedSmall = doubleBedSmall;
	}
	@Column(name = "single_bed")
	public Integer getSingleBed() {
		return singleBed;
	}
	public void setSingleBed(Integer singleBed) {
		this.singleBed = singleBed;
	}
	@Column(name = "double_decker")
	public Integer getDoubleDecker() {
		return doubleDecker;
	}
	public void setDoubleDecker(Integer doubleDecker) {
		this.doubleDecker = doubleDecker;
	}
	public Integer getArmchair() {
		return armchair;
	}
	public void setArmchair(Integer armchair) {
		this.armchair = armchair;
	}
	@Column(name = "double_sofa")
	public Integer getDoubleSofa() {
		return doubleSofa;
	}
	public void setDoubleSofa(Integer doubleSofa) {
		this.doubleSofa = doubleSofa;
	}
	@Column(name = "children_bed")
	public Integer getChildrenBed() {
		return childrenBed;
	}
	public void setChildrenBed(Integer childrenBed) {
		this.childrenBed = childrenBed;
	}
	@Column(name = "infant_bed")
	public Integer getInfantBed() {
		return infantBed;
	}
	public void setInfantBed(Integer infantBed) {
		this.infantBed = infantBed;
	}
	public Integer getTatami() {
		return tatami;
	}
	public void setTatami(Integer tatami) {
		this.tatami = tatami;
	}
	@Column(name = "round_red")
	public Integer getRoundRed() {
		return roundRed;
	}
	public void setRoundRed(Integer roundRed) {
		this.roundRed = roundRed;
	}
	@Column(name = "air_bed")
	public Integer getAirBed() {
		return airBed;
	}
	public void setAirBed(Integer airBed) {
		this.airBed = airBed;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public HouseBed() {
		super();
	}
	public HouseBed(Integer id, Integer doubleBedBig, Integer doubleBedMedium, Integer doubleBedSmall, Integer singleBed,
			Integer doubleDecker, Integer armchair, Integer doubleSofa, Integer childrenBed, Integer infantBed,
			Integer tatami, Integer roundRed, Integer airBed) {
		super();
		this.id = id;
		this.doubleBedBig = doubleBedBig;
		this.doubleBedMedium = doubleBedMedium;
		this.doubleBedSmall = doubleBedSmall;
		this.singleBed = singleBed;
		this.doubleDecker = doubleDecker;
		this.armchair = armchair;
		this.doubleSofa = doubleSofa;
		this.childrenBed = childrenBed;
		this.infantBed = infantBed;
		this.tatami = tatami;
		this.roundRed = roundRed;
		this.airBed = airBed;
	}
	
	
	
}

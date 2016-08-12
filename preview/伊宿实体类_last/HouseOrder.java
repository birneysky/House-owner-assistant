package com.gotop.order.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
@Entity
@Table(name = "asp_house_orders")
public class HouseOrder implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private Integer id;
	private String orderNo; // '订单号',
	private Integer userId; // '租户ID',
	private Integer houseId; // '房源ID',
	private Integer landlordId; // '房东ID',
	private String userName; // '租户名称',
	private String userIdNo; // '租户身份证号',
	private String userMobile; // '租户手机号',
	private String contactName; // '联系人名称',
	private String contactMobile; // '联系人手机',
	private Date reserveTime; // '预订下单时间',
	private Date reserveCheckinTime; // '预订入住时间',
	private Date reserveCheckoutTime; // '预订登出时间',
	private Date checkinTime; // '实际入住时间',
	private Date checkoutTime; // '实际登出时间',
	private Float reserveAmount; // '租房预订金额',
	private Float reservePrice; // '租房预订单价',
	private Float deposit; // '押金',
	private Float couponDiscount; // '优惠券抵扣',
	private Float pointsDiscount; // '积分抵扣',
	private Float compensationAmount; // '赔偿金金额',
	private Integer compensationChecker; // '赔偿金审核人',
	private Date compensationCheckTime; // '赔偿金审核时间',
	private String compensationImage; // '赔偿证明图像(|)',
	private String compensationDesc; // '赔偿说明',
	private Float payAmount; // '支付总金额',
	private Date payTime; // '支付时间',
	private Date orderClose; // '订单关闭时间',
	private Integer cleanType; // '保洁方式 0:房东 1:第三方',
	private Float depositRefund; // '押金退还金额',
	private Float returnAmount; // '提前退房退款金-平台计算',
	private Integer returnChecker; // '退房退款金审核人',
	private Integer returnCheckFlag; // '退房退款金审核状态 0:待审核 1:已审核',
	private String returnCheckReason;	// comment '退房退款金审核说明',
	private Date returnCheckTime; // '退房退款金审核时间',
	private Integer compensationStatus; // '赔偿状态 1:无2:待赔偿3:已赔偿',
	private Integer status; // '订单状态 1.待确认 2.待支付 3.待入住 4.入住中 5.脏房 6.已完成',
	private Integer needInvoice; // '是否需要开票 0:不开票 1:开票',
	private Integer invoiceFlag; // '开票标识 0:未开票 1:已开票',
	private Integer userInvoiceId; // '用户发票ID',
	private String remarks; // '备注',
	
	public HouseOrder() {}

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "order_no")
	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	@Column(name = "user_id")
	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	@Column(name = "house_id")
	public Integer getHouseId() {
		return houseId;
	}

	public void setHouseId(Integer houseId) {
		this.houseId = houseId;
	}

	@Column(name = "landlord_id")
	public Integer getLandlordId() {
		return landlordId;
	}

	public void setLandlordId(Integer landlordId) {
		this.landlordId = landlordId;
	}

	@Column(name = "user_name")
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "user_id_no")
	public String getUserIdNo() {
		return userIdNo;
	}

	public void setUserIdNo(String userIdNo) {
		this.userIdNo = userIdNo;
	}

	@Column(name = "user_mobile")
	public String getUserMobile() {
		return userMobile;
	}

	public void setUserMobile(String userMobile) {
		this.userMobile = userMobile;
	}

	@Column(name = "contact_name")
	public String getContactName() {
		return contactName;
	}

	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	@Column(name = "contact_mobile")
	public String getContactMobile() {
		return contactMobile;
	}

	public void setContactMobile(String contactMobile) {
		this.contactMobile = contactMobile;
	}

	@Column(name = "reserve_time")
	public Date getReserveTime() {
		return reserveTime;
	}

	public void setReserveTime(Date reserveTime) {
		this.reserveTime = reserveTime;
	}

	@Column(name = "reserve_checkin_time")
	public Date getReserveCheckinTime() {
		return reserveCheckinTime;
	}

	public void setReserveCheckinTime(Date reserveCheckinTime) {
		this.reserveCheckinTime = reserveCheckinTime;
	}

	@Column(name = "reserve_checkout_time")
	public Date getReserveCheckoutTime() {
		return reserveCheckoutTime;
	}

	public void setReserveCheckoutTime(Date reserveCheckoutTime) {
		this.reserveCheckoutTime = reserveCheckoutTime;
	}

	@Column(name = "checkin_time")
	public Date getCheckinTime() {
		return checkinTime;
	}

	public void setCheckinTime(Date checkinTime) {
		this.checkinTime = checkinTime;
	}

	@Column(name = "checkout_time")
	public Date getCheckoutTime() {
		return checkoutTime;
	}

	public void setCheckoutTime(Date checkoutTime) {
		this.checkoutTime = checkoutTime;
	}

	@Column(name = "reserve_amount")
	public Float getReserveAmount() {
		return reserveAmount;
	}

	public void setReserveAmount(Float reserveAmount) {
		this.reserveAmount = reserveAmount;
	}

	@Column(name = "reserve_price")
	public Float getReservePrice() {
		return reservePrice;
	}

	public void setReservePrice(Float reservePrice) {
		this.reservePrice = reservePrice;
	}

	public Float getDeposit() {
		return deposit;
	}

	public void setDeposit(Float deposit) {
		this.deposit = deposit;
	}

	@Column(name = "coupon_discount")
	public Float getCouponDiscount() {
		return couponDiscount;
	}

	public void setCouponDiscount(Float couponDiscount) {
		this.couponDiscount = couponDiscount;
	}

	@Column(name = "points_discount")
	public Float getPointsDiscount() {
		return pointsDiscount;
	}

	public void setPointsDiscount(Float pointsDiscount) {
		this.pointsDiscount = pointsDiscount;
	}

	@Column(name = "compensation_amount")
	public Float getCompensationAmount() {
		return compensationAmount;
	}

	public void setCompensationAmount(Float compensationAmount) {
		this.compensationAmount = compensationAmount;
	}

	@Column(name = "compensation_checker")
	public Integer getCompensationChecker() {
		return compensationChecker;
	}

	public void setCompensationChecker(Integer compensationChecker) {
		this.compensationChecker = compensationChecker;
	}

	@Column(name = "compensation_check_time")
	public Date getCompensationCheckTime() {
		return compensationCheckTime;
	}

	public void setCompensationCheckTime(Date compensationCheckTime) {
		this.compensationCheckTime = compensationCheckTime;
	}

	@Column(name = "compensation_image")
	public String getCompensationImage() {
		return compensationImage;
	}

	public void setCompensationImage(String compensationImage) {
		this.compensationImage = compensationImage;
	}

	@Column(name = "compensation_desc")
	public String getCompensationDesc() {
		return compensationDesc;
	}

	public void setCompensationDesc(String compensationDesc) {
		this.compensationDesc = compensationDesc;
	}

	@Column(name = "pay_amount")
	public Float getPayAmount() {
		return payAmount;
	}

	public void setPayAmount(Float payAmount) {
		this.payAmount = payAmount;
	}

	@Column(name = "pay_time")
	public Date getPayTime() {
		return payTime;
	}

	public void setPayTime(Date payTime) {
		this.payTime = payTime;
	}

	@Column(name = "order_close")
	public Date getOrderClose() {
		return orderClose;
	}

	public void setOrderClose(Date orderClose) {
		this.orderClose = orderClose;
	}

	@Column(name = "clean_type")
	public Integer getCleanType() {
		return cleanType;
	}

	public void setCleanType(Integer cleanType) {
		this.cleanType = cleanType;
	}

	@Column(name = "deposit_refund")
	public Float getDepositRefund() {
		return depositRefund;
	}

	public void setDepositRefund(Float depositRefund) {
		this.depositRefund = depositRefund;
	}

	@Column(name = "return_amount")
	public Float getReturnAmount() {
		return returnAmount;
	}

	public void setReturnAmount(Float returnAmount) {
		this.returnAmount = returnAmount;
	}

	@Column(name = "return_checker")
	public Integer getReturnChecker() {
		return returnChecker;
	}

	public void setReturnChecker(Integer returnChecker) {
		this.returnChecker = returnChecker;
	}

	@Column(name = "return_refund")
	public Integer getReturnCheckFlag() {
		return returnCheckFlag;
	}

	public void setReturnCheckFlag(Integer returnCheckFlag) {
		this.returnCheckFlag = returnCheckFlag;
	}
	@Column(name = "return_check_reason")
	public String getReturnCheckReason() {
		return returnCheckReason;
	}

	public void setReturnCheckReason(String returnCheckReason) {
		this.returnCheckReason = returnCheckReason;
	}

	@Column(name = "return_check_time")
	public Date getReturnCheckTime() {
		return returnCheckTime;
	}

	public void setReturnCheckTime(Date returnCheckTime) {
		this.returnCheckTime = returnCheckTime;
	}

	@Column(name = "compensation_status")
	public Integer getCompensationStatus() {
		return compensationStatus;
	}

	public void setCompensationStatus(Integer compensationStatus) {
		this.compensationStatus = compensationStatus;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	@Column(name = "need_invoice")
	public Integer getNeedInvoice() {
		return needInvoice;
	}

	public void setNeedInvoice(Integer needInvoice) {
		this.needInvoice = needInvoice;
	}

	@Column(name = "invoice_flag")
	public Integer getInvoiceFlag() {
		return invoiceFlag;
	}

	public void setInvoiceFlag(Integer invoiceFlag) {
		this.invoiceFlag = invoiceFlag;
	}

	@Column(name = "user_invoice_id")
	public Integer getUserInvoiceId() {
		return userInvoiceId;
	}

	public void setUserInvoiceId(Integer userInvoiceId) {
		this.userInvoiceId = userInvoiceId;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
}

package com.harunichi.member.vo;

import java.sql.Timestamp;
import java.sql.Date;

public class MemberVo {
	
		private String id; //아이디
		private String pass; //비밀번호
		private String name; //이름
		private String nick; //닉네임
		private String contry; //국적
		private Date year; //생년월일
		private String gender; //성별
		private String email; //이메일
		private String tel; //전화번호
		private String address; // 주소
		private String myLike; //관심사
		private String profileImg; //프로필이미지
		private int follower; //팔로워
		private Timestamp joindate; //가입일
		private String kakao_id; //카카오아이디
		private String naver_id; //네이버아이디
		
		
		
		
		
		
		
		public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getPass() {
			return pass;
		}
		public void setPass(String pass) {
			this.pass = pass;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getNick() {
			return nick;
		}
		public void setNick(String nick) {
			this.nick = nick;
		}
		public String getContry() {
			return contry;
		}
		public void setContry(String contry) {
			this.contry = contry;
		}
		public Date getYear() {
			return year;
		}
		public void setYear(Date year) {
			this.year = year;
		}
		public String getGender() {
			return gender;
		}
		public void setGender(String gender) {
			this.gender = gender;
		}
		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}
		public String getTel() {
			return tel;
		}
		public void setTel(String tel) {
			this.tel = tel;
		}
		public String getAddress() {
			return address;
		}
		public void setAddress(String address) {
			this.address = address;
		}
		public String getMyLike() {
			return myLike;
		}
		public void setMyLike(String myLike) {
			this.myLike = myLike;
		}
		public String getProfileImg() {
			return profileImg;
		}
		public void setProfileImg(String profileImg) {
			this.profileImg = profileImg;
		}
		public int getFollower() {
			return follower;
		}
		public void setFollower(int follower) {
			this.follower = follower;
		}
		public Timestamp getJoindate() {
			return joindate;
		}
		public void setJoindate(Timestamp joindate) {
			this.joindate = joindate;
		}
		public String getKakao_id() {
			return kakao_id;
		}
		public void setKakao_id(String kakao_id) {
			this.kakao_id = kakao_id;
		}
		public String getNaver_id() {
			return naver_id;
		}
		public void setNaver_id(String naver_id) {
			this.naver_id = naver_id;
		}
	
		
		
}


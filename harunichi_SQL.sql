CREATE DATABASE  IF NOT EXISTS `harunichi` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `harunichi`;
-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: harunichi
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `boardId` int NOT NULL AUTO_INCREMENT,
  `boardCont` varchar(255) NOT NULL,
  `boardDate` timestamp NULL DEFAULT NULL,
  `boardLike` int DEFAULT NULL,
  `boardCount` int DEFAULT NULL,
  `boardRe` int DEFAULT NULL,
  `boardImg1` varchar(255) DEFAULT NULL,
  `boardImg2` varchar(255) DEFAULT NULL,
  `boardImg3` varchar(255) DEFAULT NULL,
  `boardImg4` varchar(255) DEFAULT NULL,
  `boardWriter` varchar(255) DEFAULT NULL,
  `boardCate` varchar(255) DEFAULT NULL,
  `boardModDate` timestamp NULL DEFAULT NULL,
  `boardWriterImg` varchar(255) DEFAULT NULL,
  `boardWriterId` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`boardId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `boardlike`
--

DROP TABLE IF EXISTS `boardlike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `boardlike` (
  `boardLikeId` int NOT NULL AUTO_INCREMENT,
  `boardLikeUser` varchar(20) DEFAULT NULL,
  `boardLikePost` int NOT NULL,
  `userLiked` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`boardLikeId`),
  KEY `fk_boardlike_board` (`boardLikePost`),
  CONSTRAINT `fk_boardlike_board` FOREIGN KEY (`boardLikePost`) REFERENCES `board` (`boardId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `boardlike`
--

LOCK TABLES `boardlike` WRITE;
/*!40000 ALTER TABLE `boardlike` DISABLE KEYS */;
/*!40000 ALTER TABLE `boardlike` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat`
--

DROP TABLE IF EXISTS `chat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat` (
  `messageId` int NOT NULL AUTO_INCREMENT,
  `roomId` varchar(50) NOT NULL,
  `senderId` varchar(100) NOT NULL,
  `nickname` varchar(20) NOT NULL,
  `receiverId` varchar(100) DEFAULT NULL,
  `chatType` enum('personal','group') NOT NULL,
  `message` varchar(1000) DEFAULT NULL,
  `chatFile` varchar(255) DEFAULT NULL,
  `isRead` tinyint(1) NOT NULL DEFAULT '0',
  `isReported` tinyint(1) NOT NULL DEFAULT '0',
  `sentTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `receivedTime` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`messageId`),
  KEY `fk_roomId_idx` (`roomId`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat`
--

LOCK TABLES `chat` WRITE;
/*!40000 ALTER TABLE `chat` DISABLE KEYS */;
INSERT INTO `chat` VALUES (50,'20250627_747255','user01','칸나','','group','안녕하세요',NULL,0,0,'2025-06-27 06:52:38',NULL),(51,'20250627_747255','user02','Thoon','','group','안녕하세요~',NULL,0,0,'2025-06-27 06:52:56',NULL),(52,'20250627_747255','user03','タカハシゼロ','','group','반갑습니다!',NULL,0,0,'2025-06-27 06:53:18',NULL),(53,'20250630_604846','user01','칸나','','group','안녕하세요 :)',NULL,0,0,'2025-06-30 00:42:12',NULL),(54,'20250630_109382','user02','Thoon','','group','안녕하세요!',NULL,0,0,'2025-06-30 00:46:43',NULL),(55,'20250630_775743','user02','','user04','personal','안녕하세요~!',NULL,0,0,'2025-06-30 00:47:03',NULL),(56,'20250627_747255','user01','칸나','','group','ㅎㅇㅎㅇ',NULL,0,0,'2025-06-30 00:47:41',NULL);
/*!40000 ALTER TABLE `chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatroom`
--

DROP TABLE IF EXISTS `chatroom`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatroom` (
  `roomId` varchar(50) NOT NULL,
  `userId` varchar(100) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `leader` tinyint(1) NOT NULL DEFAULT '0',
  `persons` int NOT NULL DEFAULT '2',
  `chatType` enum('personal','group') NOT NULL,
  `admissionTime` timestamp NOT NULL,
  `profileImg` varchar(255) DEFAULT NULL,
  `productId` int DEFAULT NULL,
  `lastMessageTime` timestamp NULL DEFAULT NULL,
  `isDeleted` tinyint(1) DEFAULT '0',
  `isKicked` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatroom`
--

LOCK TABLES `chatroom` WRITE;
/*!40000 ALTER TABLE `chatroom` DISABLE KEYS */;
INSERT INTO `chatroom` VALUES ('20250627_747255','user01','일사모',0,4,'group','2025-06-27 06:52:32','74b3426f-1e0b-4094-8d38-c6f82f460f9c_profile7.PNG',NULL,'2025-06-30 00:47:41',0,0),('20250627_747255','user02','일사모',1,4,'group','2025-06-27 06:52:52','74b3426f-1e0b-4094-8d38-c6f82f460f9c_profile7.PNG',NULL,'2025-06-30 00:47:41',0,0),('20250627_747255','user03','일사모',0,4,'group','2025-06-27 06:53:14','74b3426f-1e0b-4094-8d38-c6f82f460f9c_profile7.PNG',NULL,'2025-06-30 00:47:41',1,0),('20250630_604846','user01','여행모임',1,5,'group','2025-06-30 00:42:07','39efbbe9-e76a-403f-aae4-2032f87f1104_profile6.PNG',NULL,'2025-06-30 00:42:12',0,0),('20250630_775743','user04',NULL,0,2,'personal','2025-06-30 00:46:57',NULL,NULL,'2025-06-30 00:47:03',0,0),('20250630_775743','user02',NULL,0,2,'personal','2025-06-30 00:46:57',NULL,NULL,'2025-06-30 00:47:03',0,0);
/*!40000 ALTER TABLE `chatroom` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `follow`
--

DROP TABLE IF EXISTS `follow`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `follow` (
  `follower_id` varchar(100) NOT NULL,
  `followee_id` varchar(100) NOT NULL,
  `follow_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`follower_id`,`followee_id`),
  KEY `followee_id` (`followee_id`),
  CONSTRAINT `follow_ibfk_1` FOREIGN KEY (`follower_id`) REFERENCES `member` (`id`),
  CONSTRAINT `follow_ibfk_2` FOREIGN KEY (`followee_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `follow`
--

LOCK TABLES `follow` WRITE;
/*!40000 ALTER TABLE `follow` DISABLE KEYS */;
INSERT INTO `follow` VALUES ('admin','user01','2025-06-30 10:32:33'),('admin','user02','2025-06-30 10:32:33'),('user01','admin','2025-06-30 10:32:33'),('user01','user03','2025-06-30 10:32:33'),('user02','admin','2025-06-30 10:32:33'),('user02','user04','2025-06-30 10:32:33'),('user03','user01','2025-06-30 10:32:33'),('user03','user04','2025-06-30 10:32:33'),('user04','admin','2025-06-30 10:32:33'),('user04','user02','2025-06-30 10:32:33');
/*!40000 ALTER TABLE `follow` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` varchar(100) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `name` varchar(20) NOT NULL,
  `nick` varchar(20) NOT NULL,
  `contry` varchar(20) NOT NULL,
  `year` date NOT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `tel` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `myLike` varchar(255) DEFAULT NULL,
  `profileImg` varchar(255) DEFAULT NULL,
  `follower` int NOT NULL DEFAULT '0',
  `joindate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `kakao_id` varchar(255) DEFAULT NULL,
  `naver_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_email` (`email`),
  UNIQUE KEY `uk_kakao_id` (`kakao_id`),
  UNIQUE KEY `uk_naver_id` (`naver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` VALUES ('admin','123456','운영자','운영자','kr','1991-11-12','','admin@harunichi.com','','','','admin_profile.jpg',0,'2025-06-16 23:44:42',NULL,NULL),('user01','123456','김한나','칸나','kr','2002-06-28','F','user01@gmail.com','+821077843336','대전 동구 판교1길 3','여행,맛집,코딩,음악,운동,DIY,음악감상','user01_profile.png',0,'2025-06-19 06:11:16',NULL,NULL),('user02','123456','김지훈','Thoon','kr','1986-12-25','M','user02@gmail.com','+821088951515','제주특별자치도 제주시 신설로 55','코딩,스포츠,반려동물,운동,커피,영화감상','user02_profile.jpg',0,'2025-06-19 06:28:20',NULL,NULL),('user03','123456','高橋健二','タカハシゼロ','jp','2007-03-03','M','user03@gmail.com','+819055841212','東京都 千代田区 千代田','게임,독서,웹툰,영화감상','user03_profile.png',0,'2025-06-19 06:33:29',NULL,NULL),('user04','123456','佐藤 美幸','ミユポン','jp','1984-05-23','F','user04@gmail.com','+817055142365','福岡県 久留米市 北野町高良','독서,커피,차,영화감상,음악감상','user04_profile.png',0,'2025-06-19 06:45:23',NULL,NULL),('user05','123456','이요한','요화니','kr','1988-03-11','M','user05@gmail.com','+821011111111','부산 부산진구 신천대로50번길 79','여행,커피,코딩,음악,운동,DIY,음악감상','user05_profile.png',0,'2025-06-19 06:50:16',NULL,NULL),('user06','123456','박재용','Dragon','kr','2000-05-28','M','user06@gmail.com','+821022222222','부산 수영구 남천동로108번길 43','독서,맛집,코딩,음악,반려동물','user06_profile.png',0,'2025-06-19 09:11:16',NULL,NULL),('user07','123456','권지수','Jisoo','kr','1992-12-27','F','user07@gmail.com','+821033333333','경남 김해시 분성로 287-14','여행,음악,운동,웹툰,음악감상','user07_profile.png',0,'2025-06-20 05:01:16',NULL,NULL);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `imp_uid` varchar(100) NOT NULL,
  `merchant_uid` varchar(100) NOT NULL,
  `product_id` int NOT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `product_status` int DEFAULT NULL,
  `amount` int NOT NULL,
  `buyer_id` varchar(100) DEFAULT NULL,
  `buyer_name` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_imp_uid` (`imp_uid`),
  KEY `product_id` (`product_id`),
  KEY `buyer_id` (`buyer_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`productId`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`buyer_id`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `productId` int NOT NULL AUTO_INCREMENT,
  `productTitle` varchar(100) NOT NULL,
  `productPrice` int DEFAULT NULL,
  `productStatus` tinyint(1) NOT NULL DEFAULT '0',
  `productCategory` varchar(50) DEFAULT NULL,
  `productContent` text NOT NULL,
  `productDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `productImg` varchar(200) DEFAULT NULL,
  `productCount` int DEFAULT '0',
  `productWriterId` varchar(100) NOT NULL,
  PRIMARY KEY (`productId`),
  KEY `productWriterId` (`productWriterId`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`productWriterId`) REFERENCES `member` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,'자바의 정석',5000,0,'book','개발자 필독서입니다. 상태 아주 좋아요.','2025-06-20 01:29:55','java_book.jpg',5,'user07'),(2,'블루투스 이어폰',18000,0,'electronics','음질 좋고 배터리 오래갑니다.','2025-06-20 01:29:55','earbuds.jpg',0,'user01'),(3,'여성용 코트',30000,0,'fashion','겨울용 울 코트입니다. 거의 새 제품이에요.','2025-06-20 01:29:55','coat.jpg',5,'user02'),(4,'요리책 모음',0,1,'book','자취생을 위한 간단 레시피 모음집.','2025-06-20 01:29:55','cookbook.jpg',0,'user02'),(5,'CD 플레이어',0,1,'electronics','작동은 잘 되나 외관에 기스 있음.','2025-06-23 01:29:55','cd_player.jpg',5,'user07'),(6,'쿠션 & 담요 세트',0,1,'etc','깨끗하게 세탁한 제품입니다.','2025-06-23 01:29:55','cushion_blanket.jpg',2,'user02'),(7,'스탠드 조명',15000,0,'electronics','은은한 분위기의 LED 스탠드입니다.','2025-06-23 01:29:55','stand_light.jpg',0,'user06'),(8,'남성용 가죽 지갑',15000,0,'fashion','실사용 거의 없는 깔끔한 상태입니다.','2025-06-23 01:29:55','wallet.jpg',0,'user05'),(9,'텀블러 세트',8000,0,'etcproduct','스타벅스 한정판 포함 3종 세트.','2025-06-23 01:29:55','tumbler.jpg',5,'user02'),(10,'토익 인강 USB',5000,0,'book','YBM 토익 인강 USB, 최신 강의 수록.','2025-06-23 01:29:55','toeic_usb.jpg',0,'user05'),(11,'블루투스 스피커',18000,0,'electronics','작지만 강력한 사운드, 방수 가능.','2025-06-23 01:29:55','speaker.jpg',9,'user01'),(12,'어린이 그림책 5권',0,1,'book','중고지만 깨끗합니다. 나눔합니다.','2025-06-23 01:29:55','kids_books.jpg',0,'user06'),(13,'헌 옷 정리합니다',0,1,'fashion','티셔츠, 청바지 등 10벌 이상. 가져가실 분!','2025-06-23 01:29:55','used_clothes.jpg',0,'user02'),(14,'화분　정리합니다',0,1,'etc','다육이 스투키 등 여러 종류 있어요.','2025-06-23 01:29:55','plants.jpg',0,'user01'),(15,'유아 장난감',0,1,'etc','상태 양호, 무료 나눔합니다.','2025-06-23 01:29:55','toys.jpg',0,'user06');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productlike`
--

DROP TABLE IF EXISTS `productlike`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productlike` (
  `productId` int NOT NULL,
  `likeUserId` varchar(50) NOT NULL,
  PRIMARY KEY (`productId`,`likeUserId`),
  KEY `likeUserId` (`likeUserId`),
  CONSTRAINT `productlike_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`productId`),
  CONSTRAINT `productlike_ibfk_2` FOREIGN KEY (`likeUserId`) REFERENCES `member` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productlike`
--

LOCK TABLES `productlike` WRITE;
/*!40000 ALTER TABLE `productlike` DISABLE KEYS */;
/*!40000 ALTER TABLE `productlike` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reply`
--

DROP TABLE IF EXISTS `reply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reply` (
  `replyId` int NOT NULL AUTO_INCREMENT,
  `replyCont` varchar(255) NOT NULL,
  `replyDate` timestamp NULL DEFAULT NULL,
  `replyLike` int DEFAULT NULL,
  `replyWriter` varchar(255) DEFAULT NULL,
  `boardId` int DEFAULT NULL,
  `replyWriterId` varchar(255) DEFAULT NULL,
  `parentId` int DEFAULT NULL,
  `replyWriterImg` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`replyId`),
  KEY `fk_reply_board` (`boardId`),
  CONSTRAINT `fk_reply_board` FOREIGN KEY (`boardId`) REFERENCES `board` (`boardId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reply`
--

LOCK TABLES `reply` WRITE;
/*!40000 ALTER TABLE `reply` DISABLE KEYS */;
/*!40000 ALTER TABLE `reply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visit`
--

DROP TABLE IF EXISTS `visit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visit` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ip` varchar(100) DEFAULT NULL,
  `visit_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visit`
--

LOCK TABLES `visit` WRITE;
/*!40000 ALTER TABLE `visit` DISABLE KEYS */;
INSERT INTO `visit` VALUES (1,'0:0:0:0:0:0:0:1','2025-06-25 05:42:31'),(2,'0:0:0:0:0:0:0:1','2025-06-25 05:44:42'),(3,'0:0:0:0:0:0:0:1','2025-06-25 05:45:39'),(4,'0:0:0:0:0:0:0:1','2025-06-25 05:45:43'),(5,'0:0:0:0:0:0:0:1','2025-06-25 05:46:31'),(6,'0:0:0:0:0:0:0:1','2025-06-25 05:46:41'),(7,'0:0:0:0:0:0:0:1','2025-06-25 05:46:41'),(8,'0:0:0:0:0:0:0:1','2025-06-25 05:46:48'),(9,'0:0:0:0:0:0:0:1','2025-06-25 05:47:38');
/*!40000 ALTER TABLE `visit` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-30 12:18:39

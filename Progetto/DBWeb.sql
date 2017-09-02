DROP DATABASE WebProject;

CREATE DATABASE WebProject;

USE WebProject;

DROP TABLE IF EXISTS User;
CREATE TABLE User
(
	userId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	surname VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL UNIQUE,
	password VARCHAR(50) NOT NULL,
	address VARCHAR(100) NOT NULL,
	verificationCode CHAR(50) NOT NULL,
	type ENUM('admin','seller','registered') NOT NULL
);

DROP TABLE IF EXISTS Shop;
CREATE TABLE Shop
(
	shopId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	website VARCHAR(100),
	address VARCHAR(100) NOT NULL,
	lat DOUBLE NOT NULL,
	lon DOUBLE NOT NULL,
	openingHours VARCHAR(200),
	userId INT UNSIGNED NOT NULL,
	imagePath VARCHAR(200) NOT NULL,
	CONSTRAINT FOREIGN KEY(userId) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Item;
CREATE TABLE Item
(
	itemId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	description VARCHAR(500) NOT NULL,
	category ENUM('electronics', 'home', 'books', 'sport', 'other') NOT NULL,
	price DECIMAL(10, 2) NOT NULL,
	shopId INT UNSIGNED NOT NULL,
	CONSTRAINT FOREIGN KEY(shopId) REFERENCES Shop(shopId) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS Purchase;
CREATE TABLE Purchase
(
	purchaseId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	userId INT UNSIGNED NOT NULL,
	itemId INT UNSIGNED NOT NULL,
	quantity INT UNSIGNED NOT NULL,
	purchaseTime TIMESTAMP NOT NULL,
	CONSTRAINT FOREIGN KEY(userId) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT FOREIGN KEY(itemId) REFERENCES Item(itemId) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ShopReview;
CREATE TABLE ShopReview
(
	shopReviewId INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	reviewText VARCHAR(1000) NOT NULL,
	reply VARCHAR(1000),
	userId INT UNSIGNED NOT NULL,
	shopId INT UNSIGNED NOT NULL,
	reviewTime TIMESTAMP NOT NULL,
        score INT NOT NULL,
	FOREIGN KEY(userId) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(shopId) REFERENCES Shop(shopId) ON UPDATE CASCADE ON DELETE RESTRICT
);

DROP TABLE IF EXISTS ItemReview;
CREATE TABLE ItemReview
(
	itemReviewId INT UNSIGNED AUTO_INCREMENT,
	reviewText VARCHAR(1000) NOT NULL,
	reply VARCHAR(1000),
	userId INT UNSIGNED NOT NULL,
	itemId INT UNSIGNED NOT NULL,
	reviewTime TIMESTAMP NOT NULL,
        score INT NOT NULL,
	FOREIGN KEY(userId) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(itemId) REFERENCES Item(itemId) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(itemReviewId)
);

DROP TABLE IF EXISTS Picture;
CREATE TABLE Picture
(
	pictureId INT UNSIGNED AUTO_INCREMENT,
	path VARCHAR(200) NOT NULL,
	itemId INT UNSIGNED NOT NULL,
	FOREIGN KEY(itemId) REFERENCES Item(itemId) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(pictureId)
);

DROP TABLE IF EXISTS Notification;
CREATE TABLE Notification
(
	notificationId INT UNSIGNED AUTO_INCREMENT,
	author INT UNSIGNED NOT NULL,
	recipient INT UNSIGNED NOT NULL,
	notificationText VARCHAR(1000) NOT NULL,
	notificationTime TIMESTAMP NOT NULL,
	seen BOOLEAN NOT NULL DEFAULT 0,
	type ENUM('newcommentshop','replycommentshop','newcommentitem','replycommentitem','newcomplaint','replycomplaint') NOT NULL,
	link VARCHAR(1000),
	FOREIGN KEY(author) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY(recipient) REFERENCES User(userId) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(notificationId)
);

DROP TABLE IF EXISTS Complaint;
CREATE TABLE Complaint
(
	complaintId INT UNSIGNED AUTO_INCREMENT,
	purchaseId INT UNSIGNED NOT NULL,
	complaintTime TIMESTAMP NOT NULL,
	complaintText VARCHAR(1000) NOT NULL,
	reply VARCHAR(1000),
	status ENUM('new', 'seen', 'rejected'),
	FOREIGN KEY(purchaseId) REFERENCES Purchase(purchaseId) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(complaintId)
);
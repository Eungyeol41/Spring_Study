-- --------------------------------------------------------
-- 호스트:                          localhost
-- 서버 버전:                        10.5.1-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 함수 isp.F_ANS_SCHDL 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_ANS_SCHDL`(PARAM1 TIMESTAMP,PARAM2 INT) RETURNS timestamp
BEGIN
	DECLARE R_VAL TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
	DECLARE NUM INT DEFAULT 0;
	DECLARE CNT INT DEFAULT 1;
	loop_ans_schdl:LOOP
	IF NUM = PARAM2 THEN LEAVE loop_ans_schdl;
	ELSEIF (SELECT F_HOLIDAY(TIMESTAMPADD(DAY,CNT,PARAM1))) = 1 THEN SET NUM = NUM + 0, CNT = CNT +1;
	ELSE SET NUM = NUM + 1, CNT = CNT +1;
	END IF;
	END LOOP;
	SET R_VAL = (SELECT TIMESTAMPADD(DAY,(CNT-1),PARAM1));
	RETURN R_VAL;
END//
DELIMITER ;

-- 함수 isp.F_FILE_ID 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_FILE_ID`(`PARAM1` VARCHAR(50)
) RETURNS varchar(50) CHARSET utf8
    COMMENT '파일아이디'
BEGIN
	DECLARE R_VAR VARCHAR(50);
	SELECT ATCH_FILE_ID INTO R_VAR FROM T_ATCH_FILE WHERE USE_YN = 'Y' AND ATCH_FILE_ID = PARAM1;
	RETURN R_VAR;
END//
DELIMITER ;

-- 함수 isp.F_GAP_DT 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_GAP_DT`(date1 datetime, date2 datetime) RETURNS int(11)
BEGIN
	DECLARE R_VAL INT;
	DECLARE COMP INT;
	DECLARE CNT INT DEFAULT 1;
	SET R_VAL = ABS(DATEDIFF(date1, date2));
	SET COMP = R_VAL;
	loop_gap:LOOP
	IF CNT = COMP + 1 OR date2 is null OR date2 = '' THEN LEAVE loop_gap;
	ELSEIF F_HOLIDAY(DATE_ADD(date1,INTERVAL CNT DAY)) = 1 THEN SET R_VAL = R_VAL - 1 ,CNT = CNT + 1;
	ELSE SET CNT = CNT + 1;
	END IF;
	END LOOP;
	RETURN R_VAL;
END//
DELIMITER ;

-- 함수 isp.F_HOLIDAY 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_HOLIDAY`(`PARAM1` DATETIME
) RETURNS varchar(1) CHARSET utf8
BEGIN
	DECLARE R_VAL VARCHAR(1);
	IF (SELECT DAYOFWEEK(PARAM1)) = 1 OR (SELECT DAYOFWEEK(PARAM1)) = 7 OR (SELECT HOL_YN FROM T_CALENDAR TC WHERE DATE_FORMAT(TC.DATA_DATE,'%Y-%m-%d') = DATE_FORMAT(PARAM1,'%Y-%m-%d') AND USE_YN='Y') = 'Y' THEN SET R_VAL = '1';
	ELSE SET R_VAL = '0';
	END IF;
	RETURN R_VAL;
END//
DELIMITER ;

-- 함수 isp.F_SITE_NM 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_SITE_NM`(`PARAM1` VARCHAR(50)
) RETURNS varchar(50) CHARSET utf8
    COMMENT '사이트명'
BEGIN
	DECLARE R_VAR VARCHAR(50);
	
	SELECT SITE_NM INTO R_VAR FROM T_SITE WHERE SITE_CLCD = PARAM1;
	
	RETURN R_VAR;
END//
DELIMITER ;

-- 함수 isp.F_USER_ID 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_USER_ID`(`PARAM1` VARCHAR(50)
) RETURNS varchar(50) CHARSET utf8
    COMMENT '유저아이디'
BEGIN
	DECLARE R_VAR VARCHAR(50);
	SELECT (SELECT ID FROM T_AD_USER WHERE SEQ = PARAM1 LIMIT 1) INTO R_VAR;
	
	RETURN R_VAR;
END//
DELIMITER ;

-- 함수 isp.F_USER_NM 구조 내보내기
DELIMITER //
CREATE FUNCTION `F_USER_NM`(`PARAM1` VARCHAR(50)



) RETURNS varchar(50) CHARSET utf8
    COMMENT '유저명'
BEGIN
	DECLARE R_VAR VARCHAR(50);
	SELECT (SELECT NAME FROM T_AD_USER WHERE SEQ = PARAM1 LIMIT 1) INTO R_VAR;
	
	RETURN R_VAR;
END//
DELIMITER ;

-- 프로시저 isp.loopInsertBidding 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertBidding`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_bidding) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_bidding) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertDate 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertDate`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_data) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_data) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertInfoTrend 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertInfoTrend`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_info_trends) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_info_trends) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertMembershipRecruit 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertMembershipRecruit`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_membership_recruit) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_membership_recruit) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertMembershipTrend 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertMembershipTrend`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_membership_trend) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_membership_trend) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertNotice 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertNotice`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_notice) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_notice) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 프로시저 isp.loopInsertTrend 구조 내보내기
DELIMITER //
CREATE PROCEDURE `loopInsertTrend`(token varchar(20))
BEGIN
        DECLARE i INT DEFAULT 0;
        DECLARE file_sn INT DEFAULT 0;
        DECLARE che INT DEFAULT 0;
        DECLARE total INT DEFAULT 0;
        DECLARE done INT DEFAULT FALSE;
        DECLARE seq int DEFAULT 0;
        DECLARE realname VARCHAR(100);
        DECLARE savename VARCHAR(100);
        DECLARE file_id INT DEFAULT -1;
        DECLARE countt INT DEFAULT 0;
        
        DECLARE cursor1 CURSOR FOR
            SELECT bt.bd_no, BF.bf_realName, BF.bf_saveName
            FROM (SELECT bd_no FROM rapa2013.frame_board_trend) bt, rapa2013.FRAME_BOARD_FILE BF
            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no ORDER BY BF.bd_no;
         
         DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
         
         OPEN cursor1;
         
         my_loop : LOOP
            
            FETCH cursor1 INTO seq,realname,savename;
            
            SET total = (SELECT 
                            COUNT(*)
                            FROM (SELECT bd_no FROM rapa2013.frame_board_trend) bt, rapa2013.FRAME_BOARD_FILE BF 
                            WHERE BF.bc_no = token AND BF.bd_no = bt.bd_no);
            
            IF done THEN LEAVE my_loop;
            END IF;
            
            IF(seq != che) then
                SET file_id = file_id + 1;
                INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,0
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1)); 
                    SET countt = 0;
                ELSEIF(seq = che) then
                    SET countt = countt + 1;
                    INSERT INTO T_ATCH_FILE_DETAIL (ATCH_FILE_ID,FILE_SN,FILE_STRE_COURS,STRE_FILE_NM,ORIGN_FILE_NM,FILE_EXTSN)
                    VALUES( 
                    (SELECT CONCAT(TABLE_NAME,LPAD(NEXT_ID + file_id,16,'0')) FROM T_IDS WHERE TABLE_NAME = "FILE")
                    ,countt
                    ,'C:\\ips_attch\\attach\\rapa'
                    ,savename
                    ,realname
                    ,SUBSTRING_INDEX(savename,'.',-1));
                        
            END IF;
            SET che = seq;
              
        END LOOP;
        CLOSE cursor1;
    END//
DELIMITER ;

-- 테이블 isp.t_accs_ip 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_accs_ip` (
  `ACCS_SEQ` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `ACCS_IP` varchar(16) DEFAULT NULL COMMENT '접근IP',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RVSE_DT` timestamp NULL DEFAULT NULL COMMENT '수정일',
  `RVSE_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용여부',
  `PER_YN` varchar(1) DEFAULT 'Y' COMMENT '허용여부',
  PRIMARY KEY (`ACCS_SEQ`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='접근IP 관리';

-- 테이블 데이터 isp.t_accs_ip:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_accs_ip` DISABLE KEYS */;
INSERT IGNORE INTO `t_accs_ip` (`ACCS_SEQ`, `ACCS_IP`, `RGST_DT`, `RGST_ID`, `RVSE_DT`, `RVSE_ID`, `USE_YN`, `PER_YN`) VALUES
	(1, '123.12.213.13', '2020-02-05 16:46:13', '1', '2020-02-05 17:06:37', '1', 'Y', 'Y'),
	(2, '0.0.0.0', '2020-02-05 17:06:54', '1', NULL, NULL, 'Y', 'N');
/*!40000 ALTER TABLE `t_accs_ip` ENABLE KEYS */;

-- 테이블 isp.t_ad_user 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_ad_user` (
  `SEQ` int(11) NOT NULL COMMENT '일련번호',
  `ID` varchar(20) DEFAULT NULL COMMENT '아이디',
  `PWD` varchar(100) DEFAULT NULL COMMENT '비밀번호',
  `NAME` varchar(30) DEFAULT NULL COMMENT '이름',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용유무',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RGST_DT` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RVSE_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `RVSE_DT` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '수정일',
  `AUTH_CODE` varchar(20) DEFAULT NULL COMMENT '권한코드',
  `EMAIL` varchar(100) DEFAULT NULL COMMENT '메일',
  `TEL` varchar(20) DEFAULT NULL COMMENT '전화번호',
  `HP` varchar(20) DEFAULT NULL COMMENT '핸드폰',
  `ATCH_FILE_ID` varchar(20) DEFAULT NULL COMMENT '첨부파일',
  `LAST_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '최종접속일',
  `DPRT` varchar(50) DEFAULT NULL COMMENT '부서',
  `EXTNS_NMBR` varchar(15) DEFAULT NULL COMMENT '내선번호',
  `SITE_CLCD` varchar(50) DEFAULT NULL COMMENT '사이트구분',
  `FAIL_CNT` int(11) DEFAULT 0 COMMENT '로그인실패횟수',
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='관리자관리';

-- 테이블 데이터 isp.t_ad_user:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_ad_user` DISABLE KEYS */;
INSERT IGNORE INTO `t_ad_user` (`SEQ`, `ID`, `PWD`, `NAME`, `USE_YN`, `RGST_ID`, `RGST_DT`, `RVSE_ID`, `RVSE_DT`, `AUTH_CODE`, `EMAIL`, `TEL`, `HP`, `ATCH_FILE_ID`, `LAST_DATE`, `DPRT`, `EXTNS_NMBR`, `SITE_CLCD`, `FAIL_CNT`) VALUES
	(1, 'ispadm', '0FFE1ABD1A08215353C233D6E009613E95EEC4253832A761AF28FF37AC5A150C', '관리자', 'Y', NULL, '2020-01-21 15:25:58', '1', '2020-06-10 17:19:27', '1', '', '', '', ' ', '2020-08-03 15:38:10', '010101', '', 'rapa', 1),
	(2, 'mailTest1', '39743FFCFB179CEBA590B68FFF1A7C65A9DB72B3A5AD63EE01A66C6896A07311', 'mailTest1', 'Y', NULL, '2020-02-06 09:30:21', '1', '2020-05-20 14:16:39', '1', 'thank5214@naver.com', '1111', '1111', '', '0000-00-00 00:00:00', '', '', NULL, 0),
	(3, 'mailTest2', '39743FFCFB179CEBA590B68FFF1A7C65A9DB72B3A5AD63EE01A66C6896A07311', 'mailTest2', 'Y', NULL, '2020-02-06 09:31:21', '1', '2020-05-20 14:16:53', '1', 'khn5214@nate.com', '1111', '1111', '', '0000-00-00 00:00:00', '', '', NULL, 0),
	(4, 'mailTest3', '39743FFCFB179CEBA590B68FFF1A7C65A9DB72B3A5AD63EE01A66C6896A07311', 'mailTest3', 'Y', NULL, '2020-02-06 09:31:51', '1', '2020-05-20 14:17:02', '1', 'khn5214@gmail.com', '1111', '1111', '', '0000-00-00 00:00:00', '', '', NULL, 0),
	(5, 'admin', '0FFE1ABD1A08215353C233D6E009613E95EEC4253832A761AF28FF37AC5A150C', '사용자1', 'Y', NULL, '2020-05-08 12:54:15', '1', '2020-05-20 10:52:15', '1', 'thank5214@naver.com', '0101111111', '1231232222222', '', '0000-00-00 00:00:00', '', '', NULL, 0);
/*!40000 ALTER TABLE `t_ad_user` ENABLE KEYS */;

-- 테이블 isp.t_ad_user_auth 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_ad_user_auth` (
  `SEQ` int(11) NOT NULL COMMENT '일련번호',
  `AUTH_CODE` varchar(20) DEFAULT NULL COMMENT '권한그룹코드',
  `AUTH_CODE_NM` varchar(20) DEFAULT NULL COMMENT '권한그룹명',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RVSE_DT` timestamp NULL DEFAULT NULL COMMENT '수정일',
  `RVSE_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용여부',
  `CTT` varchar(1000) DEFAULT NULL COMMENT '설명',
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='권한그룹관리';

-- 테이블 데이터 isp.t_ad_user_auth:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_ad_user_auth` DISABLE KEYS */;
INSERT IGNORE INTO `t_ad_user_auth` (`SEQ`, `AUTH_CODE`, `AUTH_CODE_NM`, `RGST_DT`, `RGST_ID`, `RVSE_DT`, `RVSE_ID`, `USE_YN`, `CTT`) VALUES
	(1, '1', '전체관리자', '2020-01-21 15:34:31', NULL, '2020-08-03 17:06:52', '1', 'Y', '');
/*!40000 ALTER TABLE `t_ad_user_auth` ENABLE KEYS */;

-- 테이블 isp.t_ad_user_auth_menu 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_ad_user_auth_menu` (
  `ID` varchar(20) NOT NULL COMMENT '아이디',
  `MENU_SEQ` int(11) NOT NULL COMMENT '메뉴일련번호',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  PRIMARY KEY (`ID`,`MENU_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='권한메뉴관리';

-- 테이블 데이터 isp.t_ad_user_auth_menu:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_ad_user_auth_menu` DISABLE KEYS */;
INSERT IGNORE INTO `t_ad_user_auth_menu` (`ID`, `MENU_SEQ`, `RGST_DT`, `RGST_ID`) VALUES
	('1', 35, '2020-08-03 17:06:52', '1'),
	('1', 240, '2020-08-03 17:06:52', '1'),
	('1', 262, '2020-08-03 17:06:52', '1'),
	('1', 267, '2020-08-03 17:06:52', '1'),
	('1', 268, '2020-08-03 17:06:52', '1'),
	('1', 320, '2020-08-03 17:06:52', '1'),
	('1', 321, '2020-08-03 17:06:52', '1');
/*!40000 ALTER TABLE `t_ad_user_auth_menu` ENABLE KEYS */;

-- 테이블 isp.t_atch_file 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_atch_file` (
  `ATCH_FILE_ID` varchar(20) NOT NULL COMMENT '첨부파일 아이디',
  `USE_YN` varchar(1) NOT NULL DEFAULT 'Y' COMMENT '사용여부',
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp() COMMENT '등록일시',
  `REG_ID` varchar(20) DEFAULT NULL COMMENT '등록자 아이디',
  PRIMARY KEY (`ATCH_FILE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='첨부파일관리';

-- 테이블 데이터 isp.t_atch_file:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_atch_file` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_atch_file` ENABLE KEYS */;

-- 테이블 isp.t_atch_file_detail 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_atch_file_detail` (
  `SEQ` int(11) NOT NULL AUTO_INCREMENT COMMENT '일련번호',
  `ATCH_FILE_ID` varchar(20) NOT NULL COMMENT '첨부파일 아이디',
  `FILE_SN` int(11) NOT NULL COMMENT '파일 순번',
  `FILE_STRE_COURS` varchar(200) DEFAULT NULL COMMENT '물리 파일 경로',
  `STRE_FILE_NM` varchar(100) DEFAULT NULL COMMENT '물리 파일 명',
  `ORIGN_FILE_NM` varchar(100) DEFAULT NULL COMMENT '실제 파일 명',
  `FILE_EXTSN` varchar(10) DEFAULT NULL COMMENT '확장자',
  `FILE_CN` longtext DEFAULT NULL COMMENT '파일 내용',
  `FILE_SIZE` varchar(50) DEFAULT NULL COMMENT '파일 크기',
  `FILE_TYPE` varchar(80) DEFAULT NULL COMMENT '파일 타입',
  `DEL_YN` varchar(1) NOT NULL DEFAULT 'N' COMMENT '삭제 여부',
  `REG_DATE` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `REG_ID` varchar(20) DEFAULT NULL COMMENT '등록자 ',
  `IMAGE_WIDTH` int(11) DEFAULT 0 COMMENT '이미지 넓이',
  `IMAGE_HEIGHT` int(11) DEFAULT 0 COMMENT '이미지 높이',
  `ATCH_FILE` blob DEFAULT NULL,
  `PARENT_SEQ` int(11) DEFAULT NULL COMMENT '글 일련번호',
  `FILE_IMSI` varchar(1) DEFAULT NULL COMMENT '파일임시여부',
  PRIMARY KEY (`SEQ`,`ATCH_FILE_ID`,`FILE_SN`,`DEL_YN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='첨부파일 상세관리';

-- 테이블 데이터 isp.t_atch_file_detail:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_atch_file_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_atch_file_detail` ENABLE KEYS */;

-- 테이블 isp.t_board 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_board` (
  `BOARD_SEQ` int(11) NOT NULL COMMENT '일련번호',
  `BOARD_GRP_SEQ` int(110) DEFAULT NULL COMMENT '그룹일련번호',
  `SITE_CLCD` varchar(1000) DEFAULT NULL COMMENT '사이트구분코드',
  `TITLE` varchar(600) DEFAULT NULL COMMENT '제목',
  `CONT` longtext DEFAULT NULL COMMENT '내용',
  `ATCH_FILE_ID` varchar(20) DEFAULT NULL COMMENT '첨부파일ID',
  `IMAGE_FILE_ID` varchar(20) DEFAULT NULL COMMENT '이미지첨부파일ID',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RVSE_DT` timestamp NULL DEFAULT NULL COMMENT '수정일',
  `RVSE_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용여부',
  `NOTI_YN` varchar(1) DEFAULT 'N' COMMENT '공지여부',
  `NOTI_ST_DT` timestamp NULL DEFAULT NULL COMMENT '공지시작일',
  `NOTI_END_DT` timestamp NULL DEFAULT NULL COMMENT '공지종료일',
  `BOARD_CD` varchar(20) DEFAULT NULL COMMENT '게시판코드',
  `BOARD_DIVN` varchar(20) DEFAULT NULL COMMENT '게시판구분',
  `VIEW_NUM` int(11) DEFAULT 0 COMMENT '조회수',
  `SECRET_YN` varchar(1) DEFAULT 'N' COMMENT '비밀글여부',
  `ACPT_ST_DT` timestamp NULL DEFAULT NULL COMMENT '접수시작일자',
  `ACPT_END_DT` timestamp NULL DEFAULT NULL COMMENT '접수종료일자',
  `YEAR` varchar(4) DEFAULT NULL COMMENT '년도',
  PRIMARY KEY (`BOARD_SEQ`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='게시판관리';

-- 테이블 데이터 isp.t_board:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_board` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_board` ENABLE KEYS */;

-- 테이블 isp.t_exception 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_exception` (
  `SEQ` int(11) NOT NULL COMMENT '일련번호',
  `ERR_TYPE` varchar(500) DEFAULT NULL COMMENT '에러타입',
  `ERR_MSG` varchar(4000) DEFAULT NULL COMMENT '에러메세지',
  `FULL_ERR_MSG` longtext DEFAULT NULL COMMENT '전체에러메세지',
  `PARAM_VAL` varchar(4000) DEFAULT NULL COMMENT '파라미터',
  `ERR_MENU_CD` varchar(20) DEFAULT NULL COMMENT '메뉴코드',
  `ERR_PAGE` varchar(500) DEFAULT NULL COMMENT '에러페이지',
  `ERR_PAGE_URL` varchar(500) DEFAULT NULL COMMENT '에러페이지URL',
  `REG_DATE` timestamp NULL DEFAULT current_timestamp() COMMENT '에러발생일',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용여부',
  `IP` varchar(100) DEFAULT NULL COMMENT 'IP',
  `REG_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='에러관리';

-- 테이블 데이터 isp.t_exception:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_exception` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_exception` ENABLE KEYS */;

-- 테이블 isp.t_ft_user 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_ft_user` (
  `SEQ` int(11) NOT NULL COMMENT '일련번호',
  `ID` varchar(20) DEFAULT NULL COMMENT '아이디',
  `PWD` varchar(100) DEFAULT NULL COMMENT '비밀번호',
  `NAME` varchar(30) DEFAULT NULL COMMENT '이름',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용유무',
  `REG_ID` varchar(20) DEFAULT NULL COMMENT '작성자',
  `REG_DATE` timestamp NOT NULL DEFAULT current_timestamp(),
  `MOD_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `MOD_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '수정일',
  `SITE_CLCD` varchar(20) DEFAULT NULL COMMENT '사이트구분코드',
  `EMAIL` varchar(100) DEFAULT NULL COMMENT '메일',
  `TEL` varchar(20) DEFAULT NULL COMMENT '전화번호',
  `HP` varchar(20) DEFAULT NULL COMMENT '핸드폰',
  `ATCH_FILE_ID` varchar(20) DEFAULT NULL COMMENT '첨부파일',
  `LAST_DATE` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '최종접속일',
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='통합회원관리';

-- 테이블 데이터 isp.t_ft_user:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_ft_user` DISABLE KEYS */;
INSERT IGNORE INTO `t_ft_user` (`SEQ`, `ID`, `PWD`, `NAME`, `USE_YN`, `REG_ID`, `REG_DATE`, `MOD_ID`, `MOD_DATE`, `SITE_CLCD`, `EMAIL`, `TEL`, `HP`, `ATCH_FILE_ID`, `LAST_DATE`) VALUES
	(1, '1232', 'CF0F29A894FC6868B15C3B5A751C47ED66A0C4F7D423EDD9B24BDF8CF1DF12BD', '12', 'N', NULL, '2020-02-06 17:11:24', '1', '2020-03-10 18:12:18', '', 'test@naver.com', '02-1234-12', '011-1234-1234', 'FILE0000000000000031', '0000-00-00 00:00:00'),
	(2, 'qwer1234', '0EE9796A41CCBE88EB774461DAC94A83D34959FEFA3BB4603C88B53FCAD0B1FE', '김길현', 'Y', NULL, '2020-03-18 18:29:20', '1', '2020-03-18 18:30:45', '', 'dbsqhtjs@naver.com', '0621234567', '010-7984-1184', '', '0000-00-00 00:00:00'),
	(3, 'qazwsx123', '0EE9796A41CCBE88EB774461DAC94A83D34959FEFA3BB4603C88B53FCAD0B1FE', '홍길동', 'Y', NULL, '2020-03-18 18:30:11', '1', '2020-03-18 18:30:28', '', 'gildong@naver.com', '024587915', '010-1548-1987', '', '0000-00-00 00:00:00'),
	(4, 'dbwjd1004', '0EE9796A41CCBE88EB774461DAC94A83D34959FEFA3BB4603C88B53FCAD0B1FE', '최유정', 'Y', NULL, '2020-03-18 18:32:09', NULL, '0000-00-00 00:00:00', '', 'dbwjd1004@gmail.com', '024517789', '010-4781-3571', NULL, '0000-00-00 00:00:00');
/*!40000 ALTER TABLE `t_ft_user` ENABLE KEYS */;

-- 테이블 isp.t_ids 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_ids` (
  `TABLE_NAME` varchar(20) NOT NULL COMMENT '테이블명',
  `NEXT_ID` int(11) NOT NULL DEFAULT 0 COMMENT '순번',
  PRIMARY KEY (`TABLE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='idgen';

-- 테이블 데이터 isp.t_ids:~3 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_ids` DISABLE KEYS */;
INSERT IGNORE INTO `t_ids` (`TABLE_NAME`, `NEXT_ID`) VALUES
	('CNTNT', 130),
	('FILE', 4073),
	('TYPE', 381);
/*!40000 ALTER TABLE `t_ids` ENABLE KEYS */;

-- 테이블 isp.t_log 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_log` (
  `LOG_SEQ` int(11) NOT NULL COMMENT '일련번호',
  `CLIENT_IP` varchar(100) DEFAULT NULL COMMENT '아이피',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `LOG_DIVN` varchar(5) DEFAULT NULL COMMENT '로그구분',
  `IP_ERR_YN` varchar(1) DEFAULT 'N' COMMENT 'ip오류 여부',
  PRIMARY KEY (`LOG_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='로그관리';

-- 테이블 데이터 isp.t_log:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_log` DISABLE KEYS */;
INSERT IGNORE INTO `t_log` (`LOG_SEQ`, `CLIENT_IP`, `RGST_ID`, `RGST_DT`, `LOG_DIVN`, `IP_ERR_YN`) VALUES
	(1, '0:0:0:0:0:0:0:1', '1', '2020-08-03 15:20:59', 'ma', 'N'),
	(2, '0:0:0:0:0:0:0:1', '1', '2020-08-03 15:22:55', 'ma', 'N'),
	(3, '0:0:0:0:0:0:0:1', '1', '2020-08-03 15:24:17', 'ma', 'N'),
	(4, '0:0:0:0:0:0:0:1', '1', '2020-08-03 15:30:47', 'ma', 'N'),
	(5, '0:0:0:0:0:0:0:1', '1', '2020-08-03 15:38:10', 'ma', 'N');
/*!40000 ALTER TABLE `t_log` ENABLE KEYS */;

-- 테이블 isp.t_menu_info 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_menu_info` (
  `MENU_SEQ` int(11) NOT NULL COMMENT '일련번호',
  `MENU_GROUP_SEQ` int(11) NOT NULL COMMENT '그룹일련번호',
  `LVL` int(11) DEFAULT NULL COMMENT '레벨',
  `NO` int(11) DEFAULT NULL COMMENT '순번',
  `MENU_NM` varchar(200) DEFAULT NULL COMMENT '메뉴명',
  `MENU_CD` varchar(20) DEFAULT NULL COMMENT '메뉴코드',
  `URL` varchar(500) DEFAULT NULL COMMENT 'URL',
  `MENU_CL` varchar(2) DEFAULT NULL COMMENT '메뉴구분',
  `DESCRIPTION` varchar(100) DEFAULT NULL COMMENT '설명',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(20) DEFAULT NULL COMMENT '등록자',
  `RVSE_DT` timestamp NULL DEFAULT NULL COMMENT '수정일',
  `RVSE_ID` varchar(20) DEFAULT NULL COMMENT '수정자',
  `USE_YN` varchar(1) DEFAULT 'Y' COMMENT '사용여부',
  `BOARD_CL` varchar(20) DEFAULT NULL COMMENT '게시판구분',
  `ICON_CL` varchar(20) DEFAULT NULL COMMENT '아이콘분류',
  PRIMARY KEY (`MENU_SEQ`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='메뉴관리';

-- 테이블 데이터 isp.t_menu_info:~12 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_menu_info` DISABLE KEYS */;
INSERT IGNORE INTO `t_menu_info` (`MENU_SEQ`, `MENU_GROUP_SEQ`, `LVL`, `NO`, `MENU_NM`, `MENU_CD`, `URL`, `MENU_CL`, `DESCRIPTION`, `RGST_DT`, `RGST_ID`, `RVSE_DT`, `RVSE_ID`, `USE_YN`, `BOARD_CL`, `ICON_CL`) VALUES
	(34, 240, 2, 6, '로그분석', 'log', '/ma/sys/log/list.do', 'ma', '', NULL, '', '2020-01-30 11:06:56', '1', 'N', NULL, ''),
	(35, 240, 2, 1, '메뉴관리', 'mn', '/ma/sys/mn/list.do', 'ma', '', NULL, '', NULL, 'admin', 'Y', '', ''),
	(240, 240, 1, 0, '시스템 ', 'sys', '/ma/sys/mn/list.do', 'ma', '', NULL, 'admin', '2020-03-09 17:35:12', '1', 'Y', NULL, ''),
	(262, 262, 1, 1, '사용자', 'us', '/ma/us/mm/list.do', 'ma', '', '2020-01-29 17:15:11', '1', NULL, NULL, 'Y', NULL, NULL),
	(267, 262, 2, 1, '관리자', 'mm', '/ma/us/mm/list.do', 'ma', '', '2020-01-29 17:17:30', '1', NULL, NULL, 'Y', NULL, NULL),
	(268, 262, 2, 2, '권한관리', 'au', '/ma/us/au/list.do', 'ma', '', '2020-01-29 17:17:48', '1', NULL, NULL, 'Y', NULL, NULL),
	(314, 240, 2, 5, '접속통계', 'cs', '/ma/sys/cs/list.do', 'ma', '', '2020-01-30 11:11:44', '1', NULL, NULL, 'N', NULL, NULL),
	(315, 240, 2, 7, '접근 IP', 'ip', '/ma/sys/ip/list.do', 'ma', '', '2020-01-30 11:12:16', '1', NULL, NULL, 'N', NULL, NULL),
	(318, 34, 3, 1, '접속로그', 'log01', '/ma/sys/log/log01/list.do', 'ma', '', '2020-01-30 11:19:17', '1', NULL, NULL, 'Y', NULL, NULL),
	(319, 34, 3, 2, '에러로그', 'log02', '/ma/sys/log/log02/list.do', 'ma', '', '2020-01-30 11:19:38', '1', NULL, NULL, 'Y', NULL, NULL),
	(320, 320, 1, 3, '샘플게시판', 'sam', '/ma/sam/sample/list.do', 'ma', '', '2020-08-03 17:01:29', '1', NULL, NULL, 'Y', NULL, NULL),
	(321, 320, 2, 1, '샘플게시판', 'sample', '/ma/sam/sample/list.do', 'ma', '', '2020-08-03 17:06:46', '1', NULL, NULL, 'Y', NULL, NULL);
/*!40000 ALTER TABLE `t_menu_info` ENABLE KEYS */;

-- 테이블 isp.t_menu_log 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_menu_log` (
  `LOG_SEQ` int(11) NOT NULL AUTO_INCREMENT COMMENT '로그일련번호',
  `CLIENT_IP` varchar(50) DEFAULT NULL COMMENT '아이피',
  `MENU_URI` varchar(200) DEFAULT NULL COMMENT 'URI',
  `RGST_ID` varchar(50) DEFAULT NULL COMMENT '등록자',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `MENU_CL` varchar(50) DEFAULT NULL COMMENT '메뉴구분',
  PRIMARY KEY (`LOG_SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='메뉴로그';

-- 테이블 데이터 isp.t_menu_log:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_menu_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_menu_log` ENABLE KEYS */;

-- 테이블 isp.t_sample 구조 내보내기
CREATE TABLE IF NOT EXISTS `t_sample` (
  `SEQ` int(11) NOT NULL COMMENT '일련번호',
  `TITLE` varchar(50) DEFAULT NULL COMMENT '제목',
  `CONT` longtext DEFAULT NULL COMMENT '내용',
  `RGST_DT` timestamp NULL DEFAULT current_timestamp() COMMENT '등록일',
  `RGST_ID` varchar(50) DEFAULT NULL COMMENT '등록자',
  `RVSE_DT` timestamp NULL DEFAULT NULL COMMENT '수정일',
  `RVSE_ID` varchar(50) DEFAULT NULL COMMENT '수정자',
  `USE_YN` varchar(50) DEFAULT 'Y' COMMENT '사용여부',
  `ATCH_FILE_ID` varchar(50) DEFAULT NULL COMMENT '첨부파일 아이디',
  `STA_DATE` timestamp NULL DEFAULT NULL COMMENT '시작일',
  `END_DATE` timestamp NULL DEFAULT NULL COMMENT '종료일',
  `ALP3` varchar(50) DEFAULT NULL COMMENT '국가코드',
  `NOTI_YN` varchar(50) DEFAULT NULL COMMENT '노출여부',
  `HP` varchar(50) DEFAULT NULL COMMENT '핸드폰',
  `MAIL` varchar(50) DEFAULT NULL COMMENT '이메일',
  PRIMARY KEY (`SEQ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='샘플게시판';

-- 테이블 데이터 isp.t_sample:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `t_sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_sample` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

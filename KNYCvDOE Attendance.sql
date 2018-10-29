/*

Title: KIPP NYC vs. District vs. Co-Located Schools Attendance
Created By: Malik
Last Updated: 10/25/18
Summary: Pulls KIPP NYC, District, and Co-Located Schools daily attendance to contrast.

*/

/*---Begin Query---*/

/*
- Pulls KIPP Attendance & sets CASE statements where the abbreviation of the school matches its designated district/Charter and 
  places values inside the created columns 'District'/'CoLocation_Code'
*/

SELECT kipp_attendance.*, district_attendance.avg_attendance as Dist_Attendance, colocate.avg_attendance AS colocated_attendance FROM
(SELECT SchoolName_Abbreviation, AttendanceDate, SchoolCalendarKEY, DailyAttendance, DailyEnrollment, DailyAbsence, PercentDailyAttendance * 100 as AttendancePercent,
		CASE WHEN SchoolName_Abbreviation = 'ACA ES' THEN '07'
			 WHEN SchoolName_Abbreviation = 'ACA MS' THEN '07'
			 WHEN SchoolName_Abbreviation = 'AMP ES' THEN '17'
			 WHEN SchoolName_Abbreviation = 'AMP MS' THEN '17'
			 WHEN SchoolName_Abbreviation = 'CPHS' THEN '07'
			 WHEN SchoolName_Abbreviation = 'FRE ES' THEN '10'
			 WHEN SchoolName_Abbreviation = 'FRE MS' THEN '12'
			 WHEN SchoolName_Abbreviation = 'INF ES' THEN '05'
			 WHEN SchoolName_Abbreviation = 'INF MS' THEN '05'
			 WHEN SchoolName_Abbreviation = 'STA H ES' THEN '05'
			 WHEN SchoolName_Abbreviation = 'STA H MS' THEN '05'
			 WHEN SchoolName_Abbreviation = 'WH ES' THEN '06'
			 WHEN SchoolName_Abbreviation = 'WH MS' THEN '06'
			ELSE ''
		END AS District,
			CASE WHEN SchoolName_Abbreviation = 'AMP ES' THEN 'AMP'
				 WHEN SchoolName_Abbreviation = 'AMP MS' THEN 'AMP'
				 WHEN SchoolName_Abbreviation = 'INF ES' THEN 'INF'
				 WHEN SchoolName_Abbreviation = 'INF MS' THEN 'INF'
				 WHEN SchoolName_Abbreviation = 'STA H ES' THEN 'INF'		
					ELSE SchoolName_Abbreviation
		END AS CoLocation_Code
	FROM [dw].[DW_dimSchool] SCH
		JOIN [attendance].[DW_factAttendanceSchool] ATN ON ATN.SchoolKEY = SCH.SchoolKEY
	WHERE SchoolYear4Digit = 2018) kipp_attendance
	
/*
- Table is ended by being named 'kipp_attendance' and will return values from that table
----------------------------------------------------- 
- Joins records from the table (district_attendance)
- Column is being named 'avg_attendance'
- Date column being converted into typical date format (YYYY-MM-DD)
- Filters District codes used
*/
		LEFT JOIN (	
		SELECT DistrictCode, AVG(cast(ATTN_PCT as float)) as avg_attendance, 		
		DATEFROMPARTS(Left(Attn_Date_YMD,4),SUBSTRING(Attn_Date_YMD,5,2), RIGHT(Attn_Date_YMD,2)) as Date
		FROM [custom].[custom_doe_attendance] DOE
		WHERE DistrictCode in ('05','06','07','17', '10', '12')
		GROUP BY DistrictCode, DATEFROMPARTS(Left(Attn_Date_YMD,4),SUBSTRING(Attn_Date_YMD,5,2), RIGHT(Attn_Date_YMD,2))) district_attendance
		 ON district_attendance.Date = kipp_attendance.AttendanceDate AND kipp_attendance.District = district_attendance.DistrictCode
/*
- Table 'district_attendance' is named here and linked to created table above 'kipp_attendance'  on its AttendanceDate & DistrictCode values
*/
	LEFT JOIN
		(SELECT DATEFROMPARTS(Left(Attn_Date_YMD,4),SUBSTRING(Attn_Date_YMD,5,2), RIGHT(Attn_Date_YMD,2)) as Date, AVG(cast(ATTN_PCT as float)) as avg_attendance,
		CASE WHEN LOC_CODE = 'X031' THEN 'ACA MS'
		 WHEN LOC_CODE = 'X151' THEN 'ACA MS'
		 WHEN LOC_CODE = 'K354' THEN 'AMP'
		 WHEN LOC_CODE = 'X044' THEN 'FRE MS'
		 WHEN LOC_CODE = 'X341' THEN 'FRE MS'
		 WHEN LOC_CODE = 'M514' THEN 'INF'
		 WHEN LOC_CODE = 'M125' THEN 'STA H MS'
		 WHEN LOC_CODE = 'M362' THEN 'STA H MS'
		 WHEN LOC_CODE = 'M115' THEN 'WH ES'
		 WHEN LOC_CODE = 'M319' THEN 'WH MS'
	  -- WHEN LOC_CODE = '____' THEN 'WH MS'
		 WHEN LOC_CODE = 'M324' THEN 'WH MS'
		ELSE ''
		END AS CoLocation_Code
		FROM [custom].[custom_doe_attendance] 
		WHERE LOC_CODE in ('X031','X151','K354','X044', 'X341', 'M514', 'M125','M362','M115','M319', 'M321', 'M324') 
		GROUP BY DATEFROMPARTS(Left(Attn_Date_YMD,4),SUBSTRING(Attn_Date_YMD,5,2), RIGHT(Attn_Date_YMD,2)), 
		CASE WHEN LOC_CODE = 'X031' THEN 'ACA MS'
			 WHEN LOC_CODE = 'X151' THEN 'ACA MS'
			 WHEN LOC_CODE = 'K354' THEN 'AMP'
			 WHEN LOC_CODE = 'X044' THEN 'FRE MS'
			 WHEN LOC_CODE = 'X341' THEN 'FRE MS'
			 WHEN LOC_CODE = 'M514' THEN 'INF'
			 WHEN LOC_CODE = 'M125' THEN 'STA H MS'
			 WHEN LOC_CODE = 'M362' THEN 'STA H MS'
			 WHEN LOC_CODE = 'M115' THEN 'WH ES'
			 WHEN LOC_CODE = 'M319' THEN 'WH MS'
		   --WHEN LOC_CODE = 'M138' THEN 'WH MS'
			 WHEN LOC_CODE = 'M324' THEN 'WH MS'
			 ELSE '' END) colocate 
			 ON colocate.date = kipp_attendance.AttendanceDate AND colocate.CoLocation_Code = kipp_attendance.CoLocation_Code
			 ORDER By SchoolName_Abbreviation, AttendanceDate
/*--End of Query--*/

SELECT * FROM [custom].[custom_doe_attendance] DOE
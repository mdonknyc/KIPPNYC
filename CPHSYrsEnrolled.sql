/*

Title: CPHS 17-18 Years Enrolled
Created By: Malik
Last Updated: 10/29/18
Summary: Pulls group of CPHS students that were enrolled in the 2017-18 year along with how many years
they were enrolled at a KIPP school.

*/

SELECT StudentNumber, Lastfirst, COUNT(DISTINCT Academic_Year) AS YearsEnrolled
		FROM [custom].[custom_Student_Enrollment_Yearly]
		WHERE EnrollStatus = '0' 
			AND Academic_Year <> '2017 - 2018'
			AND GradeLevel in (9, 10, 11, 12)
		GROUP BY StudentNumber, Lastfirst
		ORDER BY Lastfirst


--Tables Used:
--SELECT * FROM [custom].[custom_Student_Enrollment_Yearly]
		
		

/*

Title: PSAT SAT Max Score For Tableau
Created By: Unkwown
Last Updated: 10/22/18
Summary: Pulls highest scores achieved on SAT Critical Reading and Math results, along with student demographics.

*/

Select 
S.SystemStudentID,
S.FullName,
S.PrimaryEthnicity,
S.Gender,
S.GradeLevel,
S.LunchStatus,
S.PrimaryDisability,
S.LanguageFluency,
S.Cohort,
S.EnrollmentStatus,
CS.Enroll_Status,
CS.Graduated_SchoolID,
T.TestSubType,
CASE
	WHEN T.TestName='Math' then 'SAT Math'
	WHEN T.TestName='EBRW' then 'SAT Critical Reading'
	ELSE T.TestName END As TestName,
T.TestSubjectGroup,
Max(TS.TestScore)as MaxScore,
PSATMax.PSATMaxScore,
MAPR.MAPReadingMax,
MAPM.MAPMathMax,
NYSELA.ProfRating as NYSELA8,
NYSMath.ProfRating as NYSMath8,
CASE 
	WHEN T.TestName='SAT Critical Reading' and Max(TS.TestScore)>=500 THEN 'Reading 500+' 
	WHEN T.TestName='SAT Critical Reading' and Max(TS.TestScore)< 500 THEN 'Reading Below 500' 
	ELSE 'NA' END AS ReadingAtAbove500,
CASE 
	WHEN T.TestName='SAT Math' and Max(TS.TestScore)>=500 THEN 'Math 500+' 
	WHEN T.TestName='SAT Math' and Max(TS.TestScore)< 500 THEN 'Math Below 500' 
	ELSE 'NA' END AS MathAtAbove500

From 
dw.DW_factTestScores TS
LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY =TS.StudentKEY)
LEFT JOIN
	(Select
	SL.SystemStudentID,
	T.TestGradeLevel AS TestGradeLevel,
	TPL.ProficiencyLevel AS PerfLevel,
	TS.ProficiencyLevelScore AS ProfRating,
	TS.PercentileScore AS GrowthPercentile,
	TS.ScaleScore AS ScaleScore

FROM
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimSchool SCH ON (SCH.SchoolKEY= TS.SchoolKEY)
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimTestProficiencyLevel TPL ON (TPL.TestProficiencyLevelKEY = TS.TestProficiencyLevelKEY)
	LEFT JOIN dw.DW_dimStudent SL ON (SL.StudentKEY = TS.StudentKEY)
	LEFT JOIN dw.DW_dimSchoolCalendar SCAL ON (SCAL.SchoolCalendarKEY = TS.SchoolCalendarKEY)
	LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY=TS.StudentKEY)
Where
	T.TestSubType='NYSA' and T.TestGradeLevel='8th' and T.TestSubject='ELA')NYSELA on (NYSELA.SystemStudentID=S.SystemStudentID)


LEFT JOIN
	(Select
	SL.SystemStudentID,
	T.TestGradeLevel AS TestGradeLevel,
	TPL.ProficiencyLevel AS PerfLevel,
	TS.ProficiencyLevelScore AS ProfRating,
	TS.PercentileScore AS GrowthPercentile,
	TS.ScaleScore AS ScaleScore

FROM
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimSchool SCH ON (SCH.SchoolKEY= TS.SchoolKEY)
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimTestProficiencyLevel TPL ON (TPL.TestProficiencyLevelKEY = TS.TestProficiencyLevelKEY)
	LEFT JOIN dw.DW_dimStudent SL ON (SL.StudentKEY = TS.StudentKEY)
	LEFT JOIN dw.DW_dimSchoolCalendar SCAL ON (SCAL.SchoolCalendarKEY = TS.SchoolCalendarKEY)
	LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY=TS.StudentKEY)
Where
	T.TestSubType='NYSA' and T.TestGradeLevel='8th' and T.TestSubject='Math')NYSMath on (NYSMath.SystemStudentID=S.SystemStudentID)

LEFT JOIN 
	(SELECT
	MAPR.StudentID
	,Max(MAPR.TestRITScore) as MAPReadingMax
	FROM 
	test_nweamap.Test_NWEAMAP_MAPRawData MAPR
	WHERE
	MAPR.Grade='8' and MAPR.TermName LIKE 'Spring%' and MAPR.MeasurementScale ='Reading'
	GROUP BY
	MAPR.StudentID)MAPR ON (S.SystemStudentID=MAPR.StudentID) 

LEFT JOIN
	(SELECT
	MAPM.StudentID
	,Max(MAPM.TestRITScore) as MAPMathMax
	FROM 
	test_nweamap.Test_NWEAMAP_MAPRawData MAPM
	WHERE
	MAPM.Grade='8' and MAPM.TermName LIKE 'Spring%' and MAPM.MeasurementScale ='Mathematics'
	GROUP BY
	MAPM.StudentID)MAPM ON (S.SystemStudentID=MAPM.StudentID) 

LEFT JOIN 
	(Select
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup,
	Max(TS.TestScore)as PSATMaxScore
	From 
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
	Where
	T.TestSubType ='PSAT' and S.Cohort<>'2013' and (T.TestName='PSAT Critical Reading' or T.TestName='PSAT Math')
	or T.TestSubType ='PSAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')
	GROUP BY 
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup)PSATMax on (PSATMax.SystemStudentID=S.SystemStudentID and PSATMax.TestSubjectGroup=T.TestSubjectGroup)
	Where
	TestSubType ='SAT' AND  S.Cohort<>'2013' and (T.TestName='SAT Critical Reading' or T.TestName='SAT Math')
or T.TestSubType ='SAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')



--(T.TestName='SAT Math' or
--T.TestName='SAT Writing' or 
--T.TestName='SAT Critical Reading' or
--T. TestName='SAT Reading and Math' or
--T.TestName='SAT Composite' or
--T.TestName='SAT Writing Multiple Choice' or
--T.TestName='SAT Writing Essay' or
--T.TestName='Math'or
--T.TestName='EBRW')
 

GROUP BY 
S.SystemStudentID,
S.FullName,
S.PrimaryEthnicity,
S.Gender,
S.GradeLevel,
S.LunchStatus,
S.PrimaryDisability,
S.LanguageFluency,
S.Cohort,
S.EnrollmentStatus,
CS.Enroll_Status,
CS.Graduated_SchoolID,
T.TestSubType,
T.TestName,
T.TestSubjectGroup,
PSATMax.PSATMaxScore,
MAPR.MAPReadingMax,
MAPM.MAPMathMax,
NYSELA.ProfRating,
NYSMath.ProfRating
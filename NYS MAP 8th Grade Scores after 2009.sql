Select Distinct
S.SystemStudentID,
S.FullName,
S.GradeLevel_Numeric,
S.Cohort,
S.SchoolYearExitDate,
S.EnrollmentStatus,
CS.Enroll_Status,
CS.Graduated_SchoolID,
CS.Graduated_SchoolName,
MAPR.MAPReadingMax,
MAPR.MAPReadingPercentile,
MAPM.MAPMathMax,
MAPM.MAPMathPercentile,
NYSELA.PerfLevel as NYSELA8PL,
NYSELA.ProfRating as NYSELA8,
NYSMath.PerfLevel as NYSMathPL,
NYSMath.ProfRating as NYSMath8

From 
dw.DW_factTestScores TS
LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY =TS.StudentKEY)
LEFT JOIN
--NYS ELA Query
	(Select
	SL.SystemStudentID,
	Max(TS.ProficiencyLevelScore) AS ProfRating,
	Max(TPL.ProficiencyLevel) AS PerfLevel
	--T.TestGradeLevel AS TestGradeLevel,
	--TS.PercentileScore AS GrowthPercentile,
	--TS.ScaleScore AS ScaleScore

FROM
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimSchool SCH ON (SCH.SchoolKEY= TS.SchoolKEY)
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimTestProficiencyLevel TPL ON (TPL.TestProficiencyLevelKEY = TS.TestProficiencyLevelKEY)
	LEFT JOIN dw.DW_dimStudent SL ON (SL.StudentKEY = TS.StudentKEY)
	LEFT JOIN dw.DW_dimSchoolCalendar SCAL ON (SCAL.SchoolCalendarKEY = TS.SchoolCalendarKEY)
	LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY=TS.StudentKEY)
Where
	T.TestSubType='NYSA' and T.TestGradeLevel='8th' and T.TestSubject='ELA' GROUP BY SL.SystemStudentID)
	--,TPL.ProficiencyLevel)
	NYSELA on (S.SystemStudentID=NYSELA.SystemStudentID)

LEFT JOIN
--NYS Math Query
	(Select
	SL.SystemStudentID,
	Max(TS.ProficiencyLevelScore) AS ProfRating,
	Max(TPL.ProficiencyLevel) AS PerfLevel
	--T.TestGradeLevel AS TestGradeLevel,
	--TS.PercentileScore AS GrowthPercentile,
	--TS.ScaleScore AS ScaleScore

FROM
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimSchool SCH ON (SCH.SchoolKEY= TS.SchoolKEY)
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimTestProficiencyLevel TPL ON (TPL.TestProficiencyLevelKEY = TS.TestProficiencyLevelKEY)
	LEFT JOIN dw.DW_dimStudent SL ON (SL.StudentKEY = TS.StudentKEY)
	LEFT JOIN dw.DW_dimSchoolCalendar SCAL ON (SCAL.SchoolCalendarKEY = TS.SchoolCalendarKEY)
	LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY=TS.StudentKEY)
Where
	T.TestSubType='NYSA' and T.TestGradeLevel='8th' and T.TestSubject='Math' GROUP BY SL.SystemStudentID)
	--,TPL.ProficiencyLevel)
	NYSMath on (S.SystemStudentID=NYSMath.SystemStudentID)

LEFT JOIN 
--MAP READING
	(SELECT
	MAPR.StudentID
	,Max(MAPR.TestRITScore) as MAPReadingMax
	,Max(MAPR.TestPercentile) as MAPReadingPercentile
	FROM 
	test_nweamap.Test_NWEAMAP_MAPRawData MAPR
	WHERE
	MAPR.Grade='8' and MAPR.TermName LIKE 'Spring%' and MAPR.MeasurementScale ='Reading'
	GROUP BY
	MAPR.StudentID)MAPR ON (S.SystemStudentID=MAPR.StudentID) 

LEFT JOIN
--MAP MATH 
	(SELECT
	MAPM.StudentID
	,Max(MAPM.TestRITScore) as MAPMathMax
	,Max(MAPM.TestPercentile) as MAPMathPercentile
	FROM 
	test_nweamap.Test_NWEAMAP_MAPRawData MAPM
	WHERE
	MAPM.Grade='8' and MAPM.TermName LIKE 'Spring%' and MAPM.MeasurementScale ='Mathematics'
	GROUP BY
	MAPM.StudentID)MAPM ON (S.SystemStudentID=MAPM.StudentID) 




Where
T.TestSubType ='NYSA' and CS.Graduated_SchoolName not like '%Elementary'and S.GradeLevel_Numeric>='9'
--and S.SystemStudentID='205867187'
--AND  S.Cohort<'2013' and (T.TestName='SAT Critical Reading' or T.TestName='SAT Math')
--or T.TestSubType ='SAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')


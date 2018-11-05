/*

Title: APT Data Pull 
Created By: Unkwown
Last Updated: 10/22/18
Summary: Pulls data that tracks academic progress across KIPP and NYS tests among students.

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
MAPR.MAPReadingMax,
MAPR.MAPReadingPercentile,
MAPM.MAPMathMax,
MAPM.MAPMathPercentile,
NYSELA.PerfLevel as NYSELA8PL,
NYSELA.ProfRating as NYSELA8,
NYSMath.PerfLevel as NYSMathPL,
NYSMath.ProfRating as NYSMath8,
MSIntAlgReg.MSIntAlgMaxScore as MSIntAlgRegentsScore,
MSAlgICCReg.MSAlg1CCRegentsScore as MSAlg1CCRegentsScore,
MSESReg.MSRegents_ESMaxScore as MSEarthSciRegentsScore,
MSLEReg.MSRegents_LEMaxScore as MSLivEnvRegentsScore,
PSATReadingMax.PSATReadingMaxScore,
PSATMathMax.PSATMathMaxScore,
Max( CASE WHEN S.Cohort <'2013' and T.TestName='SAT Critical Reading' or S.Cohort>='2013' and T.TestName='EBRW' THEN TS.TestScore ELSE NULL END)as SATReadingMaxScore,
Max( CASE WHEN S.Cohort <'2013' and T.TestName='SAT Math' or S.Cohort>='2013' and T.TestName='Math' THEN TS.TestScore ELSE NULL END )as SATMathMaxScore,
Max( CASE WHEN S.Cohort <'2013' and T.TestName='SAT Writing' THEN TS.TestScore ELSE NULL END )as SATWritingMaxScore


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
	NYSELA on (NYSELA.SystemStudentID=S.SystemStudentID)

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
	NYSMath on (NYSMath.SystemStudentID=S.SystemStudentID)

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

LEFT JOIN
--PSAT READING 
	(Select
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup,
	Max(TS.TestScore)as PSATReadingMaxScore
	From 
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
	Where
	T.TestSubType='PSAT' and S.Cohort<'2013' and T.TestName='PSAT Critical Reading' or T.TestSubType='PSAT' and S.Cohort>='2013' and T.TestName='EBRW'
	 --or T.TestName='PSAT Math')
	--or T.TestSubType ='PSAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')
	--and (T.TestName='PSAT Critical Reading' or T.TestName='EBRW') 
	GROUP BY 
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup)PSATReadingMax on (PSATReadingMax.SystemStudentID=S.SystemStudentID) 
	--and PSATReadingMax.TestSubjectGroup=T.TestSubjectGroup)

--PSAT Math
LEFT JOIN 
	(Select
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup,
	Max(TS.TestScore)as PSATMathMaxScore
	From 
	dw.DW_factTestScores TS
	LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
	LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
	Where
	T.TestSubType='PSAT' and S.Cohort<'2013' and T.TestName='PSAT Math' or T.TestSubType='PSAT' and S.Cohort>='2013' and T.TestName='Math'
	--T.TestSubType='PSAT' and (T.TestName='PSAT Math' or T.TestName='Math') 
	--and S.Cohort<>'2013' and (T.TestName='PSAT Critical Reading') or T.TestName='PSAT Math')
	--or T.TestSubType ='PSAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')
	GROUP BY 
	S.SystemStudentID,
	T.TestName,
	TestSubjectGroup)PSATMathMax on (PSATMathMax.SystemStudentID=S.SystemStudentID)
	--and PSATMathMax.TestSubjectGroup=T.TestSubjectGroup)

--MS Integrated Algebra Regents

LEFT JOIN(Select
S.SystemStudentID
,T.TestName
,Max(TS.TestScore) as MSIntAlgMaxScore
--,StuHist.GradeLevel as TestGradeLevel

FROM dw.DW_factTestScores TS 
LEFT JOIN dw.DW_dimTest T on TS.TestKey=T.TestKey
--LEFT JOIN custom.custom_dimStudent CS on  TS.StudentKEY=CS.StudentKEY
LEFT JOIN dw.DW_dimStudentHistorical StuHist on TS.StudentHistoricalKey=StuHist.StudentHistoricalKey
--LEFT JOIN powerschool.PowerSchool_STUDENTS PSS on TS.StudentKEY=PSS.ID
LEFT JOIN dw.DW_dimStudent S on TS.StudentKEY=S.StudentKey
--LEFT JOIN DW_dimSchool School on TS.SchoolKey=School.SchoolKey


Where
T.TestSubType ='NY Regents' and TS.TestScore <>0 and (StuHist.GradeLevel='8th' or StuHist.GradeLevel='7th') and (T.TestName= 'NY Regents Integrated Algebra') 

GROUP BY S.SystemStudentID,T.TestName,StuHist.GradeLevel)MSIntAlgReg on (MSIntAlgReg.SystemStudentID=S.SystemStudentID)


--MS Algebra I Common Core
LEFT JOIN(Select
S.SystemStudentID
,T.TestName
,Max(TS.TestScore) as MSAlg1CCRegentsScore
--,StuHist.GradeLevel as TestGradeLevel



FROM dw.DW_factTestScores TS 
LEFT JOIN dw.DW_dimTest T on TS.TestKey=T.TestKey
--LEFT JOIN custom.custom_dimStudent CS on  TS.StudentKEY=CS.StudentKEY
LEFT JOIN dw.DW_dimStudentHistorical StuHist on TS.StudentHistoricalKey=StuHist.StudentHistoricalKey
--LEFT JOIN powerschool.PowerSchool_STUDENTS PSS on TS.StudentKEY=PSS.ID
LEFT JOIN dw.DW_dimStudent S on TS.StudentKEY=S.StudentKey
--LEFT JOIN DW_dimSchool School on TS.SchoolKey=School.SchoolKey


Where
T.TestSubType ='NY Regents' and TS.TestScore <>0 and (StuHist.GradeLevel='8th' or StuHist.GradeLevel='7th') and (T.TestName= 'NY Regents Algebra I Common Core') 

GROUP BY S.SystemStudentID,T.TestName,StuHist.GradeLevel)MSAlgICCReg on (MSAlgICCReg.SystemStudentID=S.SystemStudentID)




--MSEarthSciRegents

LEFT JOIN(Select
S.SystemStudentID
,T.TestName
,Max(TS.TestScore) as MSRegents_ESMaxScore
--,StuHist.GradeLevel as TestGradeLevel

FROM dw.DW_factTestScores TS 
LEFT JOIN dw.DW_dimTest T on TS.TestKey=T.TestKey
--LEFT JOIN custom.custom_dimStudent CS on  TS.StudentKEY=CS.StudentKEY
LEFT JOIN dw.DW_dimStudentHistorical StuHist on TS.StudentHistoricalKey=StuHist.StudentHistoricalKey
--LEFT JOIN powerschool.PowerSchool_STUDENTS PSS on TS.StudentKEY=PSS.ID
LEFT JOIN dw.DW_dimStudent S on TS.StudentKEY=S.StudentKey
--LEFT JOIN DW_dimSchool School on TS.SchoolKey=School.SchoolKey


Where
T.TestSubType ='NY Regents' and TS.TestScore <>0 and (StuHist.GradeLevel='8th' or StuHist.GradeLevel='7th') and T.TestName like '%Earth Science%'

GROUP BY S.SystemStudentID,T.TestName,StuHist.GradeLevel)MSESReg on (MSESReg.SystemStudentID=S.SystemStudentID)

--MS Living Environment Regents

LEFT JOIN(Select
S.SystemStudentID
,T.TestName
,Max(TS.TestScore) as MSRegents_LEMaxScore
--,StuHist.GradeLevel as TestGradeLevel

FROM dw.DW_factTestScores TS 
LEFT JOIN dw.DW_dimTest T on TS.TestKey=T.TestKey
--LEFT JOIN custom.custom_dimStudent CS on  TS.StudentKEY=CS.StudentKEY
LEFT JOIN dw.DW_dimStudentHistorical StuHist on TS.StudentHistoricalKey=StuHist.StudentHistoricalKey
--LEFT JOIN powerschool.PowerSchool_STUDENTS PSS on TS.StudentKEY=PSS.ID
LEFT JOIN dw.DW_dimStudent S on TS.StudentKEY=S.StudentKey
--LEFT JOIN DW_dimSchool School on TS.SchoolKey=School.SchoolKey


Where
T.TestSubType ='NY Regents' and TS.TestScore <>0 and (StuHist.GradeLevel='8th' or StuHist.GradeLevel='7th') and T.TestName like '%Living Environment%'

GROUP BY S.SystemStudentID,T.TestName,StuHist.GradeLevel)MSLEReg on (MSLEReg.SystemStudentID=S.SystemStudentID)


Where
TestSubType ='SAT' 
--and S.SystemStudentID='205867187'
--AND  S.Cohort<'2013' and (T.TestName='SAT Critical Reading' or T.TestName='SAT Math')
--or T.TestSubType ='SAT' and S.Cohort>='2013' and (T.TestName='EBRW' or T.TestName='Math')

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
MAPR.MAPReadingMax,
MAPR.MAPReadingPercentile,
MAPM.MAPMathMax,
MAPM.MAPMathPercentile,
NYSELA.PerfLevel,
NYSELA.ProfRating,
NYSMath.PerfLevel,
NYSMath.ProfRating,
MSIntAlgReg.MSIntAlgMaxScore,
MSAlgICCReg.MSAlg1CCRegentsScore,
MSESReg.MSRegents_ESMaxScore,
MSLEReg.MSRegents_LEMaxScore,
PSATReadingMax.PSATReadingMaxScore,
PSATMathMax.PSATMathMaxScore

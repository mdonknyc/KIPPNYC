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
Max( CASE WHEN (S.Cohort <>'2013' and T.TestName='SAT Critical Reading') or (S.Cohort>='2013' and T.TestName='EBRW') THEN TS.TestScore ELSE NULL END)as ReadingMaxScore,
CASE WHEN Max( CASE WHEN (S.Cohort <>'2013' and T.TestName='SAT Critical Reading') or (S.Cohort>='2013' and T.TestName='EBRW') THEN TS.TestScore ELSE NULL END)>=480 THEN 1 ELSE 0 END as MetCUNYReading,
Max( CASE WHEN (S.Cohort <>'2013' and T.TestName='SAT Math') or (S.Cohort>='2013' and T.TestName='Math') THEN TS.TestScore ELSE NULL END )as MathMaxScore,
CASE WHEN Max( CASE WHEN (S.Cohort <>'2013' and T.TestName='SAT Math') or (S.Cohort>='2013' and T.TestName='Math') THEN TS.TestScore ELSE NULL END )>=480 THEN 1 ELSE 0 END as MetCUNYMath,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYC Public' THEN cast(comp.testscore as int) END) AS Reading_NYCPublic,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYC Black' THEN cast(comp.testscore as int) END) AS Reading_NYCBlack,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYC Hispanic' THEN cast(comp.testscore as int) END) AS Reading_NYCHispanic,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYC Public' THEN cast(comp.testscore as int) END) AS Math_NYCPublic,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYC Black' THEN cast(comp.testscore as int) END) AS Math_NYCBlack,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYC Hispanic' THEN cast(comp.testscore as int) END) AS Math_NYCHispanic,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYS Public' THEN cast(comp.testscore as int) END) AS Reading_NYSPublic,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYS Black' THEN cast(comp.testscore as int) END) AS Reading_NYSBlack,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='NYS Hispanic' THEN cast(comp.testscore as int) END) AS Reading_NYSHispanic,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYS Public' THEN cast(comp.testscore as int) END) AS Math_NYSPublic,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYS Black' THEN cast(comp.testscore as int) END) AS Math_NYSBlack,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='NYS Hispanic' THEN cast(comp.testscore as int) END) AS Math_NYSHispanic,
MAX( CASE WHEN Comp.TestName='SAT Math' AND Comp.Population='U.S.' THEN cast(comp.testscore as int) END) AS Math_US,
MAX( CASE WHEN Comp.TestName='SAT Critical Reading' AND Comp.Population='U.S.' THEN cast(comp.testscore as int) END) AS Reading_US,
'SAT' as'Test'

From 
dw.DW_factTestScores TS
LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY =TS.StudentKEY)
LEFT JOIN (
Select
TestSubType,
TestName,
Population,
TestScore
From
[custom].[custom_PSAT_SAT_Comparison]

Where
TestSubType='SAT'
--AND Population LIKE 'NYC%'
AND RIGHT(SchoolYear,4)=2016
AND TestName IN ('SAT Critical Reading','SAT Math')) AS Comp ON (Comp.TestSubType=T.TestSubType)

Where
T.TestSubType ='SAT' 
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
CS.Graduated_SchoolID
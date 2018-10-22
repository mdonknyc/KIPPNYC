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
Max( CASE WHEN S.Cohort <>'2013' and T.TestName='SAT Critical Reading' or S.Cohort>='2013' and T.TestName='EBRW' THEN TS.TestScore ELSE NULL END)as ReadingMaxScore,
Max( CASE WHEN S.Cohort <>'2013' and T.TestName='SAT Math' or S.Cohort>='2013' and T.TestName='Math' THEN TS.TestScore ELSE NULL END )as MathMaxScore,
'SAT' as'Test'

From 
dw.DW_factTestScores TS
LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY =TS.StudentKEY)

Where
TestSubType ='SAT' 
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

UNION
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
Max( CASE WHEN S.Cohort <>'2013' and T.TestName='PSAT Critical Reading' or S.Cohort>='2013' and T.TestName='EBRW' THEN TS.TestScore ELSE NULL END)as ReadingMaxScore,
Max( CASE WHEN S.Cohort <>'2013' and T.TestName='PSAT Math' or S.Cohort>='2013' and T.TestName='Math' THEN TS.TestScore ELSE NULL END )as MathMaxScore,
'PSAT' as'Test'

From 
dw.DW_factTestScores TS
LEFT JOIN dw.DW_dimTest T ON (T.TestKEY = TS.TestKEY)
LEFT JOIN dw.DW_dimStudent S ON (S.StudentKEY = TS.StudentKEY)
LEFT JOIN custom.custom_dimStudent CS ON (CS.StudentKEY =TS.StudentKEY)

Where
TestSubType ='PSAT' 
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
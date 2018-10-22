/*

Title: PSAT SAT Raw Data
Created By: Unkwown
Last Updated: 10/22/18
Summary: Pulls raw data for the PSAT/SATs. Extracts and creates aliases for column fields when pulling data.

*/

SELECT 
[DW_factTestScores].[ID] AS [ID],
[DW_factTestScores].[SZRowID] AS [SZRowID],
[DW_factTestScores].[SourceSystem] AS [SourceSystem],
[DW_factTestScores].[TestDate] AS [TestDate],
[DW_factTestScores].[TestScore] AS [TestScore],
--[DW_factTestScores].[RawScore] AS [RawScore],
[DW_factTestScores].[ScaleScore] AS [ScaleScore],
--[DW_factTestScores].[PercentScore] AS [PercentScore],
[DW_factTestScores].[PercentileScore] AS [PercentileScore],
--[DW_factTestScores].[ProficiencyLevelScore] AS [ProficiencyLevelScore],
--[DW_factTestScores].[PointsPossible] AS [PointsPossible],
[DW_dimSchoolCalendar].[FullDate] AS [FullDate],
[DW_dimSchoolCalendar].[SchoolYear] AS [SchoolYear],
[DW_dimSchoolCalendar].[SchoolYearShort] AS [SchoolYearShort],
[DW_dimSchoolCalendar].[SchoolYear4Digit] AS [SchoolYear4Digit],
[DW_dimSchoolCalendar].[SZRowID] AS [SZRowID (DW_dimSchoolCalendar)],
[DW_dimSchoolCalendar].[SourceSystem] AS [SourceSystem (DW_dimSchoolCalendar)],
--[DW_dimStaff].[SZRowID] AS [SZRowID (DW_dimStaff)],
--[DW_dimStaff].[SourceSystem] AS [SourceSystem (DW_dimStaff)],
--[DW_dimStaff].[ExternalStaffID] AS [ExternalStaffID],
[DW_dimStudent].[SystemStudentID] AS [SystemStudentID],
[DW_dimStudent].[FullName] AS [FullName],
[DW_dimStudent].[GradeLevel] AS [GradeLevel],
[DW_dimStudent].[Cohort] AS [Cohort],
[DW_dimStudent].[Gender] AS [Gender],
[DW_dimStudent].[PrimaryEthnicity] AS [PrimaryEthnicity],
[DW_dimStudent].[PrimaryEthnicGroup] AS [PrimaryEthnicGroup],
--[DW_dimStudent].[PrimaryLanguage] AS [PrimaryLanguage],
[DW_dimStudent].[LanguageFluency] AS [LanguageFluency],
[DW_dimStudent].[PrimaryDisability] AS [PrimaryDisability],
--[DW_dimStudent].[ParentEducationLevel] AS [ParentEducationLevel],
[DW_dimStudent].[LunchStatus] AS [LunchStatus],
[DW_dimStudent].[EnrollmentStatus] AS [EnrollmentStatus],
[DW_dimStudent].[GradeLevel_Numeric] AS [GradeLevel_Numeric],
[DW_dimStudent].[SZRowID] AS [SZRowID (DW_dimStudent)],
[DW_dimStudent].[SourceSystem] AS [SourceSystem (DW_dimStudent)],
--[DW_dimStudent].[ExternalStudentID] AS [ExternalStudentID],
[DW_dimStudent].[Standardized_Gender] AS [Standardized_Gender],
--[DW_dimStudent].[Standardized_PrimaryEthnicity] AS [Standardized_PrimaryEthnicity],
--[DW_dimStudent].[Standardized_LanguageFluency] AS [Standardized_LanguageFluency],
--[DW_dimStudent].[Standardized_PrimaryDisability] AS [Standardized_PrimaryDisability],
[DW_dimStudent].[Standardized_LunchStatus] AS [Standardized_LunchStatus],
[DW_dimStudentHistorical].[GradeLevel] AS [DW_dimStudentHistorical_GradeLevel],
[DW_dimTest].[TestKEY] AS [DW_dimTest_TestKEY],
[DW_dimTest].[CustID] AS [DW_dimTest_CustID],
[DW_dimTest].[FileID] AS [DW_dimTest_FileID],
[DW_dimTest].[LastUpdated] AS [DW_dimTest_LastUpdated],
[DW_dimTest].[SourceSystem] AS [SourceSystem (DW_dimTest)],
[DW_dimTest].[SystemTestID] AS [SystemTestID],
[DW_dimTest].[TestType] AS [TestType],
[DW_dimTest].[TestSubType] AS [TestSubType],
--[DW_dimTest].[TestPeriod] AS [TestPeriod],
[DW_dimTest].[TestSubjectGroup] AS [TestSubjectGroup],
[DW_dimTest].[TestSubject] AS [TestSubject],
[DW_dimTest].[TestGradeLevel] AS [TestGradeLevel],
[DW_dimTest].[TestName] AS [TestName],
[DW_dimTest].[TestScoreType] AS [TestScoreType],
[DW_dimTestFramework].[SourceSystem] AS [SourceSystem (DW_dimTestFramework)],
--[DW_dimTestFramework].[SystemFrameworkID] AS [SystemFrameworkID],
--[DW_dimTestFramework].[SubstandardName] AS [SubstandardName],
[DW_dimTestProficiencyLevel].[SourceSystem] AS [SourceSystem (DW_dimTestProficiencyLevel)],
--[DW_dimTestProficiencyLevel].[SystemProficiencyLevelID] AS [SystemProficiencyLevelID],
[DW_dimTestProficiencyLevel].[IsProficient] AS [IsProficient],
[DW_dimSchool].[SchoolName] AS [SchoolName],
[DW_dimSchool].[SchoolName_Abbreviation] AS [SchoolName_Abbreviation],
[DW_dimSchool].[SZRowID] AS [SZRowID (DW_dimSchool)],
[DW_dimSchool].[SourceSystem] AS [SourceSystem (DW_dimSchool)],
--[DW_dimSchool].[ExternalSchoolID] AS [ExternalSchoolID],
[custom_dimStudent].[StudentKEY] AS [StudentKEY (custom_dimStudent)],
[custom_dimStudent].[CustID] AS [CustID (custom_dimStudent)],
[custom_dimStudent].[SystemStudentID] AS [SystemStudentID (custom_dimStudent)],
[custom_dimStudent].[LastUpdated] AS [LastUpdated (custom_dimStudent)],
[custom_dimStudent].[Graduated_SchoolID] AS [Graduated_SchoolID],
[custom_dimStudent].[Graduated_SchoolName] AS [Graduated_SchoolName],
[custom_dimStudent].[IEP_Level_of_Service] AS [IEP_Level_of_Service],
[custom_dimStudent].[Home_Room] AS [Home_Room],
[custom_dimStudent].[DistrictEntryDate] AS [DistrictEntryDate],
[custom_dimStudent].[Enroll_Status] AS [Enroll_Status],
[custom_PSAT_SAT_Comparison].[TestSubType] AS [TestSubType (custom_PSAT_SAT_Comparison)],
[custom_PSAT_SAT_Comparison].[TestName] AS [TestName (custom_PSAT_SAT_Comparison)],
[custom_PSAT_SAT_Comparison].[Population] AS [Population],
[custom_PSAT_SAT_Comparison].[Grade_Level_Tested] AS [Grade_Level_Tested],
[custom_PSAT_SAT_Comparison].[SchoolYear] AS [SchoolYear (custom_PSAT_SAT_Comparison)],
[custom_PSAT_SAT_Comparison].[TestScore] AS [TestScore (custom_PSAT_SAT_Comparison)]

FROM [dw].[DW_factTestScores] [DW_factTestScores]
 LEFT JOIN [dw].[DW_dimSchoolCalendar] [DW_dimSchoolCalendar] ON ([DW_factTestScores].[SchoolCalendarKEY] = [DW_dimSchoolCalendar].[SchoolCalendarKEY])
 -- LEFT JOIN [dw].[DW_dimSchoolHistorical] [DW_dimSchoolHistorical] ON ([DW_factTestScores].[SchoolHistoricalKEY] = [DW_dimSchoolHistorical].[SchoolHistoricalKEY])
 -- LEFT JOIN [dw].[DW_dimStaff] [DW_dimStaff] ON ([DW_factTestScores].[StaffKEY] = [DW_dimStaff].[StaffKEY])
 -- LEFT JOIN [dw].[DW_dimStaffHistorical] [DW_dimStaffHistorical] ON ([DW_factTestScores].[StaffHistoricalKEY] = [DW_dimStaffHistorical].[StaffHistoricalKEY])
  LEFT JOIN [dw].[DW_dimStudent] [DW_dimStudent] ON ([DW_factTestScores].[StudentKEY] = [DW_dimStudent].[StudentKEY])
  LEFT JOIN [dw].[DW_dimStudentHistorical] [DW_dimStudentHistorical] ON ([DW_factTestScores].[StudentHistoricalKEY] = [DW_dimStudentHistorical].[StudentHistoricalKEY])
  LEFT JOIN [dw].[DW_dimTest] [DW_dimTest] ON ([DW_factTestScores].[TestKEY] = [DW_dimTest].[TestKEY])
  LEFT JOIN [dw].[DW_dimTestFramework] [DW_dimTestFramework] ON ([DW_factTestScores].[TestFrameworkKEY] = [DW_dimTestFramework].[TestFrameworkKEY])
  LEFT JOIN [dw].[DW_dimTestProficiencyLevel] [DW_dimTestProficiencyLevel] ON ([DW_factTestScores].[TestProficiencyLevelKEY] = [DW_dimTestProficiencyLevel].[TestProficiencyLevelKEY])
  LEFT JOIN [dw].[DW_dimSchool] [DW_dimSchool] ON ([DW_factTestScores].[SchoolKEY] = [DW_dimSchool].[SchoolKEY])
  LEFT JOIN [custom].[custom_dimStudent] [custom_dimStudent] ON ([DW_factTestScores].[StudentKEY] = [custom_dimStudent].[StudentKEY])
  LEFT JOIN [custom].[custom_PSAT_SAT_Comparison] [custom_PSAT_SAT_Comparison] ON (([DW_dimSchoolCalendar].[SchoolYear] = [custom_PSAT_SAT_Comparison].[SchoolYear]) AND ([DW_dimTest].[TestSubType] = [custom_PSAT_SAT_Comparison].[TestSubType]))

  
  where [DW_dimTest].[TestSubType]='SAT' or  [DW_dimTest].[TestSubType]='PSAT'
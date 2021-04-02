-- 1. First/last timestamps of recorded data
select ParticipantId, min(Formatted_time) as Max_TS, max(Formatted_time) as Min_TS
from survey_result
Where ParticipantId Is Not Null 
	And ParticipantId <> ''
group by ParticipantId;


-- 2. Number of records for each probe
select ParticipantId, Type, count(*) as Cnt
from survey_result
Where ParticipantId Is Not Null 
	And ParticipantId <> ''
group by ParticipantId, Type;

-- 3. Most frequent activity
Select ParticipantId, 
		Activity
From
	( Select  
			ParticipantId,
			Activity,
			Cnt,
			Row_Number() Over (Partition By ParticipantId Order By Cnt Desc) as Rnk
		From 
		(
			Select
				ParticipantId,
				Activity,
				Count(*) as Cnt
			From 
				sensus_survey.survey_result
			Where
				Activity Is Not Null
				And Activity <> ''
			Group By
				ParticipantId,
				Activity
		) R
	) Q
Where
	Rnk = 1;
    
-- 4. History of Battery level
Select 
	ParticipantId,
    Level as BatteryLevel,
    Formatted_time
From
	Survey_Result
Where
	Level Is Not Null
    And Level <> '';


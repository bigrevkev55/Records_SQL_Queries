Author:   Michael Rohling, Systems Analyst II
Date:     04-MAR-2019 (Edited by Kevin Thomas, Assistant Registrar 27-JUN-2019)
Purpsose: The query totals the amount of courses and meetings in rooms by terms.     

select  slbrdef_bldg_code bldg,
        slbrdef_room_number room,
        SLBRDEF.SLBRDEF_DESC description,
		(
			select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code = '201980'
		) as "Fall 2019",
		(
			select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code = '202010'
		) as "Spring 2020",
		(
			select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code = '202050'
		) As "Summer 2020",
    (select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code = '202080'
    )as "Fall 2020",
      
		(
			select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code = 'EVENT'
            and     SSRMEET_START_DATE >= :Today_s_Date
		) event,
		(
			select	count(*)
			from	ssrmeet
			where	ssrmeet_bldg_code = slbrdef_bldg_code
			and		ssrmeet_room_code = slbrdef_room_number
			and		ssrmeet_term_code >= '201950'
		) total
from	slbrdef
where	slbrdef_rmst_code <> 'IN'
       and slbrdef_capacity > '29'
       and slbrdef_bldg_code IN ('A','K', 'S','H','C','D','E','A','W' )
        
order by 1,2;

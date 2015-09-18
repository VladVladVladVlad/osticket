(
	select osticket.ost_staff.username as 'Staff Memebrs', count(*) as 'Open Tickets'
	from osticket.ost_staff inner join osticket.ost_ticket 
	on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id 
	and osticket.ost_ticket.status like 'open'
	and (
		osticket.ost_staff.username like 'AntonT' or osticket.ost_staff.username like 'Igor' 
		or osticket.ost_staff.username like 'Ildar.Sh'
		or osticket.ost_staff.username like 'Juli'
		or osticket.ost_staff.username like 'Pavel'
		or osticket.ost_staff.username like 'SergeyK'
		or osticket.ost_staff.username like 'Vladimir'
	)
	group by osticket.ost_staff.staff_id
	#order by osticket.ost_staff.username asc
)
union all
(
	select '`Total', count(*)
	from osticket.ost_staff inner join osticket.ost_ticket 
	on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id 
	and osticket.ost_ticket.status like 'open'
	and (
		osticket.ost_staff.username like 'AntonT' or osticket.ost_staff.username like 'Igor' 
		or osticket.ost_staff.username like 'Ildar.Sh'
		or osticket.ost_staff.username like 'Juli'
		or osticket.ost_staff.username like 'Pavel'
		or osticket.ost_staff.username like 'SergeyK'
		or osticket.ost_staff.username like 'Vladimir'
	)
)
order by 1;
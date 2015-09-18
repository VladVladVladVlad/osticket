select osticket.ost_staff.username, count(*) from osticket.ost_staff
inner join osticket.ost_ticket 
on osticket.ost_staff.staff_id = osticket.ost_ticket.staff_id and osticket.ost_ticket.status like 'open' group by osticket.ost_staff.staff_id;
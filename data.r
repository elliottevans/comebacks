# Script to find the greatest comebacks/crashes in baseball since
# the beginning of the expansion era (1961)
#
# -Elliott Evans

setwd('C:\\Users\\Elliott\\Documents\\fangraphs_comebacks')
library("sqldf", lib.loc="~/R/win-library/3.2")
hitting<-read.csv('hitting.csv')
pitching<-read.csv('pitching.csv')
names(hitting)[1]<-'season'
names(pitching)[1]<-'season'

comebacks<-sqldf(
"
select
	previous_WARs.playerid
	,previous_WARs.Name
	,previous_WARs.Team
	,previous_WARs.season as year
	,previous_WARs.WAR as this_year_WAR
	,h.WAR as previous_year_WAR
	,previous_WARs.previous_WAR_total
	,previous_WARs.previous_games
	,162*previous_WAR_total/previous_games as previous_WAR_per_162G
	,previous_WARs.WAR-h.WAR as marginal_WAR
from
(
	select
		h1.playerid
		,h1.Name
		,h1.Team as team
		,h1.season
		,h1.WAR
		,sum(h2.WAR) as previous_WAR_total
		,sum(h2.G) as previous_games
	from hitting h1
		inner join hitting h2 on h1.playerid=h2.playerid
			and h2.season<h1.season	
	group by h1.playerid,h1.season
) as previous_WARs
inner join hitting h
	on h.season=previous_WARs.season-1 and h.playerid=previous_WARs.playerid
where previous_games>=162
	and previous_WAR_per_162G>=3.0
	-- and marginal_WAR>=3
	and this_year_WAR>=5
	and previous_year_WAR<2.0
order by marginal_WAR desc
limit 50
",drv='SQLite'
)

crashes<-sqldf(
"
select
	previous_WARs.playerid
	,previous_WARs.Name
	,previous_WARs.team
	,previous_WARs.season as year
	,previous_WARs.WAR as this_year_WAR
	,h.WAR as previous_year_WAR
	,previous_WARs.previous_WAR_total
	,previous_WARs.previous_games
	,162*previous_WAR_total/previous_games as previous_WAR_per_162G
	,previous_WARs.WAR-h.WAR as marginal_WAR
from
(
	select
		h1.playerid
		,h1.Name
		,h1.season
		,h1.Team as team
		,h1.WAR
		,sum(h2.WAR) as previous_WAR_total
		,sum(h2.G) as previous_games
	from hitting h1
		inner join hitting h2 on h1.playerid=h2.playerid
			and h2.season<h1.season	
	group by h1.playerid,h1.season
) as previous_WARs
inner join hitting h
	on h.season=previous_WARs.season-1 and h.playerid=previous_WARs.playerid
where previous_games>=162
	and previous_WAR_per_162G>=3.0
	-- and marginal_WAR>=3
	and this_year_WAR<=1.0
	and previous_year_WAR>=2.0
order by marginal_WAR asc
limit 50
",drv='SQLite'
)

write.csv(comebacks,'comebacks_h.csv',row.names=TRUE)
write.csv(crashes,'crashes_h.csv',row.names=TRUE)

comebacks_p<-sqldf(
"
select
	previous_WARs.playerid
	,previous_WARs.Name
	,previous_WARs.Team
	,previous_WARs.season as year
	,previous_WARs.WAR as this_year_WAR
	,h.WAR as previous_year_WAR
	,previous_WARs.previous_WAR_total
	,previous_WARs.previous_IP
	,200*previous_WAR_total/previous_IP as previous_WAR_per_200IP
	,previous_WARs.WAR-h.WAR as marginal_WAR
from
(
	select
		p1.playerid
		,p1.Name
		,p1.Team as team
		,p1.season
		,p1.WAR
		,sum(p2.WAR) as previous_WAR_total
		,sum(p2.IP) as previous_IP
	from pitching p1
		inner join pitching p2 on p1.playerid=p2.playerid
			and p2.season<p1.season	
	group by p1.playerid,p1.season
) as previous_WARs
inner join pitching h
	on h.season=previous_WARs.season-1 and h.playerid=previous_WARs.playerid
where previous_IP>=200
	and previous_WAR_per_200IP>=3.0
	-- and marginal_WAR>=3
	and this_year_WAR>=4
	and previous_year_WAR<2.0
order by marginal_WAR desc
limit 50
",drv='SQLite'
)

crashes_p<-sqldf(
"
select
	previous_WARs.playerid
	,previous_WARs.Name
	,previous_WARs.Team
	,previous_WARs.season as year
	,previous_WARs.WAR as this_year_WAR
	,h.WAR as previous_year_WAR
	,previous_WARs.previous_WAR_total
	,previous_WARs.previous_IP
	,200*previous_WAR_total/previous_IP as previous_WAR_per_200IP
	,previous_WARs.WAR-h.WAR as marginal_WAR
from
(
	select
		p1.playerid
		,p1.Name
		,p1.Team as team
		,p1.season
		,p1.WAR
		,sum(p2.WAR) as previous_WAR_total
		,sum(p2.IP) as previous_IP
	from pitching p1
		inner join pitching p2 on p1.playerid=p2.playerid
			and p2.season<p1.season	
	group by p1.playerid,p1.season
) as previous_WARs
inner join pitching h
	on h.season=previous_WARs.season-1 and h.playerid=previous_WARs.playerid
where previous_IP>=200
	and previous_WAR_per_200IP>=3.0
	-- and marginal_WAR>=3
	and this_year_WAR<=1
	and previous_year_WAR>=2.0
order by marginal_WAR asc
limit 50
",drv='SQLite'
)

write.csv(comebacks_p,'comebacks_p.csv',row.names=TRUE)
write.csv(crashes_p,'crashes_p.csv',row.names=TRUE)



comebacks_test<-sqldf(
"
select
	previous_WARs.playerid
	,previous_WARs.Name
	,previous_WARs.Team
	,previous_WARs.season as year
	,previous_WARs.WAR as this_year_WAR
	,h.WAR as previous_year_WAR
	,previous_WARs.previous_WAR_total
	,previous_WARs.previous_games
	,162*previous_WAR_total/previous_games as previous_WAR_per_162G
	,previous_WARs.WAR-h.WAR as marginal_WAR
from
(
	select
		h1.playerid
		,h1.Name
		,h1.Team as team
		,h1.season
		,h1.WAR
		,sum(h2.WAR) as previous_WAR_total
		,sum(h2.G) as previous_games
	from hitting h1
		inner join hitting h2 on h1.playerid=h2.playerid
			and h2.season<h1.season	
	group by h1.playerid,h1.season
) as previous_WARs
inner join hitting h
	on h.season=previous_WARs.season-1 and h.playerid=previous_WARs.playerid
where previous_games>=162
	and previous_WAR_per_162G>=2.0
	-- and marginal_WAR>=3
	and this_year_WAR>=4
	-- and previous_WARs.Name='Chris Davis'
	and previous_year_WAR<1.0
order by marginal_WAR desc
",drv='SQLite'
)

write.csv(comebacks_test,'comebacks_test.csv',row.names=TRUE)
write.csv(crashes_test,'crashes_test.csv',row.names=TRUE)
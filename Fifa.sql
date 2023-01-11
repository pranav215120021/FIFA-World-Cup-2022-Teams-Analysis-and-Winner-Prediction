/* Q1. Winning Percentage */
with new as
(select `home team` as team, case when lower(home_team_result)='win' then 1 else 0 end as points
from international_matches union all
select `away team` as team, case when lower(home_team_result)='win' then 0 when 
lower(home_team_result)='draw' then 0 else 1 end as points
from international_matches)
select team,100.0*sum(points)/count(points) as per from new group by team
order by 100.0*sum(points)/count(points) desc;

/* Q2. Is there such a thing as home team advantage */
with new as 
(select case when lower(home_team_result)='win' then 1 else 0 end as points,
case when lower(home_team_result)='lose' then 1 else 0 end as point,
case when lower(home_team_result)='draw' then 1 else 0 end as pointss
from international_matches)
select 100*sum(pointss)/count(pointss) as home_draw_pectentage,100*sum(points)/count(points)
as home_win_pectentage, 100*sum(point)/count(point) as home_loss_pectentage
from new;

/* Q3. What is the winning percentage comparing when the highest-ranked team plays 
against the lowest-ranked team?*/
with new as 
(select case when home_team_fifa_rank < away_team_fifa_rank and lower(home_team_result) = 'win' or
home_team_fifa_rank > away_team_fifa_rank and lower(home_team_result) = 'lose' then 1 else 0 end as point, 
case when home_team_fifa_rank < away_team_fifa_rank and lower(home_team_result) = 'lose' or 
home_team_fifa_rank > away_team_fifa_rank and lower(home_team_result) = 'win' then 1 else 0 end as points,
case when home_team_fifa_rank < away_team_fifa_rank and lower(home_team_result) = 'draw' or 
home_team_fifa_rank > away_team_fifa_rank and lower(home_team_result) = 'draw' then 1 else 0 end as pointss
from international_matches)
select 100*sum(point)/count(point) as better_team_win,100*sum(points)/count(points) as better_team_lose,
100*sum(pointss)/count(pointss) as better_team_draw from new;

/*Q4 - What is the winning percentage comparing when the highest attack rank plays against 
the lowest attack rank?*/

with new as 
(select home_team_result,home_team_mean_offense_score, away_team_mean_offense_score,
case when home_team_mean_offense_score>away_team_mean_offense_score and 
lower(home_team_result)='win' or home_team_mean_offense_score<away_team_mean_offense_score and 
lower(home_team_result)='lose' then 1 else 0 end as point,
case when home_team_mean_offense_score>away_team_mean_offense_score and 
lower(home_team_result)='lose' or home_team_mean_offense_score<away_team_mean_offense_score and 
lower(home_team_result)='win' then 1 else 0 end as points,
case when lower(home_team_result)='draw' then 1 else 0 end as pointss
from international_matches where 
home_team_mean_offense_score !='' and away_team_mean_offense_score !='') 				
select 100*sum(point)/count(point) as better_attack_win,100*sum(points)/count(points) as better_attack_lose,
100*sum(pointss)/count(pointss) as better_attack_draw from new;

/* Q5. Top 10 teams with most goals difference */

with new as
(select `home team` as team, home_team_score as goals_scored, away_team_score as goals_conceded
from international_matches union all 
select `away team` as team, away_team_score as goals_scored, home_team_score as goals_scored 
from international_matches)
select team, sum(goals_scored) as goals_scored, sum(goals_conceded) as goals_conceded,
sum(goals_scored)-sum(goals_conceded) as goals_diffrence
from new group by team order by sum(goals_scored)-sum(goals_conceded) desc limit 10;
 



 
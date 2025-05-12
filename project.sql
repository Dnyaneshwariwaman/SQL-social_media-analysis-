-- social media analysis

-- Designed and implemented a MySQL-based social media analysis project, 
-- leveraging relational database capabilities to efficiently 
-- store, retrieve, and analyze extensive social media data. 
-- Developed features including user profiles, post storage, s
-- entiment analysis, and trend tracking to provide 
-- aluable insights into user behavior and trending topics. 
-- Demonstrated proficiency in database management for 
-- effective data organization and retrieval, showcasing 
-- a keen understanding of scalable and well-structured MySQL systems


-- task 1=data collection
use social_media;
show tables;                     -- total tables=13
/*
bookmarks
comment_likes
comments
follows
hashtag_follow
hashtags
login
photos
post
post_likes
post_tags
users
videos
*/
-- task 2= 
/*
- check relationship(data modeling)
- check & explore ER diagram
- realtionship means data modeling
*/

-- task 3=data cleaning
/*
here no need data cleaning
*/

-- task 4=total user
select*from users;
select count(*) from users;

-- Total 50 users data are available.

-- Task 5=total post
select*from post;
select count(*) from post;
-- Total 100 post done by user in our  database.

-- Task 6=user location
select location from post;
-- location not present in proper way

-- Task 7=average post per user
select count(post_id)from post;
select count(distinct(user_id)) from post;

select count(post_id)/(select count(distinct(user_id)) from post) avg_post from post;
-- on averagfe 2post are done by the each person

-- Task 8 =find users who have not posteeed

# By subquery
select * from users where user_id NOT IN (select distinct user_id from post) ;

# By join
select *from users u1
left join
post p
on u1.user_id=p.user_id
where p.post_id is null;

-- here 5 users out of 50 have not posted post

-- task 9= display user who do 5 or 5 or more post
select*from post;
select u1.username,u1.user_id,count(p.post_id) total from users u1
inner join
post p
on u1.user_id=p.user_id
group by u1.username
having total>=5;

-- there are 4 users have posted who do 5 or 5 or more post.

-- Task 10=display user who zero commnet
select *from users u1
left join
comments c
on u1.user_id=c.user_id
where c.comment_id is null;


-- by subquery
select * from users where user_id NOT IN (select distinct user_id from comments) ;

-- there are 1 user who zero commnet.OR not comment yet.

-- Task 11=people who have using plaform for longest time
select * from users
order by created_at asc
limit 5;

-- tak 12:longest caption in post
select post_id,user_id,caption,length(caption) total  from post
order by total desc
limit 1
;

--  
SELECT post_id,caption FROM post WHERE caption regexp 'beauty|beautiful';

select post_id,user_id,caption  from post
where caption like  '%beauty'OR caption like '%beautiful%'
;

-- task 14=commnet length >12 char
select* from comments
where length(comment_text)>=12;
-- 172 comments

-- task 14=follower >=40 
select followee_id,count(follower_id) total from follows
group by followee_id
having total>=40
;

-- task 15= display most like post

SELECT post_id,count(*) total FROM 
post_likes
GROUP BY post_id
ORDER BY total DESC;

SELECT p1.post_id,p1.caption,count(*) total 
FROM post p1
INNER JOIN post_likes p2
ON p1.post_id=p2.post_id
GROUP BY p1.post_id
ORDER BY total DESC;

-- also want user name then join 3 column
SELECT 
    p1.post_id,
    p2.caption,
    p3.username,
    COUNT(*) AS total
FROM 
    post_likes p1
INNER JOIN 
    post p2 ON p1.post_id = p2.post_id
INNER JOIN
    users p3 ON p2.user_id = p3.user_id
GROUP BY 
    p1.post_id, p2.caption, p3.username
ORDER BY total DESC;

-- most like post is 42 id




-- task 17=find most commonly used hashtag
select*from post_tags;


select h.hashtag_name,count(*) total from hashtags h
inner join post_tags pt
on h.hashtag_id=pt.hashtag_id
group by h.hashtag_name
order by total desc;

# beautiful is 21 most commonly used hashtag


-- task 18=find most folowee  used hashtag
select*from hashtag_follow;
SELECT h1.hashtag_name,count(*) total 
FROM hashtags h1
INNER JOIN hashtag_follow hf1
ON h1.hashtag_id=hf1.hashtag_id
GROUP BY h1.hashtag_name
ORDER BY total desc
LIMIT 5;

-- #' #festivesale' most folowee  used hashtag
 
 # task-19 display users who dont follow anybody -- task 19
select*from users where
user_id NOT IN(select follower_id from follows);
-- 0 users who not follow anybody 

-- task 20: most inactive user ..(post concept) 
select*from users where
user_id NOT IN(select distinct user_id from post);


-- task 21:most inactive user (post likes)     
select*from users where
user_id NOT IN(select distinct user_id from post_likes);
-- no such user
-- zero inactive user on post likes 

-- task 22:CHECK FOR BOT,
-- user who commented on every post
select*from users where
user_id NOT IN(select distinct user_id from comments);

#there is raj gupta  user who commented on every post

SELECT u1.username,count(c1.comment_id) total
FROM 
users u1 INNER JOIN comments c1 
ON u1.user_id=c1.user_id
GROUP BY u1.username
HAVING total=(SELECT count(*) FROM post)
ORDER BY total DESC;

-- task 23:# task-23  CHECK FOR BOT,
# users who like every post
sELECT u1.username,count(*) total
FROM 
users u1 INNER JOIN post_likes p1 
ON u1.user_id=p1.user_id
GROUP BY u1.username
HAVING total=(SELECT count(*) FROM post)
ORDER BY total DESC;


# 0 user who like every post
 





















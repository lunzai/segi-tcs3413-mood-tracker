CREATE TABLE IF NOT EXISTS `attribute` (
	`id`	INTEGER,
	`label`	TEXT NOT NULL UNIQUE,
	`category`	TEXT NOT NULL,
	PRIMARY KEY(`id` AUTOINCREMENT)
)
CREATE TABLE IF NOT EXISTS `mood_attribute` (
	`mood_id`	INTEGER NOT NULL,
	`attribute_id`	INTEGER NOT NULL,
	FOREIGN KEY(`attribute_id`) REFERENCES `attribute`(`id`) ON UPDATE CASCADE ON DELETE RESTRICT,
	PRIMARY KEY(`mood_id`,`attribute_id`)
)
CREATE TABLE IF NOT EXISTS `mood` (
	`id`	INTEGER,
	`label`	TEXT NOT NULL,
	`value`	INTEGER NOT NULL,
	`date`	TEXT NOT NULL,
	`note`	TEXT NOT NULL,
	`created_at`	TEXT NOT NULL,
	`updated_at`	TEXT NOT NULL,
	PRIMARY KEY(`id` AUTOINCREMENT)
)
INSERT INTO `attribute` (`id`,`label`,`category`) VALUES (1,'Relaxation','Activities'),
 (2,'Studies','Activities'),
 (3,'Work','Activities'),
 (4,'Family','Activities'),
 (5,'Relationship','Activities'),
 (6,'Party','Activities'),
 (7,'TV/Movies','Activities'),
 (8,'Hobby','Activities'),
 (9,'Exercise','Activities'),
 (10,'Music','Activities'),
 (11,'Shopping','Activities'),
 (12,'Gaming','Activities'),
 (13,'Cooking','Activities'),
 (14,'Creativity','Activities'),
 (15,'Social','Activities'),
 (16,'Traveling','Activities'),
 (17,'Volunteering','Activities'),
 (18,'Pets','Activities'),
 (19,'Productive','Activities'),
 (20,'Food','Activities'),
 (21,'Joy','Emotions'),
 (22,'Sadness','Emotions'),
 (23,'Anger','Emotions'),
 (24,'Fear','Emotions'),
 (25,'Surprise','Emotions'),
 (26,'Disgust','Emotions'),
 (27,'Excitement','Emotions'),
 (28,'Contentment','Emotions'),
 (29,'Love','Emotions'),
 (30,'Guilt','Emotions'),
 (31,'Shame','Emotions'),
 (32,'Anxiety','Emotions'),
 (33,'Curiosity','Emotions'),
 (34,'Confusion','Emotions'),
 (35,'Frustration','Emotions'),
 (36,'Enthusiasm','Emotions'),
 (37,'Pride','Emotions'),
 (38,'Boredom','Emotions'),
 (39,'Trust','Emotions'),
 (40,'Anticipation','Emotions');
CREATE INDEX IF NOT EXISTS `idx-attribute-category` ON `attribute` (
	`category`
)
CREATE INDEX IF NOT EXISTS `idx-mood-date` ON `mood` (
	`date`
)
CREATE INDEX IF NOT EXISTS `idx-mood-value` ON `mood` (
	`value`
)

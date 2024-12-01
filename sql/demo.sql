-- blog.article definition

CREATE TABLE `article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `published_title` varchar(255) DEFAULT NULL,
  `content` varchar(255) DEFAULT NULL,
  `categories` varchar(255) DEFAULT '',
  `tags` varchar(255) DEFAULT '',
  `create_time` varchar(255) DEFAULT NULL,
  `update_time` varchar(255) DEFAULT NULL,
  `publish` varchar(255) DEFAULT NULL,
  `deleted` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
CREATE TABLE `storage_units` (
    `id` int(10) NOT NULL AUTO_INCREMENT,
    `owner` longtext DEFAULT NULL,
    `stash_id` int(10) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
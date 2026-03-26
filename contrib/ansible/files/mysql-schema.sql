CREATE TABLE IF NOT EXISTS `user` (
    `id` INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(64) NOT NULL,
    `email` VARCHAR(255) DEFAULT NULL,
    `balance` INT NOT NULL,
    `disabled` TINYINT(1) NOT NULL,
    `created` DATETIME NOT NULL,
    `updated` DATETIME DEFAULT NULL,
    UNIQUE INDEX `UNIQ_USER_NAME` (`name`),
    INDEX `IDX_USER_DISABLED_UPDATED` (`disabled`, `updated`),
    PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `article` (
    `id` INT AUTO_INCREMENT NOT NULL,
    `precursor_id` INT DEFAULT NULL,
    `name` VARCHAR(255) NOT NULL,
    `barcode` VARCHAR(32) DEFAULT NULL,
    `amount` INT NOT NULL,
    `active` TINYINT(1) NOT NULL,
    `created` DATETIME NOT NULL,
    `usage_count` INT NOT NULL,
    UNIQUE INDEX `UNIQ_ARTICLE_PRECURSOR_ID` (`precursor_id`),
    INDEX `IDX_ARTICLE_PRECURSOR_ID` (`precursor_id`),
    INDEX `IDX_ARTICLE_BARCODE` (`barcode`),
    PRIMARY KEY(`id`),
    CONSTRAINT `FK_ARTICLE_PRECURSOR_ID` FOREIGN KEY (`precursor_id`) REFERENCES `article` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `transactions` (
    `id` INT AUTO_INCREMENT NOT NULL,
    `user_id` INT NOT NULL,
    `article_id` INT DEFAULT NULL,
    `recipient_transaction_id` INT DEFAULT NULL,
    `sender_transaction_id` INT DEFAULT NULL,
    `quantity` INT DEFAULT NULL,
    `comment` VARCHAR(255) DEFAULT NULL,
    `amount` INT NOT NULL,
    `deleted` TINYINT(1) NOT NULL,
    `created` DATETIME NOT NULL,
    UNIQUE INDEX `UNIQ_TRANSACTION_RECIPIENT` (`recipient_transaction_id`),
    UNIQUE INDEX `UNIQ_TRANSACTION_SENDER` (`sender_transaction_id`),
    INDEX `IDX_TRANSACTION_USER` (`user_id`),
    INDEX `IDX_TRANSACTION_ARTICLE` (`article_id`),
    INDEX `IDX_TRANSACTION_CREATED` (`created`),
    PRIMARY KEY(`id`),
    CONSTRAINT `FK_TRANSACTION_USER` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`),
    CONSTRAINT `FK_TRANSACTION_ARTICLE` FOREIGN KEY (`article_id`) REFERENCES `article` (`id`) ON DELETE SET NULL,
    CONSTRAINT `FK_TRANSACTION_RECIPIENT` FOREIGN KEY (`recipient_transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE,
    CONSTRAINT `FK_TRANSACTION_SENDER` FOREIGN KEY (`sender_transaction_id`) REFERENCES `transactions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

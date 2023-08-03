CREATE SCHEMA IF NOT EXISTS `database` DEFAULT CHARACTER SET utf8 ;
CREATE SCHEMA IF NOT EXISTS `keycloak` DEFAULT CHARACTER SET utf8 ;
-- USE `database` ;

-- -----------------------------------------------------
-- Table `db`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `database`.`user` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(50) NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  `email` VARCHAR(256) NULL DEFAULT NULL,
  `password` VARCHAR(30) NOT NULL, -- just in case
  PRIMARY KEY (`id`),
  UNIQUE INDEX `user_idx_user_id` (`user_id` ASC))
ENGINE = InnoDB;

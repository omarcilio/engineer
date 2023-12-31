-- ----------------------------------------------------
-- 			CREATE DATABASE SCHEMA					 --
-- ----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mlDatabase`;
USE `mlDatabase`;

-- -----------------------------------------------------
-- Table `mlDatabase`.`Customer` 					  --
-- Tabela contendo clientes e dados de contato	 	  --									
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`Customer` (
	`customerId` INT NOT NULL AUTO_INCREMENT,
	`email` VARCHAR(255) NULL,
	`nombre` VARCHAR(45) NULL,
	`apellido` VARCHAR(45) NULL,
	`sexo` CHAR(1) NULL,
	`direccion` VARCHAR(45) NULL,
	`fechaNacimiento` DATE NULL,
	`telefono` INT NULL,
    `isBuyer` INT NULL,
    `isSeller` INT NULL,
	PRIMARY KEY (`customerId`)
);


-- -----------------------------------------------------
-- Table `mlDatabase`.`Category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`Category` (
  `categoryId` INT NOT NULL AUTO_INCREMENT,
  `categoryDescripcion` VARCHAR(255) NULL,
  `path` VARCHAR(255) NULL,
  PRIMARY KEY (`categoryId`),
  UNIQUE INDEX `idCategory_UNIQUE` (`categoryId` ASC) VISIBLE
  );


-- -----------------------------------------------------
-- Table `mlDatabase`.`Item`
-- Tabela contendo produtos cadastrados			 	  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`Item` (
  `itemId` INT NOT NULL AUTO_INCREMENT,
  `categoryId` INT NOT NULL,
  `nombre` VARCHAR(100) NULL,
  `descripcion` VARCHAR(255) NULL,
  `precio` DECIMAL(18,2) NULL,
  `estado` VARCHAR(45) NULL,
  `fechaBaja` DATETIME NULL,
  PRIMARY KEY (`itemId`),
  INDEX `idCategoria_idx` (`categoryId` ASC) VISIBLE,
  UNIQUE INDEX `idItem_UNIQUE` (`itemId` ASC) VISIBLE,
  CONSTRAINT `idCategoria`
    FOREIGN KEY (`categoryId`)
    REFERENCES `mlDatabase`.`Category` (`categoryId`)
);


-- -----------------------------------------------------
-- Table `mlDatabase`.`Order`
-- Tabela contendo os pedidos realizados 			  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`Order` (
  `orderId` INT NOT NULL AUTO_INCREMENT,
  `customerId` INT NOT NULL,
  `sellerId` INT NOT NULL,
  `fechaOrder` DATETIME NULL,
  PRIMARY KEY (`orderId`),
  INDEX `idCustomer_idx` (`customerId` ASC) VISIBLE,
  CONSTRAINT `idCustomer`
    FOREIGN KEY (`customerId`)
    REFERENCES `mlDatabase`.`Customer` (`customerId`),
  CONSTRAINT `idSeller`
  FOREIGN KEY (`sellerId`)
  REFERENCES `mlDatabase`.`Customer` (`customerId`)
);


-- -----------------------------------------------------
-- Table `mlDatabase`.`OrderItem`
-- Tabela contendo os itens dos pedidos 			  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`OrderItem` (
  `orderItemId` INT NOT NULL AUTO_INCREMENT,
  `orderId` INT NOT NULL,
  `itemId` INT NOT NULL,
  `Cantidad` INT NULL,
  `precoUnitario` DECIMAL(18,2) NULL,
  PRIMARY KEY (`orderItemId`),
  INDEX `idOrder_idx` (`orderId` ASC) VISIBLE,
  INDEX `idItem_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `idOrder`
    FOREIGN KEY (`orderId`)
    REFERENCES `mlDatabase`.`Order` (`orderId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idItem`
    FOREIGN KEY (`itemId`)
    REFERENCES `mlDatabase`.`Item` (`itemId`)
);


-- -----------------------------------------------------
-- Table `mlDatabase`.`orderStatus`
-- Tabela contendo o status dos pedidos 			  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`orderStatus` (
  `orderStatusId` INT NOT NULL AUTO_INCREMENT,
  `orderId` INT NOT NULL,
  `statusDescripcion` VARCHAR(45) NULL,
  `isDefault` TINYINT NULL,
  `isFinal` TINYINT NULL,
  `fechaActualizacion` DATETIME NULL,
  PRIMARY KEY (`orderStatusId`),
  INDEX `idOrder_idx` (`orderId` ASC) VISIBLE,
  CONSTRAINT `orderId`
    FOREIGN KEY (`orderId`)
    REFERENCES `mlDatabase`.`Order` (`orderId`)
);


-- -----------------------------------------------------
-- Table `mlDatabase`.`itemHistorico`
-- Tabela gerada pela sp_up_item_historico			  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mlDatabase`.`itemHistorico` (
  `itemHistoricoId` INT NOT NULL AUTO_INCREMENT,
  `itemId` INT NOT NULL,
  `precio` DECIMAL(18,2) NULL,
  `estado` VARCHAR(45) NULL,
  `fechaActualizacion` DATETIME NULL,
  PRIMARY KEY (`itemHistoricoId`),
  INDEX `idItem_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `itemId`
    FOREIGN KEY (`itemId`)
    REFERENCES `mlDatabase`.`Item` (`itemId`)
);


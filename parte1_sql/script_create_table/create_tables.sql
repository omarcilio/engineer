-- ----------------------------------------------------
-- 			CREATE DATABASE SCHEMA					 --
-- ----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbo`;
USE `dbo`;


-- -----------------------------------------------------
-- Table `dbo`.`Customer` 					  --
-- Tabela contendo clientes e dados de contato	 	  --									
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`Customer` (
	`customerId` INT NOT NULL AUTO_INCREMENT,
	`email` VARCHAR(255) NULL,
	`nombre` VARCHAR(45) NULL,
	`apellido` VARCHAR(45) NULL,
	`sexo` CHAR(1) NULL,
	`direccion` VARCHAR(45) NULL,
	`fechaNacimiento` DATE NULL,
	`telefono` INT NULL,
	PRIMARY KEY (`customerId`)
);


-- -----------------------------------------------------
-- Table `dbo`.`Category`
-- Tabela contendo categoria de produtos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`Category` (
  `categoryId` INT NOT NULL AUTO_INCREMENT,
  `categoryDescripcion` VARCHAR(255) NULL,
  `path` VARCHAR(255) NULL,
  PRIMARY KEY (`categoryId`),
  UNIQUE INDEX `idCategory_UNIQUE` (`categoryId` ASC) VISIBLE
  );


-- -----------------------------------------------------
-- Table `dbo`.`Item`
-- Tabela contendo todos os produtos já cadastrados		--
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`Item` (
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
    REFERENCES `dbo`.`Category` (`categoryId`)
);


-- -----------------------------------------------------
-- Table `dbo`.`Order`
-- Tabela contendo os pedidos realizados      			  --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`Order` (
  `orderId` INT NOT NULL AUTO_INCREMENT,
  `customerId` INT NOT NULL,
  `fechaOrder` DATETIME NULL,
  PRIMARY KEY (`orderId`),
  INDEX `idCustomer_idx` (`customerId` ASC) VISIBLE,
  CONSTRAINT `idCustomer`
    FOREIGN KEY (`customerId`)
    REFERENCES `dbo`.`Customer` (`customerId`)
);


-- -----------------------------------------------------
-- Table `dbo`.`OrderItem`
-- Tabela contendo o relacionamento itens e pedidos   --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`OrderItem` (
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
    REFERENCES `dbo`.`Order` (`orderId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idItem`
    FOREIGN KEY (`itemId`)
    REFERENCES `dbo`.`Item` (`itemId`)
);


-- -----------------------------------------------------
-- Table `dbo`.`orderStatus`
-- Tabela contendo o status dos pedidos 			        --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`orderStatus` (
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
    REFERENCES `dbo`.`Order` (`orderId`)
);


-- -----------------------------------------------------
-- Table `dbo`.`itemHistorico`
-- Tabela gerada pela sp_up_item_historico			      --
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbo`.`itemHistorico` (
  `itemHistoricoId` INT NOT NULL AUTO_INCREMENT,
  `itemId` INT NOT NULL,
  `precio` DECIMAL(18,2) NULL,
  `estado` VARCHAR(45) NULL,
  `fechaActualizacion` DATETIME NULL,
  PRIMARY KEY (`itemHistoricoId`),
  INDEX `idItem_idx` (`itemId` ASC) VISIBLE,
  CONSTRAINT `itemId`
    FOREIGN KEY (`itemId`)
    REFERENCES `dbo`.`Item` (`itemId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


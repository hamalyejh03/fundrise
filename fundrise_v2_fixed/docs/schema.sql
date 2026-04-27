-- ============================================================
-- FundRise Database Schema
-- MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS fundrise_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE fundrise_db;

-- ============================================================
-- USERS
-- ============================================================
CREATE TABLE IF NOT EXISTS users (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(100)    NOT NULL,
    last_name       VARCHAR(100)    NOT NULL,
    email           VARCHAR(255)    NOT NULL,
    password        VARCHAR(255)    NOT NULL,
    bio             TEXT,
    profile_image_url VARCHAR(500),
    role            ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
    enabled         TINYINT(1)      NOT NULL DEFAULT 1,
    created_at      DATETIME(6),
    updated_at      DATETIME(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_users_email (email),
    INDEX idx_users_role (role),
    INDEX idx_users_enabled (enabled)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- CAMPAIGNS
-- ============================================================
CREATE TABLE IF NOT EXISTS campaigns (
    id              BIGINT          NOT NULL AUTO_INCREMENT,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT            NOT NULL,
    goal_amount     DECIMAL(10,2)   NOT NULL,
    raised_amount   DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
    image_url       VARCHAR(500),
    status          ENUM('ACTIVE','COMPLETED','PAUSED','DELETED') NOT NULL DEFAULT 'ACTIVE',
    category        VARCHAR(50)     NOT NULL DEFAULT 'General',
    location        VARCHAR(200),
    end_date        DATETIME(6),
    organizer_id    BIGINT          NOT NULL,
    created_at      DATETIME(6),
    updated_at      DATETIME(6),
    PRIMARY KEY (id),
    INDEX idx_campaigns_status (status),
    INDEX idx_campaigns_organizer (organizer_id),
    INDEX idx_campaigns_category (category),
    INDEX idx_campaigns_raised (raised_amount DESC),
    INDEX idx_campaigns_created (created_at DESC),
    FULLTEXT INDEX ft_campaigns_search (title, description, category),
    CONSTRAINT fk_campaigns_organizer FOREIGN KEY (organizer_id)
        REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- DONATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS donations (
    id                          BIGINT          NOT NULL AUTO_INCREMENT,
    amount                      DECIMAL(10,2)   NOT NULL,
    message                     TEXT,
    anonymous                   TINYINT(1)      NOT NULL DEFAULT 0,
    campaign_id                 BIGINT          NOT NULL,
    donor_id                    BIGINT,
    stripe_payment_intent_id    VARCHAR(255),
    status  ENUM('PENDING','COMPLETED','FAILED','REFUNDED') NOT NULL DEFAULT 'PENDING',
    donor_name                  VARCHAR(200),
    donor_email                 VARCHAR(255),
    created_at                  DATETIME(6),
    PRIMARY KEY (id),
    UNIQUE KEY uk_donations_stripe_id (stripe_payment_intent_id),
    INDEX idx_donations_campaign (campaign_id),
    INDEX idx_donations_donor (donor_id),
    INDEX idx_donations_status (status),
    INDEX idx_donations_created (created_at DESC),
    CONSTRAINT fk_donations_campaign FOREIGN KEY (campaign_id)
        REFERENCES campaigns (id) ON DELETE CASCADE,
    CONSTRAINT fk_donations_donor FOREIGN KEY (donor_id)
        REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- SEED: Default Admin Account
-- Password: Admin@1234  (BCrypt hash)
-- ============================================================
INSERT IGNORE INTO users (first_name, last_name, email, password, role, enabled, created_at, updated_at)
VALUES (
    'Admin',
    'User',
    'admin@fundrise.com',
    '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LqGEtVDfUEhBJ1W3y',
    'ADMIN',
    1,
    NOW(),
    NOW()
);

-- ============================================================
-- SEED: Sample Campaigns (optional for development)
-- ============================================================
INSERT IGNORE INTO users (first_name, last_name, email, password, role, enabled, created_at, updated_at)
VALUES
    ('Jane', 'Smith', 'jane@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LqGEtVDfUEhBJ1W3y', 'USER', 1, NOW(), NOW()),
    ('John', 'Doe',   'john@example.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LqGEtVDfUEhBJ1W3y', 'USER', 1, NOW(), NOW());

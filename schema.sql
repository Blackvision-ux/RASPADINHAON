-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255),
    saldo DECIMAL(15, 2) DEFAULT 0.00,
    is_demo BOOLEAN DEFAULT FALSE,
    demo_win_rate INT DEFAULT 50,
    is_blocked BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Withdrawals table
CREATE TABLE IF NOT EXISTS withdrawals (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(15, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'PENDING',
    pix_key VARCHAR(255),
    pix_type VARCHAR(50),
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP
);

-- Transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    withdrawal_id INT REFERENCES withdrawals(id) ON DELETE SET NULL,
    amount DECIMAL(15, 2) NOT NULL,
    type VARCHAR(50) NOT NULL, -- DEPOSIT, WITHDRAWAL, BET, WIN
    status VARCHAR(50) DEFAULT 'PENDING', -- APPROVED, PENDING, REJECTED
    provider VARCHAR(50),
    provider_transaction_id VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP
);

-- Game Settings table
CREATE TABLE IF NOT EXISTS games (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    bet_cost DECIMAL(10, 2) DEFAULT 1.00,
    win_chance_percent DECIMAL(5, 2) DEFAULT 30.00,
    image_url VARCHAR(255)
);

-- Theme Configuration table
CREATE TABLE IF NOT EXISTS configuracoes_tema (
    id SERIAL PRIMARY KEY,
    nome_config VARCHAR(255) UNIQUE NOT NULL,
    valor_config TEXT
);

-- Payment Methods table
CREATE TABLE IF NOT EXISTS payment_methods (
    id SERIAL PRIMARY KEY,
    provider_key VARCHAR(50) UNIQUE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Bonus System table
CREATE TABLE IF NOT EXISTS bonus_system (
    id SERIAL PRIMARY KEY,
    is_bonus_active BOOLEAN DEFAULT FALSE,
    current_bonus_paid DECIMAL(15, 2) DEFAULT 0,
    bonus_amount DECIMAL(15, 2) DEFAULT 0,
    target_faturamento DECIMAL(15, 2) DEFAULT 1000.00,
    current_faturamento DECIMAL(15, 2) DEFAULT 0
);

-- INITIAL SEED DATA

-- Default Games
INSERT INTO games (name, bet_cost, win_chance_percent) VALUES
('raspadinha_classica', 1.00, 30.00),
('raspadinha_premium', 5.00, 45.00)
ON CONFLICT (name) DO NOTHING;

-- Default Theme Configs
INSERT INTO configuracoes_tema (nome_config, valor_config) VALUES
('cor-primary', '#111111'),
('cor-secondary', '#e0e0e0'),
('cor-tertiary', '#28e504'),
('site-logo-url', 'https://ik.imagekit.io/azx3nlpdu/logo/01K05ABF6P2A9P098AY0REABR5.png')
ON CONFLICT (nome_config) DO NOTHING;

-- Default Payment Methods
INSERT INTO payment_methods (provider_key, is_active) VALUES
('pix', true),
('stripe', false)
ON CONFLICT (provider_key) DO NOTHING;

-- Initialize Bonus System (Single Row)
INSERT INTO bonus_system (id, is_bonus_active, bonus_amount, target_faturamento) VALUES
(1, false, 500.00, 2000.00)
ON CONFLICT (id) DO NOTHING;

-- Create Admin User (Optional, if you want a user for testing)
INSERT INTO users (name, email, saldo, is_demo) VALUES
('Usuario Teste', 'teste@exemplo.com', 100.00, false)
ON CONFLICT (email) DO NOTHING;

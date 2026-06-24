CREATE TABLE IF NOT EXISTS purchase_orders (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  supplier_name VARCHAR(255) NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  status VARCHAR(50) NOT NULL DEFAULT 'CREATED',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO purchase_orders (supplier_name, amount, status)
VALUES ('Nordic Components', 1250.00, 'APPROVED'), ('Baltic Logistics', 18500.00, 'MANUAL_REVIEW');

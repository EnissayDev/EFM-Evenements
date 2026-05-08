CREATE TABLE IF NOT EXISTS utilisateur (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS evenement (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titre VARCHAR(200) NOT NULL,
    date DATE NOT NULL,
    capacite INT NOT NULL,
    lieu VARCHAR(255) NOT NULL,
    organisateur_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_evenement_organisateur
        FOREIGN KEY (organisateur_id) REFERENCES utilisateur(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS commande (
    id INT AUTO_INCREMENT PRIMARY KEY,
    evenement_id INT NOT NULL,
    participant_id INT NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    montant_total DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_commande_evenement
        FOREIGN KEY (evenement_id) REFERENCES evenement(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_commande_participant
        FOREIGN KEY (participant_id) REFERENCES utilisateur(id)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS billet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commande_id INT NOT NULL,
    code VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_billet_commande
        FOREIGN KEY (commande_id) REFERENCES commande(id)
        ON DELETE CASCADE
);
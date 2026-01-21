-- Core analytical views
-- These views provide aggregated indicators used by all roles


-- View: number of packages per group with recovery rate
-- admin: full read access
-- group_leader: only their own group
-- volunteer: only their own group

CREATE OR REPLACE VIEW v_colis_groupe AS
SELECT
    g.id_groupe,
    g.nom_groupe,
    COUNT(DISTINCT c.id_colis) AS total_colis,
    SUM(CASE WHEN d.récupéré = 1 THEN 1 ELSE 0 END) AS colis_recuperes,
    ROUND(
        (SUM(CASE WHEN d.récupéré = 1 THEN 1 ELSE 0 END) * 100.0) /
        NULLIF(COUNT(DISTINCT c.id_colis), 0),
        2
    ) AS pourcentage_recuperation
FROM GROUPES g
LEFT JOIN COLIS c ON g.id_groupe = c.id_groupe
LEFT JOIN DISTRIBUTIONS d ON c.id_colis = d.id_colis
GROUP BY g.id_groupe, g.nom_groupe
ORDER BY g.id_groupe;
/


-- View: list of beneficiaries per group with number of received packages
-- and date of last package
-- admin: full read access
-- group_leader: only their own group
-- volunteer: only their own group

CREATE OR REPLACE VIEW v_beneficiaires_groupe AS
SELECT
    g.id_groupe,
    g.nom_groupe,
    b.id_beneficiaire,
    b.nom AS nom_benef,
    COUNT(DISTINCT d.id_distribution) AS nb_colis_recus,
    MAX(d.date_distribution) AS date_dernier_colis
FROM GROUPES g
LEFT JOIN BENEFICIAIRES b ON 1 = 1  -- all potential beneficiaries
LEFT JOIN COLIS c 
    ON b.id_beneficiaire = c.id_beneficiaire
    AND g.id_groupe = c.id_groupe
LEFT JOIN DISTRIBUTIONS d ON c.id_colis = d.id_colis
GROUP BY g.id_groupe, g.nom_groupe, b.id_beneficiaire, b.nom
ORDER BY g.id_groupe, b.id_beneficiaire;
/


-- View: products with stock less than or equal to alert threshold
-- admin: full access (select, insert, update, delete)
-- group_leader: read-only
-- volunteer: read-only

CREATE OR REPLACE VIEW v_produits_stock_critique AS
SELECT
    p.id_produit,
    p.nom_produit,
    p.type_produit,
    p.quantite_stock,
    p.seuil_alerte,
    CASE
        WHEN p.quantite_stock <= p.seuil_alerte THEN 'CRITICAL'
        ELSE 'OK'
    END AS statut_alerte,
    (p.seuil_alerte - p.quantite_stock) AS unites_manquantes
FROM PRODUITS p
ORDER BY statut_alerte DESC, p.quantite_stock ASC;
/

    
-- View: donation budget overview
-- admin: full access (select, insert, update, delete)
-- group_leader: read-only
-- volunteer: no access

CREATE OR REPLACE VIEW v_budget_dons AS
SELECT
    d.type_don,
    COUNT(d.id_don) AS nb_dons,
    ROUND(SUM(NVL(d.montant, 0)), 2) AS montant_total,
    (SELECT solde FROM BUDGET WHERE id_budget = 1) AS solde_budget_actuel,
    MAX(d.date_don) AS date_dernier_don,
    SYSDATE AS date_mise_a_jour
FROM DONS d
GROUP BY d.type_don
ORDER BY d.type_don;
/


-- View: volunteer activity statistics
-- admin: full view
-- group_leader: only their own group
-- volunteer: only their own activity

CREATE OR REPLACE VIEW v_activite_benevoles AS
SELECT
    m.id_membre,
    m.nom,
    m.prenom,
    COUNT(DISTINCT mg.id_groupe) AS nb_groupes,
    COUNT(DISTINCT d.id_distribution) AS nb_colis_distribues,
    ROUND(
        SUM(
            (EXTRACT(HOUR FROM (g.heure_fin - g.heure_debut)) +
             EXTRACT(MINUTE FROM (g.heure_fin - g.heure_debut)) / 60)
        ) /
        NULLIF(COUNT(DISTINCT d.id_distribution), 0),
        2
    ) AS total_heures_travaillees,
    MAX(d.date_distribution) AS date_derniere_activite
FROM MEMBRES m
LEFT JOIN MEMBRE_GROUPE mg ON m.id_membre = mg.id_membre
LEFT JOIN GROUPES g ON mg.id_groupe = g.id_groupe
LEFT JOIN DISTRIBUTIONS d ON g.id_groupe = d.id_groupe
GROUP BY m.id_membre, m.nom, m.prenom
ORDER BY nb_colis_distribues DESC, m.id_membre;
/



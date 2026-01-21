-- Admin role: full access to all data

CREATE OR REPLACE VIEW v_admin_colis_groupe AS
SELECT * FROM v_colis_groupe;

CREATE OR REPLACE VIEW v_admin_beneficiaires_groupe AS
SELECT * FROM v_beneficiaires_groupe;

CREATE OR REPLACE VIEW v_admin_produits_stock AS
SELECT * FROM v_produits_stock_critique;

CREATE OR REPLACE VIEW v_admin_budget_dons AS
SELECT * FROM v_budget_dons;

CREATE OR REPLACE VIEW v_admin_activite_benevoles AS
SELECT * FROM v_activite_benevoles;
/



-- Group leader role: restricted access to own group only

CREATE OR REPLACE VIEW v_chef_colis_groupe AS
SELECT *
FROM v_colis_groupe
WHERE id_groupe IN (
    SELECT id_groupe
    FROM MEMBRE_GROUPE
    WHERE id_membre = 3  -- group leader ID (modifiable for testing)
);

CREATE OR REPLACE VIEW v_chef_beneficiaires_groupe AS
SELECT *
FROM v_beneficiaires_groupe
WHERE id_groupe IN (
    SELECT id_groupe
    FROM MEMBRE_GROUPE
    WHERE id_membre = 3
);

CREATE OR REPLACE VIEW v_chef_produits_stock AS
SELECT *
FROM v_produits_stock_critique;

CREATE OR REPLACE VIEW v_chef_budget_dons AS
SELECT *
FROM v_budget_dons;

CREATE OR REPLACE VIEW v_chef_activite_benevoles AS
SELECT *
FROM v_activite_benevoles
WHERE id_membre IN (
    SELECT id_membre
    FROM MEMBRE_GROUPE
    WHERE id_groupe IN (
        SELECT id_groupe
        FROM MEMBRE_GROUPE
        WHERE id_membre = 3
    )
);
/


-- Volunteer role: very limited access

CREATE OR REPLACE VIEW v_benev_colis_groupe AS
SELECT *
FROM v_colis_groupe
WHERE id_groupe IN (
    SELECT id_groupe
    FROM MEMBRE_GROUPE
    WHERE id_membre = 5  -- volunteer ID (modifiable for testing)
);

CREATE OR REPLACE VIEW v_benev_beneficiaires_groupe AS
SELECT *
FROM v_beneficiaires_groupe
WHERE id_groupe IN (
    SELECT id_groupe
    FROM MEMBRE_GROUPE
    WHERE id_membre = 5
);

CREATE OR REPLACE VIEW v_benev_produits_stock AS
SELECT *
FROM v_produits_stock_critique;
/


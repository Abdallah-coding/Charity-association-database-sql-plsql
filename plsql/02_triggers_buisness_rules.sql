-- Trigger: beneficiary checks (valid family composition, controlled diet regime)
CREATE OR REPLACE TRIGGER trg_beneficiaire_controles
BEFORE INSERT OR UPDATE ON beneficiaires
FOR EACH ROW
DECLARE
    v_total_personnes NUMBER;
BEGIN
    -- Compute total number of people in the family
    v_total_personnes := NVL(:NEW.nb_adultes, 0)
                       + NVL(:NEW.nb_enfants, 0)
                       + NVL(:NEW.nb_bebes, 0);

    -- At least one person
    IF v_total_personnes < 1 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'A beneficiary must represent at least one person.'
        );
    END IF;

    -- Controlled diet regime
    -- TODO: missing in screenshot (the full IF header line)
    -- IF :NEW.nom_regime NOT IN ('standard','végétarien','végan','halal','casher') THEN
    IF :NEW.nom_regime NOT IN ('standard','végétarien','végan','halal','casher') THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Diet regime not allowed.'
        );
    END IF;
END;
/


-- Package size grid (classic example): 1 person -> S, 2-3 -> M, 4-5 -> L, 6+ -> XL

CREATE OR REPLACE TRIGGER trg_calcul_taille_colis
BEFORE INSERT OR UPDATE ON colis
FOR EACH ROW
DECLARE
    v_total_personnes NUMBER;
BEGIN
    SELECT (nb_adultes + nb_enfants + nb_bebes)
    INTO v_total_personnes
    FROM beneficiaires
    WHERE id_beneficiaire = :NEW.id_beneficiaire;

    IF v_total_personnes = 1 THEN
        :NEW.taille_colis := 'S';
    ELSIF v_total_personnes BETWEEN 2 AND 3 THEN
        :NEW.taille_colis := 'M';
    ELSIF v_total_personnes BETWEEN 4 AND 5 THEN
        :NEW.taille_colis := 'L';
    ELSE
        :NEW.taille_colis := 'XL';
    END IF;
END;
/

-- Trigger: package content compatibility with the beneficiary diet regime
-- Checks that no forbidden product category is present

CREATE OR REPLACE TRIGGER trg_verif_colis_regime
AFTER INSERT OR UPDATE ON colis_produits
FOR EACH ROW
DECLARE
    v_regime beneficiaires.nom_regime%TYPE;
    v_categorie produits.categorie%TYPE;
BEGIN
    -- Retrieve the beneficiary diet regime
    SELECT b.nom_regime
    INTO v_regime
    FROM beneficiaires b
    JOIN colis c ON c.id_beneficiaire = b.id_beneficiaire
    WHERE c.id_colis = :NEW.id_colis;

    -- Retrieve the product category
    SELECT categorie
    INTO v_categorie
    FROM produits
    WHERE id_produit = :NEW.id_produit;

    -- Restrictions depending on the regime
    IF v_regime = 'végan' AND v_categorie IN ('viande','lait','oeufs') THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'Forbidden product for a vegan beneficiary.'
        );
    END IF;

    IF v_regime = 'végétarien' AND v_categorie = 'viande' THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'Forbidden product for a vegetarian beneficiary.'
        );
    END IF;

    IF v_regime = 'halal' AND v_categorie = 'porc' THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'Non-halal product detected.'
        );
    END IF;

    IF v_regime = 'casher' AND v_categorie = 'porc' THEN
        RAISE_APPLICATION_ERROR(
            -20006,
            'Non-kosher product detected.'
        );
    END IF;
END;
/


-- On table DON_PRODUIT (donated quantity in units)
ALTER TABLE DON_PRODUIT
ADD CONSTRAINT chk_don_produit_qte_entier
CHECK (quantite_donnee = TRUNC(quantite_donnee));

ALTER TABLE DON_PRODUIT
ADD CONSTRAINT chk_don_produit_qte_pos
CHECK (quantite_donnee > 0);

-- On table COLIS_PRODUIT (used quantity in units)
ALTER TABLE COLIS_PRODUIT
ADD CONSTRAINT chk_colis_produit_qte_entier
CHECK (quantite_utilisee = TRUNC(quantite_utilisee));

ALTER TABLE COLIS_PRODUIT
ADD CONSTRAINT chk_colis_produit_qte_pos
CHECK (quantite_utilisee > 0);

-- Stock and alert threshold must be >= 0
ALTER TABLE PRODUITS
ADD CONSTRAINT chk_stock_positif CHECK (quantite_stock >= 0);

ALTER TABLE PRODUITS
ADD CONSTRAINT chk_seuil_positif CHECK (seuil_alerte >= 0);

-- Used quantity must be > 0 (duplicate with chk_colis_produit_qte_pos but kept as in doc)
ALTER TABLE COLIS_PRODUIT
ADD CONSTRAINT chk_qte_utilisee_positif CHECK (quantite_utilisee > 0);


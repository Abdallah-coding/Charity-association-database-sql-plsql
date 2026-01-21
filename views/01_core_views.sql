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

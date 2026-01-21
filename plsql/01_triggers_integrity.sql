-- Rule: one member can belong to only one group maximum

CREATE OR REPLACE TRIGGER trg_one_group_per_member
BEFORE INSERT OR UPDATE ON MEMBRE_GROUPE
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM MEMBRE_GROUPE
    WHERE id_membre = :NEW.id_membre
      AND id_membre_groupe != NVL(:NEW.id_membre_groupe, -1);

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(
            -60001,
            'A member cannot belong to more than one group.'
        );
    END IF;
END;
/


-- Rule: enforce minimum and maximum number of volunteers per group

CREATE OR REPLACE TRIGGER trg_check_bounds
FOR INSERT OR DELETE OR UPDATE ON MEMBRE_GROUPE
COMPOUND TRIGGER

    -- Keep track of affected group IDs
    TYPE t_seen IS TABLE OF BOOLEAN INDEX BY PLS_INTEGER;
    g_seen t_seen;

    -- Mark a group as impacted
    PROCEDURE mark(gid NUMBER) IS
    BEGIN
        IF gid IS NOT NULL THEN
            g_seen(TRUNC(gid)) := TRUE;
        END IF;
    END;

    BEFORE EACH ROW IS
    BEGIN
        IF INSERTING THEN
            mark(:NEW.id_groupe);
        ELSIF DELETING THEN
            mark(:OLD.id_groupe);
        ELSIF UPDATING THEN
            mark(:OLD.id_groupe);
            mark(:NEW.id_groupe);
        END IF;
    END BEFORE EACH ROW;

    AFTER STATEMENT IS
        v_min   NUMBER;
        v_max   NUMBER;
        v_count NUMBER;
        k       PLS_INTEGER;
    BEGIN
        k := g_seen.FIRST;
        WHILE k IS NOT NULL LOOP

            SELECT
                NVL(nombre_min_benevoles, 1),
                nombre_max_benevoles,
                (SELECT COUNT(*)
                 FROM MEMBRE_GROUPE
                 WHERE id_groupe = k)
            INTO v_min, v_max, v_count
            FROM GROUPES
            WHERE id_groupe = k;

            -- Minimum volunteers constraint
            IF v_count < v_min THEN
                RAISE_APPLICATION_ERROR(
                    -60002,
                    'Group ' || k || ' must have at least ' || v_min || ' volunteers.'
                );
            END IF;

            -- Maximum volunteers constraint
            IF v_max IS NOT NULL AND v_count > v_max THEN
                RAISE_APPLICATION_ERROR(
                    -60003,
                    'Group ' || k || ' cannot have more than ' || v_max || ' volunteers.'
                );
            END IF;

            k := g_seen.NEXT(k);
        END LOOP;
    END AFTER STATEMENT;

END trg_check_bounds;
/

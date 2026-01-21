# Charity-association-database-sql-plsql
SQL/PL-SQL database project: data model, schema, queries, and procedures for a charity association.


Charity Association Management Database (Oracle SQL / PL-SQL)
Overview

This academic project consists of the design and implementation of a relational database for managing a charity association specialized in preparing and distributing food and hygiene packages to beneficiary families in vulnerable situations.

The system models the full operational workflow of the association, including beneficiaries, volunteers, groups, donations, stock management, package preparation, and distributions, with strong integrity constraints and automated business rules implemented in Oracle SQL and PL/SQL.

Key Features
Data Modeling & Schema

Complete relational schema derived from an Entity–Relationship model

Core entities: beneficiaries, members (volunteers/admins), groups, products, donations, packages, distributions

Extensive use of primary keys, foreign keys, and CHECK constraints

Business Logic & Integrity

Automatic package size calculation based on family composition

Enforcement of dietary regimes (vegetarian, vegan, halal/kasher, baby needs)

Product substitution rules (e.g. meat → tofu, animal milk → plant-based milk)

Prevention of invalid operations (e.g. insufficient stock, invalid package validation)

Stock & Budget Management

Products managed strictly in units (not weight or volume)

Automatic stock increment/decrement via triggers:

Donations increase stock or budget

Package preparation consumes stock

Uncollected packages are reintegrated into stock

Budget tracking with safeguards against negative balances

Controlled product purchases using available budget

Advanced PL/SQL Usage

Numerous row-level and compound triggers enforcing consistency

Triggers handling:

Group membership constraints

Stock thresholds and alerts

Package validation workflow

Distribution coherence

Beneficiary deactivation after repeated absences

Use of SQL*Loader scripts for bulk data insertion

Views & Access Control Simulation

Analytical and operational views for:

Package preparation statistics

Stock alerts

Donation and budget summaries

Volunteer activity tracking

Role-based access simulation using dedicated views:

Administrator

Group leader

Volunteer

Technologies

Oracle SQL

PL/SQL

SQL*Loader

Triggers, views, constraints, procedural logic

Database Structure (High Level)

MEMBRES, GROUPES, MEMBRE_GROUPE

BENEFICIAIRES, REGIME_ALIMENTAIRE

PRODUITS, DONS, DON_PRODUIT

COLIS, COLIS_PRODUIT

DISTRIBUTIONS

BUDGET, ACHATS

Example Functional Queries

Products below critical stock threshold

Most used products by package size

Beneficiaries by dietary regime

Groups preparing the most packages

Budget usage and donation tracking

Products reintegrated after uncollected packages

Academic Context

This project was developed as part of a database and PL/SQL coursework, with a strong focus on:

Relational modeling

Data integrity

Realistic business constraints

Automation through triggers rather than application code

How to Use

Create the schema and tables

Apply constraints and triggers

Load sample data (SQL / SQL*Loader)

Query views and test business rules through inserts/updates

Notes

This project focuses on database-side logic, not on a frontend or application layer

All constraints are enforced directly at the database level

Designed for educational purposes but follows real-world database design principles
Description:

Designed and implemented a full Oracle SQL / PL-SQL database with complex integrity constraints, triggers, stock and budget management, and role-based analytical views for a charity association.

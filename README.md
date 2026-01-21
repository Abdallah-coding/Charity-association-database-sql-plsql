# Charity-association-database-sql-plsql
SQL/PL-SQL database project: data model, schema, queries, and procedures for a charity association.


# Charity Association Management Database  
**Oracle SQL / PL-SQL**

---

## 📌 Overview
This academic project consists of the design and implementation of a **relational database for managing a charity association** specialized in preparing and distributing food and hygiene packages to beneficiary families in vulnerable situations.

The system models the full operational workflow of the association, including beneficiaries, volunteers, groups, donations, stock management, package preparation, and distributions, with strong integrity constraints and automated business rules implemented in **Oracle SQL and PL/SQL**.

---

## 🧱 Key Features

### 📐 Data Modeling & Schema
- Complete relational schema derived from an **Entity–Relationship model**
- Core entities:
  - Beneficiaries
  - Members (volunteers / admins)
  - Groups
  - Products
  - Donations
  - Packages
  - Distributions
- Extensive use of:
  - Primary keys
  - Foreign keys
  - `CHECK` constraints

---

### ⚙️ Business Logic & Integrity
- Automatic package size calculation based on family composition
- Enforcement of dietary regimes:
  - Vegetarian
  - Vegan
  - Halal / Kasher
  - Baby needs
- Product substitution rules:
  - Meat → Tofu
  - Animal milk → Plant-based milk
- Prevention of invalid operations:
  - Insufficient stock
  - Invalid package validation

---

### 📦 Stock & Budget Management
- Products managed strictly in **units** (not weight or volume)
- Automatic stock updates via triggers:
  - Donations increase stock or budget
  - Package preparation consumes stock
  - Uncollected packages are reintegrated into stock
- Budget tracking with safeguards against negative balances
- Controlled product purchases using available budget

---

### 🔧 Advanced PL/SQL Usage
- Numerous **row-level and compound triggers** enforcing consistency
- Triggers handling:
  - Group membership constraints
  - Stock threshold alerts
  - Package validation workflow
  - Distribution coherence
  - Beneficiary deactivation after repeated absences
- Bulk data insertion using **SQL\*Loader**

---

## 🗂️ Database Structure (High Level)
- `MEMBRES`, `GROUPES`, `MEMBRE_GROUPE`
- `BENEFICIAIRES`, `REGIME_ALIMENTAIRE`
- `PRODUITS`, `DONS`, `DON_PRODUIT`
- `COLIS`, `COLIS_PRODUIT`
- `DISTRIBUTIONS`
- `BUDGET`, `ACHATS`

---

## 📊 Example Functional Queries
- Products below critical stock threshold
- Most used products by package size
- Beneficiaries by dietary regime
- Groups preparing the most packages
- Budget usage and donation tracking
- Products reintegrated after uncollected packages

---

## 🎓 Academic Context
This project was developed as part of **database and PL/SQL coursework**, with a strong focus on:
- Relational modeling
- Data integrity
- Realistic business constraints
- Automation through database-side logic (triggers, procedures)

---

## ▶️ How to Use
1. Create the database schema and tables
2. Apply constraints and triggers
3. Load sample data (SQL / SQL\*Loader)
4. Execute queries and test business rules

---

## ℹ️ Notes
- This project focuses on **database-side logic**
- No frontend or application layer is included
- All business rules are enforced directly at the database level
- Designed for educational purposes following real-world database principles


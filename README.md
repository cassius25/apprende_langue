<div align="center">

![LangApp banner](./assets/banner.svg)

<br>

# 🌍 LangApp

### Application mobile d'apprentissage des langues — Flutter · Node.js · PostgreSQL

**Offline-first · Répétition espacée (SM-2) · 7 types d'exercices · Gamification**
<br>
[![Backend CI](https://github.com/cassius25/apprendre_langue/actions/workflows/backend-ci.yml/badge.svg)](https://github.com/cassius25/apprendre_langue/actions/workflows/backend-ci.yml)
[![Mobile CI](https://github.com/Ocassius25/apprendre_langue/actions/workflows/mobile-ci.yml/badge.svg)](https://github.com/cassius25/apprendre_langue/actions/workflows/mobile-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](./CONTRIBUTING.md)

**Application mobile d'apprentissage des langues**  
*Flutter · Node.js · PostgreSQL · Offline-first · Répétition espacée*

[Documentation](./docs) · [API](./docs/api.md) · [Architecture](./docs/architecture.md) · [Deploy](./deploy/README.md)

</div>

---

## 📖 Table des matières

- [Présentation](#-présentation)
- [Fonctionnalités](#-fonctionnalités)
- [Architecture](#-architecture)
- [Stack technique](#-stack-technique)
- [Structure du projet](#-structure-du-projet)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
  - [1. PostgreSQL](#1-postgresql)
  - [2. Backend (Node.js)](#2-backend-nodejs)
  - [3. Mobile (Flutter)](#3-mobile-flutter)
- [Variables d'environnement](#-variables-denvironnement)
- [Base de données](#-base-de-données)
  - [Migrations Prisma](#migrations-prisma)
  - [Seed](#seed)
- [Lancement](#-lancement)
- [Tests](#-tests)
- [Docker](#-docker)
- [Production](#-production)
- [API REST](#-api-rest)
- [Roadmap](#-roadmap)
- [Contribution](#-contribution)
- [Licence](#-licence)

---

## 🎯 Présentation

**LangApp** est une application mobile d'apprentissage des langues conçue pour être **production-ready**, **offline-first** et **scalable**. Elle permet à un utilisateur d'apprendre progressivement une langue étrangère grâce à :

- un **parcours pédagogique structuré** (Langue → Niveau CECRL → Cours → Module → Leçon) ;
- un **système de vocabulaire riche** (traductions multi-langues, phonétique, audio, exemples, images) ;
- **7 types d'exercices** corrigés côté serveur ;
- un **moteur de répétition espacée (SM-2)** avec suivi précis de chaque mot ;
- une **gamification complète** (XP, niveaux, badges, séries quotidiennes, objectifs) ;
- un **mode hors ligne intégral** synchronisé automatiquement.

L'application supporte le **français** et l'**anglais** dans son interface, et 8 langues d'apprentissage (FR, EN, ES, DE, IT, PT, AR, ZH) extensibles sans modification du code.

---

## ✨ Fonctionnalités

### 🔐 Authentification & utilisateurs
- Inscription avec prénom, nom, email, mot de passe, langue maternelle et langue à apprendre
- Connexion, déconnexion, refresh token automatique (rotation + détection de réutilisation)
- Vérification email, mot de passe oublié, changement de mot de passe
- Profil modifiable, suppression de compte (soft delete + anonymisation)
- Mots de passe sécurisés avec **Argon2id**
- RBAC avec 3 rôles : `USER`, `ADMIN`, `CONTENT_MANAGER`

### 📚 Contenu pédagogique
- Hiérarchie complète : Langue → Niveau (A1→C2) → Cours → Module → Leçon
- Contenus multi-formats : texte, markdown, image, audio, vidéo
- Leçons avec progression individuelle par utilisateur
- **Admin** : CRUD complet via API protégée

### 🗂️ Vocabulaire
- Catalogue avec filtres (langue, niveau, catégorie, recherche)
- Mots : traduction, phonétique, audio, image, exemple, catégorie
- Traductions multi-langues par mot
- Favoris, mots à réviser, historique
- État d'apprentissage : `NEW → LEARNING → REVIEW → MASTERED`

### 🎯 Exercices (7 types)
| Type | Description |
|---|---|
| `MULTIPLE_CHOICE` | QCM avec 4 options |
| `TRANSLATION` | Traduction libre (tolérance aux fautes via Levenshtein) |
| `FILL_IN_THE_BLANK` | Complétion (options ou texte) |
| `MATCHING` | Association de paires (score partiel) |
| `WORD_ORDER` | Remise en ordre (détection « bonnes briques, mauvais ordre ») |
| `LISTENING` | Écoute audio puis réponse |
| `PRONUNCIATION` | Enregistrement + validation (stub STT) |

**Correction exclusivement côté serveur** — le client ne reçoit jamais `isCorrect` ni `correctAnswer` avant soumission.

### 🔁 Répétition espacée (SM-2)
- Miroir client/serveur de l'algorithme SM-2 (`ease factor`, `interval`, `repetitions`, `success rate`, `difficulty`)
- File quotidienne de révision avec `nextReviewAt`
- Sessions batchables (`POST /reviews/batch`)
- Persistance de session (reprise après fermeture)
- Prêt pour migration vers FSRS

### 🎮 Gamification
- **XP** : gagné à chaque leçon, exercice, révision
- **Niveaux** : 1 niveau par 200 XP
- **Badges** : 6 badges (STREAK_7, STREAK_30, WORDS_100, EXERCISES_100, FIRST_LESSON, FIRST_LANGUAGE)
- **Streaks** : série actuelle, meilleure série, jours actifs
- **Objectifs quotidiens** : minutes ou mots

### 📊 Statistiques
- Vue d'ensemble : temps, mots, exercices, taux de réussite, leçons
- Activité quotidienne (chart 7 / 30 / 90 jours)
- Progression par langue et par niveau CECRL
- Progression par compétence (Vocabulary, Grammar, Listening, Reading, Speaking, Writing)

### 📡 Offline-first & synchronisation
- Base locale **Drift (SQLite)** pour toute donnée pertinente
- **Outbox** (`SyncQueueEntries`) : chaque écriture offline est enregistrée puis poussée
- Endpoint unique `POST /sync` : **push idempotent + pull incrémental**
- Résolution de conflits **last-write-wins** sur `updatedAt` (avec exception `user_progress.COMPLETED`)
- Propagation des soft deletes, résurrection par UPSERT
- Retry exponentiel, gestion réseau, indicateur d'état UI

### 🌍 Internationalisation
- Interface FR / EN avec pluriels ICU
- 8 langues d'apprentissage extensibles

---

## 🏛️ Architecture

### Architecture globale

```
┌──────────────────────────────────────────────────────────────┐
│                     FLUTTER MOBILE APP                        │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────┐ │
│  │ Presentation│→│  Domain    │→│    Data     │→│ LocalDB │ │
│  │ (Riverpod) │  │ (Usecases) │  │(Repos/Dio)  │  │ (Drift) │ │
│  └────────────┘  └────────────┘  └──────┬─────┘  └────┬───┘ │
│                                          │             │     │
│                                    ┌─────▼─────────────▼───┐ │
│                                    │    Sync Engine        │ │
│                                    └──────────┬────────────┘ │
└───────────────────────────────────────────────┼──────────────┘
                                                │ HTTPS / REST
                                    ┌───────────▼────────────┐
                                    │  NODE.JS + EXPRESS API │
                                    │  JWT · Zod · Prisma    │
                                    └───────────┬────────────┘
                                                │
                                    ┌───────────▼────────────┐
                                    │      PostgreSQL        │
                                    └────────────────────────┘
```

### Architecture Flutter (Clean Architecture + feature-first)

```
lib/
├── core/                     # Infrastructure transversale
│   ├── config/               # Environnements (dev/staging/prod)
│   ├── constants/
│   ├── errors/               # AppFailure sealed
│   ├── network/              # Dio + intercepteurs (Auth, Error, Logging)
│   ├── router/               # GoRouter
│   ├── storage/              # SecureStorage, Preferences, Drift
│   ├── sync/                 # SyncScheduler
│   ├── theme/                # Material 3
│   └── utils/                # Result, Validators, SM-2, Logger
│
├── features/                 # Feature-first
│   ├── auth/                 # {data, domain, presentation}
│   ├── onboarding/
│   ├── home/
│   ├── languages/
│   ├── courses/
│   ├── lessons/
│   ├── vocabulary/
│   ├── flashcards/
│   ├── exercises/
│   ├── review/
│   ├── goals/
│   ├── streak/
│   ├── statistics/
│   ├── profile/
│   └── sync/
│
├── l10n/                     # ARB FR/EN
├── app.dart
└── main.dart
```

Chaque feature suit le triplet **Clean Architecture** :
- `data/` — datasources (Dio / Drift), models (DTOs), repositories (implémentations)
- `domain/` — entities (pures), repositories (interfaces), usecases
- `presentation/` — pages, widgets, providers (Riverpod)

### Architecture backend (Node.js)

```
src/
├── config/                   # env (Zod), logger (Pino), prisma, swagger
├── common/
│   ├── middleware/           # auth, authorize, validate, rateLimit, errorHandler
│   ├── errors/               # AppError + HttpErrors typés
│   ├── utils/                # jwt, argon, text (fuzzy), engagement, pagination
│   └── types/                # Request augmentation
│
├── modules/
│   ├── auth/                 # register, login, refresh, logout, forgot/reset, verify
│   ├── users/                # me, patch, change-password, delete
│   ├── languages/
│   ├── courses/
│   ├── lessons/
│   ├── vocabulary/
│   ├── exercises/            # corrector + service
│   ├── reviews/              # SRS SM-2
│   ├── progress/
│   ├── streaks/
│   ├── goals/
│   ├── statistics/
│   └── synchronization/      # POST /sync
│
├── routes/                   # agrégateur /api/v1 + /health
├── app.ts
└── server.ts
```

Flux interne : **Controller → Service → Repository → Prisma → PostgreSQL**.

### Modèle de données (25 tables)

```
Identité      : users, refresh_tokens
Contenu       : languages, levels, courses, modules, lessons, lesson_contents,
                vocabulary, vocabulary_translations, vocabulary_examples,
                exercises, exercise_options
Apprentissage : user_languages, user_progress, user_vocabulary, review_sessions
Engagement    : daily_goals, daily_activity, streaks, badges, user_badges
Sync          : sync_operations
```

Toutes les tables : `id UUID`, `createdAt`, `updatedAt`, `deletedAt` (soft delete) + index et contraintes d'intégrité.

---

## 🛠️ Stack technique

| Couche | Technologie |
|---|---|
| **Mobile** | Flutter 3.24+, Dart 3.5+ |
| **State** | Riverpod 2 |
| **Router** | GoRouter 14 |
| **HTTP** | Dio 5 + intercepteurs |
| **DB locale** | Drift (SQLite) |
| **Sécurité** | flutter_secure_storage |
| **Audio** | just_audio, record |
| **UI** | Material 3, Google Fonts |
| **Backend** | Node.js 20, Express 4, TypeScript 5 |
| **ORM** | Prisma 5 |
| **Base** | PostgreSQL 16 |
| **Auth** | JWT (HS256) + Argon2id |
| **Validation** | Zod |
| **Logs** | Pino |
| **Docs API** | Swagger UI + OpenAPI |
| **Tests backend** | Jest + Supertest |
| **Tests mobile** | Flutter Test + Integration Test |
| **Conteneur** | Docker + Docker Compose |
| **Reverse proxy** | Caddy 2 (HTTPS auto) |
| **CI/CD** | GitHub Actions + GHCR |

---

## 📁 Structure du projet

```
langapp/
├── .github/
│   ├── workflows/            # CI/CD (backend-ci, mobile-ci, deploy, release)
│   └── dependabot.yml
│
├── backend/
│   ├── prisma/
│   │   ├── schema.prisma
│   │   ├── migrations/
│   │   └── seed.ts
│   ├── src/
│   ├── tests/
│   ├── Dockerfile
│   ├── Dockerfile.dev
│   ├── jest.config.js
│   ├── package.json
│   └── tsconfig.json
│
├── mobile/
│   ├── lib/
│   ├── test/
│   ├── integration_test/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml
│   └── l10n.yaml
│
├── deploy/
│   ├── Caddyfile
│   ├── README.md
│   ├── scripts/
│   │   ├── healthcheck.sh
│   │   └── backup-db.sh
│   └── systemd/
│       └── langapp-api.service
│
├── docker-compose.yml
├── docker-compose.prod.yml
├── cliff.toml
├── .gitignore
├── LICENSE
└── README.md
```

---

## 📋 Prérequis

| Outil | Version minimale | Vérification |
|---|---|---|
| **Node.js** | 20.x | `node -v` |
| **npm** | 10.x | `npm -v` |
| **PostgreSQL** | 16 | `psql --version` |
| **Flutter** | 3.24 | `flutter --version` |
| **Dart** | 3.5 | `dart --version` |
| **Git** | 2.40 | `git --version` |
| **Docker** | 24 (optionnel) | `docker --version` |
| **Docker Compose** | v2 (optionnel) | `docker compose version` |
| **Xcode** | 15+ (iOS) | `xcodebuild -version` |
| **Android Studio** | Hedgehog+ (Android) | — |

---

## 🚀 Installation

### 1. PostgreSQL

#### Option A — Local (recommandé en dev)

**macOS** :
```bash
brew install postgresql@16
brew services start postgresql@16
createdb langapp
createdb langapp_test
```

**Ubuntu/Debian** :
```bash
sudo apt update && sudo apt install postgresql-16
sudo systemctl start postgresql
sudo -u postgres createdb langapp
sudo -u postgres createdb langapp_test
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
```

**Windows** : utiliser l'installeur officiel [postgresql.org/download/windows](https://www.postgresql.org/download/windows/).

#### Option B — Docker (le plus simple)

```bash
docker run -d \
  --name langapp-postgres \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=langapp \
  -p 5432:5432 \
  -v langapp_pg_data:/var/lib/postgresql/data \
  postgres:16-alpine
```

Pour la base de test :
```bash
docker exec -it langapp-postgres createdb -U postgres langapp_test
```

---

### 2. Backend (Node.js)

```bash
cd backend

# Installation
npm install

# Configuration
cp .env.example .env
# Éditer .env (voir section Variables d'environnement)

# Générer le client Prisma
npx prisma generate

# Appliquer les migrations
npx prisma migrate deploy

# Charger les données initiales (langues, niveaux, badges, contenu démo)
npm run seed

# Lancer en dev (hot reload)
npm run dev
```

L'API est accessible sur **`http://localhost:4000`**
- Swagger UI : **`http://localhost:4000/docs`**
- Health check : **`http://localhost:4000/api/v1/health`**

---

### 3. Mobile (Flutter)

```bash
cd mobile

# Dépendances
flutter pub get

# Génération des traductions (FR/EN)
flutter gen-l10n

# Génération du code (Drift, Freezed, Riverpod)
dart run build_runner build --delete-conflicting-outputs

# Lancement (émulateur Android — pointe vers 10.0.2.2:4000)
flutter run --dart-define=APP_ENV=dev
```

**Configuration réseau par plateforme** :

| Plateforme | URL backend |
|---|---|
| Émulateur Android | `http://10.0.2.2:4000/api/v1` (par défaut) |
| Simulateur iOS | `http://localhost:4000/api/v1` (override via `--dart-define=API_DEV_URL=http://localhost:4000/api/v1`) |
| Device physique | `http://<IP_LAN>:4000/api/v1` |

**Surveillance continue du codegen** :
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## 🔑 Variables d'environnement

### Backend — `backend/.env`

```env
# ─── Node ─────────────────────────────────────────────────
NODE_ENV=development
PORT=4000
API_PREFIX=/api/v1

# ─── Database ─────────────────────────────────────────────
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/langapp?schema=public

# ─── Auth ─────────────────────────────────────────────────
JWT_ACCESS_SECRET=change-me-min-32-characters-long-secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN_DAYS=30
ARGON_MEMORY_COST=19456
ARGON_TIME_COST=2
ARGON_PARALLELISM=1

# ─── CORS ─────────────────────────────────────────────────
CORS_ORIGINS=http://localhost:3000,http://localhost:8080

# ─── Rate limit ───────────────────────────────────────────
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=200

# ─── Logs ─────────────────────────────────────────────────
LOG_LEVEL=debug
```

### Mobile — `--dart-define` au build

| Variable | Description | Défaut dev |
|---|---|---|
| `APP_ENV` | `dev` / `staging` / `prod` | `dev` |
| `API_DEV_URL` | URL API en dev | `http://10.0.2.2:4000/api/v1` |
| `API_STAGING_URL` | URL API staging | — |
| `API_PROD_URL` | URL API production | — |

Exemple : `flutter run --dart-define=APP_ENV=staging --dart-define=API_STAGING_URL=https://staging-api.example.com/api/v1`

### Production — `docker-compose.prod.yml` (`.env.production`)

```env
POSTGRES_USER=langapp
POSTGRES_PASSWORD=<secret-fort-32+>
POSTGRES_DB=langapp

API_IMAGE=ghcr.io/ORG/langapp-api:v1.0.0
JWT_ACCESS_SECRET=<secret-32-chars-min>
CORS_ORIGINS=https://api.example.com

DOMAIN=api.example.com
ACME_EMAIL=admin@example.com
```

> ⚠️ **Ne jamais commiter** un fichier `.env` ou `.env.production`. Ils sont dans `.gitignore`.

---

## 🗄️ Base de données

### Migrations Prisma

**Créer une nouvelle migration** (après modification de `schema.prisma`) :

```bash
cd backend
npx prisma migrate dev --name add_my_change
```

**Appliquer les migrations** (dev / staging / prod) :

```bash
npx prisma migrate deploy
```

**Visualiser la base** :

```bash
npx prisma studio   # http://localhost:5555
```

**Réinitialiser** (⚠️ supprime toutes les données — dev uniquement) :

```bash
npx prisma migrate reset
```

### Seed

Le seed charge :
- **8 langues** : FR, EN, ES, DE, IT, PT, AR, ZH
- **6 niveaux CECRL** : A1 → C2
- **6 badges** : STREAK_7, STREAK_30, WORDS_100, EXERCISES_100, FIRST_LESSON, FIRST_LANGUAGE
- **Contenu démo** : cours d'anglais A1 avec un module, une leçon et un QCM

```bash
cd backend
npm run seed
```

Le seed est **idempotent** (`upsert`) — on peut le relancer sans risque.

---

## ▶️ Lancement

### Développement local

**Terminal 1 — backend**
```bash
cd backend
npm run dev
```

**Terminal 2 — mobile**
```bash
cd mobile
flutter run --dart-define=APP_ENV=dev
```

### Via Docker (backend + PostgreSQL uniquement)

```bash
docker compose up -d
# API :  http://localhost:4000
# Docs : http://localhost:4000/docs
```

Le mobile reste lancé en local via `flutter run` (communique avec le backend Docker via `10.0.2.2:4000` sur émulateur Android).

---

## 🧪 Tests

### Backend (Jest + Supertest)

```bash
cd backend

# Créer la base de test
psql -U postgres -c "CREATE DATABASE langapp_test;"

# Lancer tous les tests
npm test

# Avec couverture
npm run test:cov

# Un fichier spécifique
npx jest tests/integration/auth.test.ts

# Mode watch
npm run test:watch
```

**Couverture** : 60 % branches / 70 % lignes minimum (seuils configurés dans `jest.config.js`).

**Tests inclus** :
- **Unitaires** : SM-2, Levenshtein/fuzzy, engagement (XP, streak, badges)
- **Intégration** (10 fichiers) : auth (register/login/refresh/rotation reuse), users, languages, courses-lessons, vocabulary, exercises (correction server-side), reviews (SRS), progress/streak/goals, statistics, sync (idempotence, conflit LWW)

### Mobile (Flutter Test)

```bash
cd mobile

# Tests unitaires + widgets
flutter test

# Avec couverture
flutter test --coverage

# Integration test (device/emulator requis)
flutter test integration_test/app_test.dart --dart-define=APP_ENV=dev
```

**Tests inclus** :
- **Unitaires** : SM-2 (miroir Dart), validateurs, repositories mockés (mocktail)
- **Widgets** : QualityButtons, VocabularyCard, LoginPage
- **Intégration** : bootstrap app → redirection login

### Lint & typecheck

```bash
# Backend
cd backend
npx tsc --noEmit -p tsconfig.json

# Mobile
cd mobile
flutter analyze --no-fatal-infos
```

---

## 🐳 Docker

### Stack développement

```bash
docker compose up -d                    # API + PostgreSQL
docker compose logs -f api              # Logs
docker compose down                     # Arrêt
docker compose down -v                  # Arrêt + suppression volumes
```

### Stack production

Voir [deploy/README.md](./deploy/README.md) pour le guide complet.

```bash
# Configuration
cp deploy/.env.production.example .env.production
# Éditer avec vos secrets

# Lancement
docker compose -f docker-compose.prod.yml --env-file .env.production up -d

# Migrations
docker compose -f docker-compose.prod.yml run --rm api npx prisma migrate deploy

# Healthcheck
./deploy/scripts/healthcheck.sh https://api.example.com
```

**Services inclus** :
- `postgres` — PostgreSQL 16 avec healthcheck
- `api` — image GHCR multi-arch, non-root, healthcheck intégré
- `caddy` — reverse proxy HTTPS auto (Let's Encrypt) + HSTS
- `backup` — daemon `pg_dump` avec rétention

---

## 🚢 Production

### Déploiement automatique

| Déclencheur | Cible |
|---|---|
| Push sur `main` | **Staging** (auto) |
| Tag `v*` | **Production** (approbation GitHub requise) |

```bash
# Créer une release
git tag v1.0.0
git push origin v1.0.0
# → backend-ci builds image
# → backend-deploy déploie sur prod
# → release.yml crée la GitHub Release
```

### Vérifications post-déploiement

```bash
# Health check
curl https://api.example.com/api/v1/health
# → {"success":true,"status":"ok","db":"up",...}

# Logs
ssh deploy@server
cd /opt/langapp
docker compose -f docker-compose.prod.yml logs -f api
```

### Rollback

```bash
cd /opt/langapp
export API_IMAGE=ghcr.io/ORG/langapp-api:v0.9.9
docker compose -f docker-compose.prod.yml --env-file .env.production pull api
docker compose -f docker-compose.prod.yml --env-file .env.production up -d api
```

### Sauvegardes

Automatiques (`backup` service) dans `deploy/backups/`.

Restauration :
```bash
gunzip < deploy/backups/langapp-20250115-030000.sql.gz | \
  docker compose -f docker-compose.prod.yml exec -T postgres \
  psql -U langapp -d langapp
```

### Observabilité (recommandé)

- **Logs** : Pino JSON (backend) + Caddy JSON (proxy)
- **Métriques** : Prometheus + Grafana (à ajouter)
- **Erreurs** : Sentry via `SENTRY_DSN`
- **Uptime** : UptimeRobot / BetterStack sur `/api/v1/health`
- **Alerting** : Grafana Alerting / PagerDuty

---

## 🔌 API REST

Base URL : `/api/v1`

### Authentification

| Méthode | Endpoint | Description |
|---|---|---|
| `POST` | `/auth/register` | Inscription |
| `POST` | `/auth/login` | Connexion |
| `POST` | `/auth/refresh` | Rotation tokens |
| `POST` | `/auth/logout` | Déconnexion |
| `POST` | `/auth/logout-all` | Révoquer toutes les sessions |
| `POST` | `/auth/forgot-password` | Mot de passe oublié |
| `POST` | `/auth/reset-password` | Réinitialisation |
| `POST` | `/auth/verify-email` | Vérification email |

### Utilisateur

| Méthode | Endpoint | Description |
|---|---|---|
| `GET` | `/users/me` | Profil courant |
| `PATCH` | `/users/me` | Modifier le profil |
| `POST` | `/users/me/change-password` | Changer mot de passe |
| `DELETE` | `/users/me` | Supprimer le compte |

### Contenu

| Méthode | Endpoint | Auth |
|---|---|---|
| `GET` | `/languages` | Public |
| `GET` | `/languages/:id/levels` | Public |
| `GET` | `/courses` | ✅ |
| `GET` | `/courses/:id` | ✅ |
| `GET` | `/lessons/:id` | ✅ |
| `POST` | `/lessons/:id/complete` | ✅ |

### Vocabulaire

| Méthode | Endpoint |
|---|---|
| `GET` | `/vocabulary` |
| `GET` | `/vocabulary/:id` |
| `GET` | `/vocabulary/me` |
| `GET` | `/vocabulary/me/due` |
| `POST` | `/vocabulary/me/learn` |
| `PATCH` | `/vocabulary/me/:id/favorite` |
| `PATCH` | `/vocabulary/me/:id/state` |

### Exercices

| Méthode | Endpoint |
|---|---|
| `POST` | `/exercises/:id/submit` |
| `POST` | `/exercises/lessons/:lessonId/submit` (batch) |

### Progression & engagement

| Méthode | Endpoint |
|---|---|
| `GET` | `/reviews/today` |
| `POST` | `/reviews` |
| `POST` | `/reviews/batch` |
| `GET` | `/progress` |
| `GET` | `/progress/languages/:id` |
| `GET` | `/streak` |
| `GET` | `/streak/calendar` |
| `GET` | `/goals` / `GET /goals/today` |
| `POST` | `/goals` |
| `GET` | `/statistics` |
| `GET` | `/statistics/activity` |
| `GET` | `/statistics/skills` |

### Synchronisation offline

| Méthode | Endpoint |
|---|---|
| `POST` | `/sync` |

### Docs interactives

**`http://localhost:4000/docs`** (Swagger UI)

---

## 🗺️ Roadmap

### ✅ v1.0 — Fondations (livré)

- [x] Architecture complète Flutter + Node.js + PostgreSQL
- [x] Auth JWT avec rotation refresh + Argon2id
- [x] Parcours pédagogique (Langue → Niveau → Cours → Module → Leçon)
- [x] Vocabulaire complet (traductions, exemples, audio)
- [x] 7 types d'exercices avec correction server-side
- [x] Répétition espacée SM-2
- [x] Gamification (XP, badges, streaks, objectifs)
- [x] Statistiques détaillées
- [x] Offline-first + synchronisation
- [x] Tests backend + mobile
- [x] CI/CD + Docker production

### 🔜 v1.1 — Enrichissement contenu

- [ ] Reconnaissance vocale (Speech-to-Text) pour `PRONUNCIATION`
- [ ] Upload audio/image côté admin (S3 / MinIO)
- [ ] Import de mots par CSV
- [ ] Test de niveau (placement test)
- [ ] Suggestions de mots personnalisées

### 🔜 v1.2 — Social & notifications

- [ ] Firebase Cloud Messaging (rappels quotidiens, streak danger)
- [ ] Notifications locales planifiées
- [ ] Classement (leaderboard) entre amis
- [ ] Partage de progression

### 🔮 v2.0 — Intelligence

- [ ] Algorithme FSRS (remplace SM-2)
- [ ] Génération d'exercices par LLM
- [ ] Conversations IA (chatbot pédagogique)
- [ ] Recommandations adaptatives de leçons

---

## 🤝 Contribution

Les contributions sont bienvenues ! Merci de lire [CONTRIBUTING.md](./CONTRIBUTING.md) avant d'ouvrir une PR.

### Conventions

- **Commits** : [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `docs:`, ...)
- **Branches** : `feat/xxx`, `fix/xxx`, `chore/xxx`
- **PR** : titre conventional + description + test plan
- **Code** : `flutter analyze` + `tsc --noEmit` sans erreur

### Workflow

```bash
# 1. Fork & clone
git clone https://github.com/cassius25/apprendre_langue.git
cd langapp

# 2. Branche
git checkout -b feat/ma-fonctionnalite

# 3. Développement + tests
cd backend && npm test && cd ../mobile && flutter test

# 4. Commit & push
git add .
git commit -m "feat(scope): description"
git push origin feat/ma-fonctionnalite

# 5. Ouvrir une PR sur GitHub
```

---

## 📄 Licence

Ce projet est sous licence **MIT**. Voir [LICENSE](./LICENSE).

```
MIT License

Copyright (c) 2025 LangApp Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 📞 Contact & support

- **Issues** : [github.com/cassius25/apprendre_langue/issues](https://github.com/cassius25/apprendre_langue/issues)
- **Discussions** : [github.com/cassius25/apprendre_langue/discussions](https://github.com/cassius25/apprendre_langue/discussions)
- **Email** : abaunadjicassius@gmail.com

---

<div align="center">

**Fait avec ❤️ pour les apprenants de langues**

⭐ Si ce projet vous aide, laissez une étoile !

</div>
